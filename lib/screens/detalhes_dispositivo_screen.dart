import 'package:flutter/material.dart';

class DetalhesDispositivoScreen extends StatefulWidget {
  final String nomeDispositivo;
  final String tipoDispositivo;
  final bool isOnline;

  const DetalhesDispositivoScreen({
    super.key,
    required this.nomeDispositivo,
    required this.tipoDispositivo,
    this.isOnline = true,
  });

  @override
  State<DetalhesDispositivoScreen> createState() =>
      _DetalhesDispositivoScreenState();
}

class _DetalhesDispositivoScreenState extends State<DetalhesDispositivoScreen> {
  bool _isLigado = true;
  double _brightness = 75.0;
  double _volume = 50.0;
  String _selectedMode = 'Normal';

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
          widget.nomeDispositivo,
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
      body: SingleChildScrollView(
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
                    widget.nomeDispositivo,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isOnline ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.isOnline ? 'On-line' : 'Off-line',
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
                      setState(() {
                        _isLigado = value;
                      });
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Brightness Control (if applicable)
            if (widget.tipoDispositivo == 'Lâmpada' ||
                widget.tipoDispositivo == 'AXII Power Link')
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
                        activeTrackColor: Theme.of(context).colorScheme.primary,
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
            if (widget.tipoDispositivo == 'Lâmpada' ||
                widget.tipoDispositivo == 'AXII Power Link')
              const SizedBox(height: 16),

            // Volume Control
            if (widget.tipoDispositivo == 'AXII Nexus' ||
                widget.tipoDispositivo == 'AXII Power Link')
              _buildControlCard(
                title: 'Volume',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nível',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${_volume.round()}%',
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
                        activeTrackColor: Theme.of(context).colorScheme.primary,
                        inactiveTrackColor: Colors.grey.shade700,
                        thumbColor: Theme.of(context).colorScheme.primary,
                        overlayColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                      ),
                      child: Slider(
                        value: _volume,
                        min: 0,
                        max: 100,
                        onChanged: _isLigado
                            ? (value) {
                                setState(() {
                                  _volume = value;
                                });
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.tipoDispositivo == 'AXII Nexus' ||
                widget.tipoDispositivo == 'AXII Power Link')
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
                    'Adicionar ao grupo',
                    Icons.group_add,
                    () {},
                  ),
                  const SizedBox(height: 8),
                  _buildActionButton(
                    'Criar rotina',
                    Icons.schedule,
                    () {},
                  ),
                  const SizedBox(height: 8),
                  _buildActionButton(
                    'Compartilhar acesso',
                    Icons.share,
                    () {},
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

  IconData _getDeviceIcon() {
    switch (widget.tipoDispositivo) {
      case 'AXII Nexus':
        return Icons.speaker;
      case 'AXII Power Link':
        return Icons.tablet_mac;
      case 'Lâmpada':
        return Icons.lightbulb;
      case 'Termostato':
        return Icons.thermostat;
      case 'Câmera':
        return Icons.videocam;
      case 'Plugue':
        return Icons.power;
      case 'Sensor':
        return Icons.sensors;
      case 'Fechadura':
        return Icons.lock;
      default:
        return Icons.devices;
    }
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
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
