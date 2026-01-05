import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_config.dart';
import '../services/auth_service.dart';

class ListaService {
  final AuthService _authService = AuthService();

  // Listar todas as listas
  Future<List<dynamic>> listar() async {
    try {
      final token = await _authService.getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(ApiConfig.listListUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data['data'] as List;
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  // Criar nova lista
  Future<Map<String, dynamic>> criar(Map<String, dynamic> lista) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Usuário não autenticado',
        };
      }

      final response = await http
          .post(
        Uri.parse(ApiConfig.listCreateUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(lista),
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
        'message': data['message'] ?? 'Erro ao criar lista',
        'data': data['data'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  // Atualizar lista
  Future<Map<String, dynamic>> atualizar(Map<String, dynamic> lista) async {
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
        Uri.parse(ApiConfig.listUpdateUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(lista),
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
        'message': data['message'] ?? 'Erro ao atualizar lista',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  // Deletar lista
  Future<Map<String, dynamic>> deletar(int id) async {
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
        Uri.parse(ApiConfig.listDeleteUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': id,
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
        'message': data['message'] ?? 'Erro ao deletar lista',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  // Adicionar item à lista
  Future<Map<String, dynamic>> adicionarItem(int idLista, String texto) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Usuário não autenticado',
        };
      }

      final response = await http
          .post(
        Uri.parse(ApiConfig.listItensUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id_lista': idLista,
          'texto': texto,
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
        'message': data['message'] ?? 'Erro ao adicionar item',
        'data': data['data'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  // Atualizar item
  Future<Map<String, dynamic>> atualizarItem(
      int id, int idLista, String texto, bool concluido) async {
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
        Uri.parse(ApiConfig.listItensUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': id,
          'id_lista': idLista,
          'texto': texto,
          'concluido': concluido,
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
        'message': data['message'] ?? 'Erro ao atualizar item',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  // Deletar item
  Future<Map<String, dynamic>> deletarItem(int id, int idLista) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Usuário não autenticado',
        };
      }

      final response = await http.delete(
        Uri.parse('${ApiConfig.listItensUrl}?id=$id&id_lista=$idLista'),
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

      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? 'Erro ao deletar item',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  // Toggle item concluído
  Future<Map<String, dynamic>> toggleItemConcluido(int id, int idLista) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Usuário não autenticado',
        };
      }

      final response = await http
          .post(
        Uri.parse(ApiConfig.listToggleUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': id,
          'id_lista': idLista,
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
        'message': data['message'] ?? 'Erro ao atualizar item',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }
}
