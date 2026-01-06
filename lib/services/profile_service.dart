import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ProfileService {
  static const String _keyUser = 'user';

  Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String nome,
    required String email,
  }) async {
    try {
      final response = await http
          .put(
        Uri.parse(ApiConfig.updateProfileUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': userId,
          'nome': nome,
          'email': email,
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
        if (data['user'] != null) {
          final normalizedUser = {
            'id': data['user']['id'],
            'name': data['user']['nome'],
            'email': data['user']['email'],
            'foto': data['user']['foto'],
            'tipo_usuario': data['user']['tipo_usuario'],
          };

          await _updateUserDataLocally(normalizedUser);
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Perfil atualizado com sucesso',
          'user': data['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao atualizar perfil',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> updatePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await http
          .put(
        Uri.parse(ApiConfig.updatePasswordUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': userId,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
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
        return {
          'success': true,
          'message': data['message'] ?? 'Senha atualizada com sucesso',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao atualizar senha',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> validatePasswordStrength(String password) async {
    try {
      final response = await http
          .post(
        Uri.parse(ApiConfig.validatePasswordUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
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
        return {
          'success': true,
          'strength': data['strength'],
        };
      } else {
        return {
          'success': false,
          'message': 'Erro ao validar senha',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  Future<void> _updateUserDataLocally(Map<String, dynamic> newUserData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUser, jsonEncode(newUserData));
      print('Dados do usuário atualizados localmente');
    } catch (e) {
      print('Erro ao atualizar dados localmente: $e');
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

  Future<Map<String, dynamic>> uploadPhoto({
    required String filePath,
    required String token,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return {
          'success': false,
          'message': 'Arquivo não encontrado',
        };
      }

      print('Iniciando upload da foto...');
      print('Caminho: $filePath');
      print('Token: ${token.substring(0, 20)}...');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.uploadPhotoUrl),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      String? mimeType;
      String extension = filePath.toLowerCase().split('.').last;

      switch (extension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        case 'webp':
          mimeType = 'image/webp';
          break;
        default:
          mimeType = 'image/jpeg';
      }

      var multipartFile = await http.MultipartFile.fromPath(
        'photo', 
        filePath,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);

      print('Tamanho do arquivo: ${multipartFile.length} bytes');

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Tempo de upload esgotado');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        if (data['user'] != null) {
          final normalizedUser = {
            'id': data['user']['id'],
            'name': data['user']['nome'],
            'email': data['user']['email'],
            'foto': data['user']['foto'],
            'tipo_usuario': data['user']['tipo_usuario'],
          };

          await _updateUserDataLocally(normalizedUser);
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Foto atualizada com sucesso',
          'photo_url': data['photo_url'] ?? data['foto'],
          'user': data['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao fazer upload da foto',
        };
      }
    } on SocketException catch (e) {
      print('Socket Exception: $e');
      return {
        'success': false,
        'message': 'Erro de conexão. Verifique sua internet.',
      };
    } on FormatException catch (e) {
      print('Format Exception: $e');
      return {
        'success': false,
        'message': 'Erro ao processar resposta do servidor',
      };
    } catch (e) {
      print('Erro genérico: $e');
      return {
        'success': false,
        'message': 'Erro ao fazer upload: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> deletePhoto({required String token}) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/delete-photo'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tempo de conexão esgotado');
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        if (data['user'] != null) {
          final normalizedUser = {
            'id': data['user']['id'],
            'name': data['user']['nome'],
            'email': data['user']['email'],
            'foto': null,
            'tipo_usuario': data['user']['tipo_usuario'],
          };

          await _updateUserDataLocally(normalizedUser);
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Foto removida com sucesso',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao remover foto',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro ao remover foto: ${e.toString()}',
      };
    }
  }
}
