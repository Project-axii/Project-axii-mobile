import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_config.dart';

class NotificationService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getNotifications() async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Usuário não autenticado',
        };
      }

      final response = await http.get(
        Uri.parse(ApiConfig.notificationReadUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tempo de conexão esgotado');
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'data': data['data'],
          'nao_lidas': data['nao_lidas'],
          'total': data['total'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao buscar notificações',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> markAsRead(int notificationId) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Usuário não autenticado',
        };
      }

      final response = await http
          .put(
        Uri.parse(ApiConfig.notificationMarkReadUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': notificationId,
        }),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tempo de conexão esgotado');
        },
      );

      final data = jsonDecode(response.body);

      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? 'Erro ao marcar notificação',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> markAllAsRead() async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Usuário não autenticado',
        };
      }

      final response = await http
          .put(
        Uri.parse(ApiConfig.notificationMarkReadUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'mark_all': true,
        }),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tempo de conexão esgotado');
        },
      );

      final data = jsonDecode(response.body);

      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? 'Erro ao marcar notificações',
        'affected': data['affected'] ?? 0,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> deleteNotification(int notificationId) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Usuário não autenticado',
        };
      }

      final response = await http
          .delete(
        Uri.parse(ApiConfig.notificationDeleteUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': notificationId,
        }),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tempo de conexão esgotado');
        },
      );

      final data = jsonDecode(response.body);

      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? 'Erro ao deletar notificação',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  static IconData getIconForType(String type) {
    switch (type) {
      case 'sucesso':
        return Icons.check_circle;
      case 'erro':
        return Icons.error;
      case 'aviso':
        return Icons.warning;
      case 'info':
      default:
        return Icons.info;
    }
  }

  static Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }
}
