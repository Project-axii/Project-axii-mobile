import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class AuthService {
  static const String _keyToken = 'token';
  static const String _keyUser = 'user';
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyRememberMe = 'rememberMe';
  static const String _keyLoginTime = 'loginTime';

  Map<String, dynamic> _normalizeUserData(Map<String, dynamic> userData) {
    return {
      'id': userData['id'],
      'name': userData['name'] ?? userData['nome'],
      'email': userData['email'],
      'foto': userData['foto'],
      'tipo_usuario': userData['tipo_usuario'],
    };
  }

  Future<Map<String, dynamic>> login(String email, String password,
      {bool rememberMe = true}) async {
    try {
      final response = await http
          .post(
        Uri.parse(ApiConfig.loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tempo de conexão esgotado');
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final normalizedUser = _normalizeUserData(data['user']);

        await _saveUserData(
          data['token'],
          normalizedUser,
          rememberMe: rememberMe,
        );

        return {
          'success': true,
          'user': normalizedUser,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao fazer login',
          'code': data['code'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  Future<void> _saveUserData(String token, Map<String, dynamic> user,
      {bool rememberMe = true}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUser, jsonEncode(user));
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setBool(_keyRememberMe, rememberMe);
    await prefs.setString(_keyLoginTime, DateTime.now().toIso8601String());
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLogged = prefs.getBool(_keyIsLoggedIn) ?? false;
      final rememberMe = prefs.getBool(_keyRememberMe) ?? true;
      final token = prefs.getString(_keyToken);

      if (!isLogged || token == null || token.isEmpty) {
        return false;
      }

      if (!rememberMe) {
        await logout();
        return false;
      }

      final isValidToken = await _validateJwtToken(token);
      if (!isValidToken) {
        await logout();
        return false;
      }

      return true;
    } catch (e) {
      print('Erro ao verificar login: $e');
      return false;
    }
  }

  Future<bool> _validateJwtToken(String token) async {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return false;
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final tokenData = jsonDecode(decoded);

      if (tokenData['exp'] != null) {
        final exp = tokenData['exp'] as int;
        final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        final now = DateTime.now();

        if (now.isAfter(expirationDate.subtract(const Duration(minutes: 1)))) {
          return false;
        }
      }

      return true;
    } catch (e) {
      print('Erro ao validar token: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_keyUser);

      if (userJson != null && userJson.isNotEmpty) {
        return jsonDecode(userJson);
      }
      return null;
    } catch (e) {
      print('Erro ao obter dados do usuário: $e');
      return null;
    }
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyToken);
    } catch (e) {
      print('Erro ao obter token: $e');
      return null;
    }
  }

  Future<bool> getRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyRememberMe) ?? true;
    } catch (e) {
      print('Erro ao obter rememberMe: $e');
      return true;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyToken);
      await prefs.remove(_keyUser);
      await prefs.remove(_keyLoginTime);
      await prefs.setBool(_keyIsLoggedIn, false);
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Erro ao limpar dados: $e');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? foto,
    String? tipoUsuario,
    bool rememberMe = true,
  }) async {
    try {
      final response = await http
          .post(
        Uri.parse(ApiConfig.registerUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'foto': foto ?? '',
          'tipo_usuario': tipoUsuario ?? 'professor',
        }),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tempo de conexão esgotado');
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        final normalizedUser = _normalizeUserData(data['user']);

        await _saveUserData(
          data['token'],
          normalizedUser,
          rememberMe: rememberMe,
        );

        return {
          'success': true,
          'user': normalizedUser,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao registrar',
          'code': data['code'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.forgotPasswordUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? 'Erro ao recuperar senha',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  Future<void> renewSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLoginTime, DateTime.now().toIso8601String());
    } catch (e) {
      print('Erro ao renovar sessão: $e');
    }
  }

  Future<Duration?> getTimeSinceLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginTimeStr = prefs.getString(_keyLoginTime);

      if (loginTimeStr != null) {
        final loginTime = DateTime.parse(loginTimeStr);
        return DateTime.now().difference(loginTime);
      }

      return null;
    } catch (e) {
      print('Erro ao obter tempo desde login: $e');
      return null;
    }
  }
}
