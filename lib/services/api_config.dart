import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiConfig {
  // URLs de configuração com proxy CORS para Flutter Web
  static const String configUrl =
      'https://raw.githubusercontent.com/Project-axii/Project-axii-gateway/refs/heads/main/sistema.json';
  static const String corsProxyUrl = 'https://corsproxy.io/?';

  static String? _cachedBaseUrl;
  static DateTime? _lastFetch;
  static const Duration cacheExpiration = Duration(minutes: 30);
  static bool _isInitialized = false;
  static bool _isInitializing = false;

  static const String baseRoot = '/tcc-axii/Project-Axii-api/api/';

  static const String loginEndpoint = 'login.php';
  static const String registerEndpoint = 'register.php';
  static const String forgotPasswordEndpoint = 'register.php';

  static Future<void> initialize() async {
    if (_isInitializing) {
      while (_isInitializing) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      return;
    }

    if (_isInitialized &&
        _cachedBaseUrl != null &&
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < cacheExpiration) {
      return;
    }

    _isInitializing = true;

    await _tryMultipleSources();

    _isInitializing = false;
  }

  static Future<void> _tryMultipleSources() async {
    final urlsToTry = [
      configUrl,
      '${corsProxyUrl}${Uri.encodeComponent(configUrl)}', // Com proxy CORS
      'https://api.allorigins.win/get?url=${Uri.encodeComponent(configUrl)}', // Proxy alternativo
    ];

    for (int i = 0; i < urlsToTry.length; i++) {
      final url = urlsToTry[i];

      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'User-Agent': 'Flutter App',
            if (kIsWeb) 'Access-Control-Allow-Origin': '*',
          },
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          String jsonBody = response.body;

          if (url.contains('allorigins.win')) {
            final allOriginsData = json.decode(response.body);
            jsonBody = allOriginsData['contents'] ?? '';
          }

          if (jsonBody.isNotEmpty) {
            final Map<String, dynamic> data = json.decode(jsonBody);

            if (data.containsKey('status') && data.containsKey('link')) {
              if (data['status'] == 'success' &&
                  data['link'] != null &&
                  data['link'].toString().isNotEmpty) {
                _cachedBaseUrl = data['link'].toString().trim();
                _lastFetch = DateTime.now();
                _isInitialized = true;
                return;
              }
            }
          }
        }
      } catch (e) {
        continue;
      }
    }

    _cachedBaseUrl = 'https://a7bc62effefa.ngrok-free.ap';
    _isInitialized = true;
    _lastFetch = DateTime.now();

    print('Usando URL conhecida: $_cachedBaseUrl');
  }

  static String get baseUrl {
    if (!_isInitialized || _cachedBaseUrl == null) {
      print('🚀 Auto-inicializando API (síncrono)...');
      _initializeInBackground();
      return 'https://a7bc62effefa.ngrok-free.ap';
    }
    return _cachedBaseUrl!;
  }

  static void _initializeInBackground() async {
    if (!_isInitializing && !_isInitialized) {
      await initialize();
    }
  }

  static void clearCache() {
    _cachedBaseUrl = null;
    _lastFetch = null;
    _isInitialized = false;
    _isInitializing = false;
  }

  static Future<void> refresh() async {
    clearCache();
    await initialize();
  }

  static Future<bool> testCurrentUrl() async {
    try {
      final testUrl = '$baseUrl$baseRoot$loginEndpoint';

      final response = await http
          .get(
            Uri.parse(testUrl),
            headers: defaultHeaders,
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200 || response.statusCode == 400;
    } catch (e) {
      return false;
    }
  }

  static String get loginUrl => '$baseUrl$baseRoot$loginEndpoint';
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get forgotPasswordUrl => '$baseUrl$forgotPasswordEndpoint';

  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        if (kIsWeb) 'Access-Control-Allow-Origin': '*',
      };

  static Future<http.Response> makeRequest(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    final headers = {...defaultHeaders};
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    final uri = Uri.parse(endpoint);

    switch (method.toUpperCase()) {
      case 'POST':
        return await http.post(
          uri,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
      case 'PUT':
        return await http.put(
          uri,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
      case 'DELETE':
        return await http.delete(uri, headers: headers);
      default:
        return await http.get(uri, headers: headers);
    }
  }

  static Future<http.Response> get(String endpoint) async {
    return makeRequest(endpoint, method: 'GET');
  }

  static Future<http.Response> post(
      String endpoint, Map<String, dynamic> body) async {
    return makeRequest(endpoint, method: 'POST', body: body);
  }
}
