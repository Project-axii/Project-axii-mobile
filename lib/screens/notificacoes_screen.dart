import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificacoesScreen extends StatefulWidget {
  const NotificacoesScreen({super.key});

  @override
  State<NotificacoesScreen> createState() => _NotificacoesScreenState();
}

class _NotificacoesScreenState extends State<NotificacoesScreen> {
  final NotificationService _notificationService = NotificationService();
  List<Map<String, dynamic>> _notificacoes = [];
  bool _isLoading = true;
  int _naoLidas = 0;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _notificationService.getNotifications();

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success']) {
          _notificacoes = List<Map<String, dynamic>>.from(result['data']);
          _naoLidas = result['nao_lidas'];
        } else {
          _showErrorSnackBar(result['message']);
        }
      });
    }
  }

  Future<void> _markAsRead(int id, int index) async {
    final result = await _notificationService.markAsRead(id);

    if (result['success']) {
      setState(() {
        _notificacoes[index]['lida'] = true;
        _naoLidas = _notificacoes.where((n) => !n['lida']).length;
      });
    }
  }

  Future<void> _markAllAsRead() async {
    final result = await _notificationService.markAllAsRead();

    if (result['success']) {
      setState(() {
        for (var notificacao in _notificacoes) {
          notificacao['lida'] = true;
        }
        _naoLidas = 0;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${result['affected']} notificações marcadas como lidas'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      _showErrorSnackBar(result['message']);
    }
  }

  Future<void> _deleteNotification(int id, int index) async {
    final result = await _notificationService.deleteNotification(id);

    if (result['success']) {
      setState(() {
        final wasUnread = !_notificacoes[index]['lida'];
        _notificacoes.removeAt(index);
        if (wasUnread) {
          _naoLidas--;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notificação removida'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      _showErrorSnackBar(result['message']);
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'check_circle':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'event':
        return Icons.event;
      case 'system_update':
        return Icons.system_update;
      case 'energy_savings_leaf':
        return Icons.energy_savings_leaf;
      case 'info':
      default:
        return Icons.info;
    }
  }

  Color _getColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceAll('#', '0xFF')));
    } catch (e) {
      return const Color(0xFF8B5CF6);
    }
  }

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notificações',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            if (_naoLidas > 0)
              Text(
                '$_naoLidas não lida${_naoLidas > 1 ? 's' : ''}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadNotifications,
          ),
          if (_naoLidas > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Marcar todas',
                style: TextStyle(color: Color(0xFF8B5CF6)),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8B5CF6),
              ),
            )
          : _notificacoes.isEmpty
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
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _loadNotifications,
                        child: const Text(
                          'Atualizar',
                          style: TextStyle(color: Color(0xFF8B5CF6)),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: const Color(0xFF8B5CF6),
                  backgroundColor: const Color(0xFF1F2937),
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notificacoes.length,
                    itemBuilder: (context, index) {
                      final notificacao = _notificacoes[index];
                      return _buildNotificationItem(notificacao, index);
                    },
                  ),
                ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notificacao, int index) {
    final icon = _getIconData(notificacao['icon']);
    final color = _getColor(notificacao['color']);

    return Dismissible(
      key: Key('notification_${notificacao['id']}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1F2937),
              title: const Text(
                'Confirmar exclusão',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                'Deseja realmente excluir esta notificação?',
                style: TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Excluir',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
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
        _deleteNotification(notificacao['id'], index);
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
              if (!notificacao['lida']) {
                _markAsRead(notificacao['id'], index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: color,
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
                        if (notificacao['dispositivo'] != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.devices,
                                size: 12,
                                color: Colors.white.withOpacity(0.4),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                notificacao['dispositivo'],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
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
