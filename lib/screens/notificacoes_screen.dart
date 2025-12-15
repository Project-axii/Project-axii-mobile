import 'package:flutter/material.dart';

class NotificacoesScreen extends StatefulWidget {
  const NotificacoesScreen({super.key});

  @override
  State<NotificacoesScreen> createState() => _NotificacoesScreenState();
}

class _NotificacoesScreenState extends State<NotificacoesScreen> {
  final List<Map<String, dynamic>> _notificacoes = [
    {
      'titulo': 'Rotina concluída',
      'mensagem': 'Iniciar Aula foi executada com sucesso',
      'tempo': '5 min atrás',
      'lida': false,
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'titulo': 'Dispositivo desconectado',
      'mensagem': 'Smart Lâmpada WiFi está offline',
      'tempo': '15 min atrás',
      'lida': false,
      'icon': Icons.warning,
      'color': Colors.orange,
    },
    {
      'titulo': 'Lembrete de aula',
      'mensagem': 'Sua próxima aula começa em 30 minutos',
      'tempo': '1 hora atrás',
      'lida': true,
      'icon': Icons.event,
      'color': Colors.blue,
    },
    {
      'titulo': 'Atualização disponível',
      'mensagem': 'Uma nova versão do app está disponível',
      'tempo': '2 horas atrás',
      'lida': true,
      'icon': Icons.system_update,
      'color': Colors.purple,
    },
    {
      'titulo': 'Economia de energia',
      'mensagem': 'Você economizou 25% de energia esta semana',
      'tempo': '5 horas atrás',
      'lida': true,
      'icon': Icons.energy_savings_leaf,
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final notLidas = _notificacoes.where((n) => !n['lida']).length;

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notificações',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            if (notLidas > 0)
              Text(
                '$notLidas não lida${notLidas > 1 ? 's' : ''}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          if (notLidas > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  for (var notificacao in _notificacoes) {
                    notificacao['lida'] = true;
                  }
                });
              },
              child: const Text(
                'Marcar todas',
                style: TextStyle(color: Color(0xFF8B5CF6)),
              ),
            ),
        ],
      ),
      body: _notificacoes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma notificação',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notificacoes.length,
              itemBuilder: (context, index) {
                final notificacao = _notificacoes[index];
                return _buildNotificationItem(notificacao, index);
              },
            ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notificacao, int index) {
    return Dismissible(
      key: Key('notification_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _notificacoes.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notificação removida'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: notificacao['lida']
              ? const Color(0xFF1F2937)
              : const Color(0xFF1F2937).withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: notificacao['lida']
              ? null
              : Border.all(
                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                  width: 1,
                ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              setState(() {
                notificacao['lida'] = true;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: notificacao['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      notificacao['icon'],
                      color: notificacao['color'],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notificacao['titulo'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: notificacao['lida']
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
                            ),
                            if (!notificacao['lida'])
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF8B5CF6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notificacao['mensagem'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notificacao['tempo'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
