import 'package:flutter/material.dart';
import '../services/device_service.dart';

class DetalhesDispositivoScreen extends StatefulWidget {
  final int deviceId;
  final String nomeDispositivo;
  final String tipoDispositivo;
  final bool isOnline;
  final String? sala;

  const DetalhesDispositivoScreen({
    super.key,
    required this.deviceId,
    required this.nomeDispositivo,
    required this.tipoDispositivo,
    this.isOnline = true,
    this.sala,
  });

  @override
  State<DetalhesDispositivoScreen> createState() =>
      _DetalhesDispositivoScreenState();
}

class _DetalhesDispositivoScreenState extends State<DetalhesDispositivoScreen> {
  final _deviceService = DeviceService();
  final _nomeController = TextEditingController();

  bool _isLigado = true;
  double _brightness = 75.0;
  double _volume = 50.0;
  String _selectedMode = 'Normal';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLigado = widget.isOnline;
    _nomeController.text = widget.nomeDispositivo;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _toggleDevice() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _deviceService.toggleDevice(
      widget.deviceId,
      action: 'toggle_status',
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        final newStatus = result['data']['status'];
        setState(() {
          _isLigado = newStatus == 'online';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Status alterado com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Erro ao alternar dispositivo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _renameDevice() async {
    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _nomeController.text);
        return AlertDialog(
          title: const Text('Renomear Dispositivo'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Novo nome',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (newName != null &&
        newName.isNotEmpty &&
        newName != _nomeController.text) {
      setState(() {
        _isLoading = true;
      });

      final result = await _deviceService.updateDevice(
        id: widget.deviceId,
        nome: newName,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result['success'] == true) {
          setState(() {
            _nomeController.text = newName;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dispositivo renomeado com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(result['message'] ?? 'Erro ao renomear dispositivo'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  IconData _getDeviceIcon() {
    switch (widget.tipoDispositivo.toLowerCase()) {
      case 'computador':
        return Icons.computer;
      case 'projetor':
        return Icons.tv;
      case 'iluminacao':
        return Icons.lightbulb;
      case 'ar_condicionado':
        return Icons.ac_unit;
      default:
        return Icons.devices;
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
        title: Text(
          _nomeController.text,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              _showOptionsMenu(context);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Device Icon and Status
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: _isLigado
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2)
                                : const Color(0xFF1F2937),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getDeviceIcon(),
                            size: 80,
                            color: _isLigado
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _nomeController.text,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        if (widget.sala != null) ...[
                          Text(
                            widget.sala!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _isLigado ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isLigado ? 'On-line' : 'Off-line',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Power Control
                  _buildControlCard(
                    title: 'Energia',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isLigado ? 'Ligado' : 'Desligado',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Switch(
                          value: _isLigado,
                          onChanged: (value) {
                            _toggleDevice();
                          },
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Brightness Control (if applicable)
                  if (widget.tipoDispositivo.toLowerCase() == 'iluminacao')
                    _buildControlCard(
                      title: 'Brilho',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Intensidade',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${_brightness.round()}%',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor:
                                  Theme.of(context).colorScheme.primary,
                              inactiveTrackColor: Colors.grey.shade700,
                              thumbColor: Theme.of(context).colorScheme.primary,
                              overlayColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                            ),
                            child: Slider(
                              value: _brightness,
                              min: 0,
                              max: 100,
                              onChanged: _isLigado
                                  ? (value) {
                                      setState(() {
                                        _brightness = value;
                                      });
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.tipoDispositivo.toLowerCase() == 'iluminacao')
                    const SizedBox(height: 16),

                  // Mode Selection
                  _buildControlCard(
                    title: 'Modo',
                    child: Column(
                      children: [
                        _buildModeOption('Normal', Icons.lightbulb_outline),
                        const SizedBox(height: 8),
                        _buildModeOption('Economia', Icons.eco),
                        const SizedBox(height: 8),
                        _buildModeOption('Máximo', Icons.flash_on),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Actions
                  _buildControlCard(
                    title: 'Ações Rápidas',
                    child: Column(
                      children: [
                        _buildActionButton(
                          'Renomear dispositivo',
                          Icons.edit,
                          _renameDevice,
                        ),
                        const SizedBox(height: 8),
                        _buildActionButton(
                          'Adicionar ao grupo',
                          Icons.group_add,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Função em desenvolvimento'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildActionButton(
                          'Criar rotina',
                          Icons.schedule,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Função em desenvolvimento'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildControlCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildModeOption(String mode, IconData icon) {
    final isSelected = _selectedMode == mode;
    return InkWell(
      onTap: _isLigado
          ? () {
              setState(() {
                _selectedMode = mode;
              });
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade700,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              mode,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade700),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(color: Colors.white70),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2937),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text(
                  'Renomear dispositivo',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _renameDevice();
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text(
                  'Informações do dispositivo',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeviceInfo();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Remover dispositivo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeviceInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informações do Dispositivo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Nome', _nomeController.text),
            _buildInfoRow('Tipo', widget.tipoDispositivo),
            _buildInfoRow('Sala', widget.sala ?? 'Não definida'),
            _buildInfoRow('Status', _isLigado ? 'Online' : 'Offline'),
            _buildInfoRow('ID', widget.deviceId.toString()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Dispositivo'),
        content: Text(
          'Tem certeza que deseja remover "${_nomeController.text}"? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Função de remoção em desenvolvimento'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }
}
