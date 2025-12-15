import 'package:flutter/material.dart';

class HistoricoScreen extends StatelessWidget {
  const HistoricoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Histórico de Atividades',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDateSection(context, 'Hoje'),
          _buildActivityItem(
            context,
            'Rotina executada',
            'Iniciar Aula foi executada com sucesso',
            Icons.school,
            Colors.green,
            '10:25',
          ),
          _buildActivityItem(
            context,
            'Dispositivo conectado',
            'AXII Power Link',
            Icons.speaker,
            Colors.blue,
            '09:15',
          ),
          _buildActivityItem(
            context,
            'Controle manual',
            'Iluminação ajustada para 85%',
            Icons.lightbulb,
            Colors.yellow,
            '08:30',
          ),
          const SizedBox(height: 24),
          _buildDateSection(context, 'Ontem'),
          _buildActivityItem(
            context,
            'Rotina executada',
            'Encerrar Aula foi executada',
            Icons.logout,
            Colors.orange,
            '18:00',
          ),
          _buildActivityItem(
            context,
            'Alarme disparado',
            'Timer de 15 minutos concluído',
            Icons.alarm,
            Colors.purple,
            '15:30',
          ),
          _buildActivityItem(
            context,
            'Grupo criado',
            'Novo grupo "Sala 203" foi criado',
            Icons.group_add,
            Colors.teal,
            '10:00',
          ),
          const SizedBox(height: 24),
          _buildDateSection(context, 'Esta Semana'),
          _buildActivityItem(
            context,
            'Dispositivo removido',
            'Smart Lâmpada foi removida',
            Icons.lightbulb_outline,
            Colors.red,
            'Ter 14:20',
          ),
          _buildActivityItem(
            context,
            'Configuração alterada',
            'Notificações ativadas',
            Icons.settings,
            Colors.grey,
            'Seg 09:00',
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(BuildContext context, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        date,
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  static void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        title: const Text(
          'Filtrar Atividades',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('Todas as atividades', true),
            _buildFilterOption('Rotinas', false),
            _buildFilterOption('Dispositivos', false),
            _buildFilterOption('Configurações', false),
            _buildFilterOption('Alarmes', false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
            ),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  static Widget _buildFilterOption(String label, bool selected) {
    return CheckboxListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      value: selected,
      onChanged: (value) {},
      activeColor: const Color(0xFF8B5CF6),
      checkColor: Colors.white,
    );
  }
}
