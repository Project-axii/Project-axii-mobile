import 'package:flutter/material.dart';

class EstatisticasScreen extends StatelessWidget {
  const EstatisticasScreen({super.key});

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
          'Estatísticas',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Esta Semana',
              style: TextStyle(color: Color(0xFF8B5CF6)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'Rotinas',
                    '47',
                    'executadas',
                    Icons.refresh,
                    Colors.green,
                    '+12%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'Tempo',
                    '8.5h',
                    'economizado',
                    Icons.timer,
                    Colors.blue,
                    '+5%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'Energia',
                    '18%',
                    'economia',
                    Icons.energy_savings_leaf,
                    Colors.teal,
                    '+3%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    'Eventos',
                    '23',
                    'completados',
                    Icons.event_available,
                    Colors.purple,
                    '+8%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Most Used Devices
            const Text(
              'Dispositivos Mais Usados',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDeviceUsageItem('AXII Power Link', 85, Icons.speaker),
            _buildDeviceUsageItem('AX-LM', 72, Icons.lightbulb),
            _buildDeviceUsageItem(
                'Axii neste telefone', 58, Icons.phone_android),
            _buildDeviceUsageItem('Termostato', 45, Icons.thermostat),
            const SizedBox(height: 32),

            // Popular Routines
            const Text(
              'Rotinas Mais Executadas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildRoutineItem('Iniciar Aula', 15, 'vezes', Colors.green),
            _buildRoutineItem('Encerrar Aula', 14, 'vezes', Colors.orange),
            _buildRoutineItem('Modo Apresentação', 8, 'vezes', Colors.blue),
            _buildRoutineItem('Intervalo', 10, 'vezes', Colors.purple),
            const SizedBox(height: 32),

            // Energy Graph Placeholder
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Consumo de Energia',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Últimos 7 dias',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBarChart('Seg', 0.7),
                        _buildBarChart('Ter', 0.5),
                        _buildBarChart('Qua', 0.8),
                        _buildBarChart('Qui', 0.6),
                        _buildBarChart('Sex', 0.9),
                        _buildBarChart('Sáb', 0.3),
                        _buildBarChart('Dom', 0.2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    String change,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceUsageItem(String name, int percentage, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: const Color(0xFF374151),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineItem(String name, int count, String unit, Color color) {
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
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                unit,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(String label, double value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 32,
          height: 150 * value,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                const Color(0xFF8B5CF6),
                const Color(0xFF8B5CF6).withOpacity(0.5),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
