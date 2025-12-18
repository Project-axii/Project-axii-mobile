import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'api_config.dart';

class DeviceService {
  final _authService = AuthService();

  // Listar todos os dispositivos
  Future<Map<String, dynamic>> getDevices({String? sala}) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Token não encontrado',
        };
      }

      String url = ApiConfig.devicesListUrl;
      if (sala != null && sala.isNotEmpty) {
        url += '?sala=$sala';
      }

      final response = await http.get(
        Uri.parse(url),
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
          'total': data['total'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao buscar dispositivos',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  // Listar salas
  Future<Map<String, dynamic>> getRooms() async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Token não encontrado',
        };
      }

      final response = await http.get(
        Uri.parse(ApiConfig.roomsUrl),
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
          'total': data['total'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao buscar salas',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  // Alternar status do dispositivo (ligar/desligar)
  Future<Map<String, dynamic>> toggleDevice(int deviceId,
      {String? action}) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Token não encontrado',
        };
      }

      final body = <String, dynamic>{
        'id': deviceId,
      };

      if (action != null) {
        body['action'] = action;
      }

      final response = await http
          .post(
        Uri.parse(ApiConfig.deviceToggleUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
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
          'data': data['data'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao alternar dispositivo',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  // Alternar todos os dispositivos de uma sala
  Future<Map<String, dynamic>> toggleRoomDevices(
      String roomName, String action) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Token não encontrado',
        };
      }

      final response = await http.post(
        Uri.parse(ApiConfig.deviceToggleGroupUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'sala': roomName,
          'action': action,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'message': 'Erro ao alternar grupo: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  // Alternar dispositivos de uma categoria específica em uma sala
  Future<Map<String, dynamic>> toggleCategoryDevices(
      String roomName, String tipo, String action) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Token não encontrado',
        };
      }

      final response = await http.post(
        Uri.parse(ApiConfig.deviceToggleGroupUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'sala': roomName,
          'tipo': tipo,
          'action': action,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'message': 'Erro ao alternar categoria: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  // Atualizar dispositivo
  Future<Map<String, dynamic>> updateDevice({
    required int id,
    String? nome,
    String? ip,
    String? tipo,
    String? sala,
    String? descricao,
    String? status,
  }) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Token não encontrado',
        };
      }

      final body = <String, dynamic>{'id': id};

      if (nome != null) body['nome'] = nome;
      if (ip != null) body['ip'] = ip;
      if (tipo != null) body['tipo'] = tipo;
      if (sala != null) body['sala'] = sala;
      if (descricao != null) body['descricao'] = descricao;
      if (status != null) body['status'] = status;

      final response = await http
          .put(
        Uri.parse(ApiConfig.deviceUpdateUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
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
          'data': data['data'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao atualizar dispositivo',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  // Criar novo dispositivo
  Future<Map<String, dynamic>> createDevice({
    required String nome,
    required String ip,
    required String tipo,
    required String sala,
    String? descricao,
  }) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Token não encontrado',
        };
      }

      final body = {
        'nome': nome,
        'ip': ip,
        'tipo': tipo,
        'sala': sala,
        'descricao': descricao ?? '',
      };

      final response = await http
          .post(
        Uri.parse(ApiConfig.deviceCreateUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tempo de conexão esgotado');
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao criar dispositivo',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }
}
