import 'package:flutter/material.dart';

class AlarmesTimersScreen extends StatefulWidget {
  const AlarmesTimersScreen({super.key});

  @override
  State<AlarmesTimersScreen> createState() => _AlarmesTimersScreenState();
}

class _AlarmesTimersScreenState extends State<AlarmesTimersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _alarmes = [
    {
      'hora': '07:30',
      'label': 'Início das aulas',
      'ativo': true,
      'dias': 'Seg-Sex'
    },
    {'hora': '12:00', 'label': 'Intervalo', 'ativo': true, 'dias': 'Seg-Sex'},
    {
      'hora': '17:30',
      'label': 'Fim das aulas',
      'ativo': true,
      'dias': 'Seg-Sex'
    },
    {
      'hora': '09:00',
      'label': 'Reunião semanal',
      'ativo': false,
      'dias': 'Segunda'
    },
  ];

  final List<Map<String, dynamic>> _timers = [
    {'nome': 'Duração da aula', 'tempo': 50, 'ativo': false},
    {'nome': 'Intervalo', 'tempo': 15, 'ativo': false},
    {'nome': 'Tempo de prova', 'tempo': 120, 'ativo': false},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Alarmes e Timers',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF8B5CF6),
          labelColor: const Color(0xFF8B5CF6),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Alarmes'),
            Tab(text: 'Timers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAlarmesTab(),
          _buildTimersTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            _adicionarAlarme();
          } else {
            _adicionarTimer();
          }
        },
        backgroundColor: const Color(0xFF8B5CF6),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAlarmesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Configure alarmes para eventos importantes',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),
        ..._alarmes.map((alarme) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildAlarmeCard(alarme),
            )),
      ],
    );
  }

  Widget _buildTimersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Timers rápidos para controlar o tempo',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),
        ..._timers.map((timer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTimerCard(timer),
            )),
      ],
    );
  }

  Widget _buildAlarmeCard(Map<String, dynamic> alarme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alarme['hora'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alarme['label'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alarme['dias'],
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: alarme['ativo'],
            onChanged: (value) {
              setState(() {
                alarme['ativo'] = value;
              });
            },
            activeColor: const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard(Map<String, dynamic> timer) {
    final minutos = timer['tempo'] as int;
    final horas = minutos ~/ 60;
    final mins = minutos % 60;
    final tempoFormatado = horas > 0 ? '${horas}h ${mins}min' : '${mins}min';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.timer,
              color: Color(0xFF8B5CF6),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timer['nome'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tempoFormatado,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _iniciarTimer(timer);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Iniciar'),
          ),
        ],
      ),
    );
  }

  void _adicionarAlarme() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Adicionar novo alarme'),
        backgroundColor: Color(0xFF8B5CF6),
      ),
    );
  }

  void _adicionarTimer() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Adicionar novo timer'),
        backgroundColor: Color(0xFF8B5CF6),
      ),
    );
  }

  void _iniciarTimer(Map<String, dynamic> timer) {
    setState(() {
      timer['ativo'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Timer "${timer['nome']}" iniciado'),
        backgroundColor: const Color(0xFF8B5CF6),
      ),
    );
  }
}
