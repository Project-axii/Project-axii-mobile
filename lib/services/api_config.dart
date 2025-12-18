import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiConfig {
  // Arquivo remoto com a URL da API
  static const String configUrl =
      'https://raw.githubusercontent.com/Project-axii/Project-axii-gateway/refs/heads/main/sistema.json';

  static String? _cachedBaseUrl;
  static bool _isInitialized = false;
  static bool _isInitializing = false;

  // Base da API
  static const String baseRoot = '/tcc-axii/Project-Axii-api/api/';

  // Endpoints
  static const String loginEndpoint = 'auth/login.php';
  static const String registerEndpoint = 'auth/register.php';
  static const String forgotPasswordEndpoint = 'auth/forgot_password.php';
  static const String devicesListEndpoint = 'devices/list.php';
  static const String deviceToggleEndpoint = 'devices/toggle.php';
  static const String deviceToggleGroupEndpoint = 'devices/toggle_group.php';
  static const String deviceUpdateEndpoint = 'devices/update.php';
  static const String roomsEndpoint = 'devices/rooms.php';
  static const String deviceCreateEndpoint = 'devices/create.php';
  static const String notificationDeleteEndpoint = 'notifications/delete.php';
  static const String notificationMarkReadEndpoint =
      'notifications/mark_read.php';
  static const String notificationReadEndpoint = 'notifications/read.php';
  static const String validateTokenEndpoint = 'auth/validate_token.php';

  static const String fallbackBaseUrl = 'https://a7bc62effefa.ngrok-free.app';

  static Future<void> initialize() async {
    if (_isInitialized) return;

    if (_isInitializing) {
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return;
    }

    _isInitializing = true;

    try {
      final response = await http
          .get(Uri.parse(configUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 && response.body.trim().startsWith('{')) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success' &&
            data['link'] != null &&
            data['link'].toString().isNotEmpty) {
          _cachedBaseUrl = data['link'].toString().trim();
        }
      }
    } catch (_) {
      // ignora e usa fallback
    }

    _cachedBaseUrl ??= fallbackBaseUrl;
    _isInitialized = true;
    _isInitializing = false;

    print('API Base URL: $_cachedBaseUrl');
  }

  static String get baseUrl {
    if (!_isInitialized || _cachedBaseUrl == null) {
      throw Exception(
          'ApiConfig não inicializado. Chame ApiConfig.initialize() no main().');
    }
    return _cachedBaseUrl!;
  }

  static String get loginUrl => '$baseUrl$baseRoot$loginEndpoint';
  static String get registerUrl => '$baseUrl$baseRoot$registerEndpoint';
  static String get forgotPasswordUrl =>
      '$baseUrl$baseRoot$forgotPasswordEndpoint';
  static String get devicesListUrl => '$baseUrl$baseRoot$devicesListEndpoint';
  static String get deviceToggleUrl => '$baseUrl$baseRoot$deviceToggleEndpoint';
  static String get deviceToggleGroupUrl =>
      '$baseUrl$baseRoot$deviceToggleGroupEndpoint';
  static String get deviceUpdateUrl => '$baseUrl$baseRoot$deviceUpdateEndpoint';
  static String get roomsUrl => '$baseUrl$baseRoot$roomsEndpoint';
  static String get deviceCreateUrl => '$baseUrl$baseRoot$deviceCreateEndpoint';
  static String get notificationDeleteUrl =>
      '$baseUrl$baseRoot$notificationDeleteEndpoint';
  static String get notificationMarkReadUrl =>
      '$baseUrl$baseRoot$notificationMarkReadEndpoint';
  static String get notificationReadUrl =>
      '$baseUrl$baseRoot$notificationReadEndpoint';
  static String get validateTokenUrl =>
      '$baseUrl$baseRoot$validateTokenEndpoint';

  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };

  static Future<http.Response> makeRequest(
    String url, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    final finalHeaders = {...defaultHeaders};
    if (headers != null) {
      finalHeaders.addAll(headers);
    }

    final uri = Uri.parse(url);

    late http.Response response;

    switch (method.toUpperCase()) {
      case 'POST':
        response = await http.post(
          uri,
          headers: finalHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
        break;

      case 'PUT':
        response = await http.put(
          uri,
          headers: finalHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
        break;

      case 'DELETE':
        response = await http.delete(uri, headers: finalHeaders);
        break;

      default:
        response = await http.get(uri, headers: finalHeaders);
    }

    if (!response.body.trim().startsWith('{')) {
      throw Exception(
        'Resposta inválida (não é JSON):\n${response.body}',
      );
    }

    return response;
  }
}
