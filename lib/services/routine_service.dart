import 'dart:convert';
import 'package:axii/services/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class RotinaService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  // Listar todas as rotinas
  Future<List<dynamic>> listarRotinas() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(ApiConfig.routineListUrl),
        headers: headers,
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data'] ?? [];
        } else {
          throw Exception(data['message'] ?? 'Erro ao listar rotinas');
        }
      } else {
        throw Exception('Erro ao listar rotinas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro em listarRotinas: $e');
      rethrow;
    }
  }

  // Buscar dispositivos disponíveis
  Future<List<dynamic>> listarDispositivos() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(ApiConfig
            .devicesListUrl), // Você precisa adicionar essa URL no ApiConfig
        headers: headers,
      );

      print('Listar Dispositivos - Status: ${response.statusCode}');
      print('Listar Dispositivos - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data'] ?? [];
        }
      }
      return [];
    } catch (e) {
      print('Erro em listarDispositivos: $e');
      return [];
    }
  }

  // Buscar grupos disponíveis
  Future<List<dynamic>> listarGrupos() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(ApiConfig
            .groupListUrl), // Você precisa adicionar essa URL no ApiConfig
        headers: headers,
      );

      print('Listar Grupos - Status: ${response.statusCode}');
      print('Listar Grupos - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data'] ?? [];
        }
      }
      return [];
    } catch (e) {
      print('Erro em listarGrupos: $e');
      return [];
    }
  }

  // Criar nova rotina
  Future<bool> criarRotina(Map<String, dynamic> rotina) async {
    try {
      final headers = await _getHeaders();

      print('Criando rotina com dados: ${json.encode(rotina)}');

      final response = await http.post(
        Uri.parse(ApiConfig.routineCreateUrl),
        headers: headers,
        body: json.encode(rotina),
      );

      print('Criar Rotina - Status: ${response.statusCode}');
      print('Criar Rotina - Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Erro ao criar rotina');
      }
    } catch (e) {
      print('Erro em criarRotina: $e');
      rethrow;
    }
  }

  // Atualizar rotina
  Future<bool> atualizarRotina(Map<String, dynamic> rotina) async {
    try {
      final headers = await _getHeaders();

      print('Atualizando rotina com dados: ${json.encode(rotina)}');

      final response = await http.put(
        Uri.parse(ApiConfig.routineUpdateUrl),
        headers: headers,
        body: json.encode(rotina),
      );

      print('Atualizar Rotina - Status: ${response.statusCode}');
      print('Atualizar Rotina - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Erro ao atualizar rotina');
      }
    } catch (e) {
      print('Erro em atualizarRotina: $e');
      rethrow;
    }
  }

  // Deletar rotina
  Future<bool> deletarRotina(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConfig.routineDeleteUrl}?id=$id'),
        headers: headers,
      );

      print('Deletar Rotina - Status: ${response.statusCode}');
      print('Deletar Rotina - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Erro ao deletar rotina');
      }
    } catch (e) {
      print('Erro em deletarRotina: $e');
      rethrow;
    }
  }

  // Alternar status ativo/inativo
  Future<bool> toggleRotina(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(ApiConfig.routineToggleUrl),
        headers: headers,
        body: json.encode({'id': id}),
      );

      print('Toggle Rotina - Status: ${response.statusCode}');
      print('Toggle Rotina - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Erro ao alterar status');
      }
    } catch (e) {
      print('Erro em toggleRotina: $e');
      rethrow;
    }
  }

  // Executar rotina
  Future<bool> executarRotina(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(ApiConfig.routineExecutetUrl),
        headers: headers,
        body: json.encode({'id': id}),
      );

      print('Executar Rotina - Status: ${response.statusCode}');
      print('Executar Rotina - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Erro ao executar rotina');
      }
    } catch (e) {
      print('Erro em executarRotina: $e');
      rethrow;
    }
  }

  // Mapear ícone baseado no nome da rotina
  IconData getIconForRotina(String nome) {
    final nomeLower = nome.toLowerCase();

    if (nomeLower.contains('aula') || nomeLower.contains('iniciar')) {
      return Icons.school;
    } else if (nomeLower.contains('encerrar') ||
        nomeLower.contains('desligar')) {
      return Icons.logout;
    } else if (nomeLower.contains('apresentação') ||
        nomeLower.contains('projetor')) {
      return Icons.present_to_all;
    } else if (nomeLower.contains('intervalo') || nomeLower.contains('pausa')) {
      return Icons.coffee;
    } else if (nomeLower.contains('manhã') || nomeLower.contains('ligar')) {
      return Icons.wb_sunny;
    } else if (nomeLower.contains('noite') || nomeLower.contains('tarde')) {
      return Icons.nightlight;
    } else {
      return Icons.schedule;
    }
  }

  // Formatar dias da semana
  String formatarDiasSemana(List<dynamic> dias) {
    final diasMap = {
      'domingo': 'Dom',
      'segunda': 'Seg',
      'terca': 'Ter',
      'quarta': 'Qua',
      'quinta': 'Qui',
      'sexta': 'Sex',
      'sabado': 'Sáb',
    };

    return dias.map((d) => diasMap[d] ?? d).join(', ');
  }
}
