import 'package:flutter/material.dart';

class ConfigDispositivosScreen extends StatefulWidget {
  const ConfigDispositivosScreen({super.key});

  @override
  State<ConfigDispositivosScreen> createState() =>
      _ConfigDispositivosScreenState();
}

class _ConfigDispositivosScreenState extends State<ConfigDispositivosScreen> {
  bool _deteccaoAutomatica = true;
  bool _conectarAutomaticamente = true;
  bool _mostrarNotificacoes = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  Text(
                    'Detecção de Dispositivos',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Detecção
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSwitchRow(
                          context,
                          title: 'Detecção automática',
                          subtitle: 'Buscar novos dispositivos automaticamente',
                          value: _deteccaoAutomatica,
                          onChanged: (value) {
                            setState(() {
                              _deteccaoAutomatica = value;
                            });
                          },
                        ),
                        const Divider(color: Colors.grey, height: 32),
                        _buildSwitchRow(
                          context,
                          title: 'Conectar automaticamente',
                          subtitle: 'Conectar a dispositivos conhecidos',
                          value: _conectarAutomaticamente,
                          onChanged: (value) {
                            setState(() {
                              _conectarAutomaticamente = value;
                            });
                          },
                        ),
                        const Divider(color: Colors.grey, height: 32),
                        _buildSwitchRow(
                          context,
                          title: 'Notificações de dispositivos',
                          subtitle:
                              'Alertar quando novos dispositivos forem encontrados',
                          value: _mostrarNotificacoes,
                          onChanged: (value) {
                            setState(() {
                              _mostrarNotificacoes = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buscar dispositivos
                  ElevatedButton.icon(
                    onPressed: () {
                      _buscarDispositivos(context);
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar novos dispositivos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Dispositivos salvos
                  Text(
                    'Dispositivos Salvos',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),

                  _buildDispositivoCard(
                    context,
                    nome: 'Lâmpada',
                    tipo: 'Iluminação',
                    icon: Icons.lightbulb_outline,
                    status: 'Conectado',
                  ),
                  _buildDispositivoCard(
                    context,
                    nome: 'Projetor Sala 1',
                    tipo: 'Projetor',
                    icon: Icons.videocam,
                    status: 'Desconectado',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade400,
                    ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildDispositivoCard(
    BuildContext context, {
    required String nome,
    required String tipo,
    required IconData icon,
    required String status,
  }) {
    final isOnline = status == 'Conectado' || status == 'Online';

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isOnline
                  ? Colors.blue.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isOnline ? Colors.blue : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  tipo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade400,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isOnline
                  ? Colors.green.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: isOnline ? Colors.green : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _buscarDispositivos(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
          _mostrarResultadoBusca(context);
        });

        return const AlertDialog(
          backgroundColor: Color(0xFF1E1E1E),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.blue),
              SizedBox(height: 16),
              Text(
                'Buscando dispositivos...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  void _mostrarResultadoBusca(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Busca concluída',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Nenhum novo dispositivo encontrado.',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
