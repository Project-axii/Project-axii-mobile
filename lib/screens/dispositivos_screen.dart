import 'package:flutter/material.dart';
import 'adicionar_dispositivos_screen.dart';
import 'novo_grupo_screen.dart';
import 'detalhes_dispositivo_screen.dart';
import '../services/device_service.dart';

class DispositivosScreen extends StatefulWidget {
  const DispositivosScreen({super.key});

  @override
  State<DispositivosScreen> createState() => _DispositivosScreenState();
}

class _DispositivosScreenState extends State<DispositivosScreen> {
  final _deviceService = DeviceService();

  List<dynamic> _devices = [];
  List<dynamic> _rooms = [];
  bool _isLoadingDevices = true;
  bool _isLoadingRooms = true;
  String? _selectedRoom;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadRooms();
    await _loadDevices(sala: _selectedRoom);
  }

  Future<void> _loadDevices({String? sala}) async {
    setState(() {
      _isLoadingDevices = true;
    });

    final result = await _deviceService.getDevices(sala: sala);

    if (mounted) {
      setState(() {
        if (result['success'] == true) {
          _devices = result['data'] ?? [];
        } else {
          _devices = [];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(result['message'] ?? 'Erro ao carregar dispositivos'),
              backgroundColor: Colors.red,
            ),
          );
        }
        _isLoadingDevices = false;
      });
    }
  }

  Future<void> _loadRooms() async {
    setState(() {
      _isLoadingRooms = true;
    });

    final result = await _deviceService.getRooms();

    if (mounted) {
      setState(() {
        if (result['success'] == true) {
          _rooms = result['data'] ?? [];
        } else {
          _rooms = [];
        }
        _isLoadingRooms = false;
      });
    }
  }

  Future<void> _toggleDevice(int deviceId, int index) async {
    final result =
        await _deviceService.toggleDevice(deviceId, action: 'toggle_status');

    if (mounted) {
      if (result['success'] == true) {
        setState(() {
          if (result['data'] != null && result['data'] is Map) {
            setState(() {
              _devices[index] = result['data'];
            });
          } else {
            _loadDevices(sala: _selectedRoom);
          }
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

  IconData _getDeviceIcon(String tipo) {
    switch (tipo.toLowerCase()) {
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

  Color _getDeviceColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'computador':
        return Colors.blue;
      case 'projetor':
        return Colors.purple;
      case 'iluminacao':
        return Colors.yellow;
      case 'ar_condicionado':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dispositivos',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadData,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AdicionarDispositivosScreen(),
                        ),
                      ).then((_) => _loadData());
                    },
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Grupos Section (Salas)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Salas',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              if (_selectedRoom != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedRoom = null;
                    });
                    _loadDevices();
                  },
                  child: const Text('Ver todos'),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Rooms List
          SizedBox(
            height: 120,
            child: _isLoadingRooms
                ? const Center(child: CircularProgressIndicator())
                : _rooms.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhuma sala cadastrada',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _rooms.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _rooms.length) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: _buildGroupCard(
                                context,
                                'Nova sala',
                                Icons.add,
                                true,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NovoGrupoScreen(),
                                    ),
                                  ).then((_) => _loadRooms());
                                },
                              ),
                            );
                          }

                          final room = _rooms[index];
                          final roomName = room['name'] ?? room['sala'] ?? '';
                          final total = int.tryParse(
                                  room['devices']?.toString() ?? '0') ??
                              0;
                          final online =
                              int.tryParse(room['online']?.toString() ?? '0') ??
                                  0;

                          final isSelected = _selectedRoom == roomName;

                          return Padding(
                            padding: EdgeInsets.only(
                              right: 16,
                              left: index == 0 ? 0 : 0,
                            ),
                            child: _buildRoomCard(
                              context,
                              roomName,
                              total,
                              online,
                              isSelected,
                              onTap: () {
                                setState(() {
                                  _selectedRoom = roomName;
                                });
                                _loadDevices(sala: roomName);
                              },
                            ),
                          );
                        },
                      ),
          ),
          const SizedBox(height: 32),

          // Dispositivos Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedRoom ?? 'Todos os Dispositivos',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              if (_devices.isNotEmpty)
                Text(
                  '${_devices.length} ${_devices.length == 1 ? 'dispositivo' : 'dispositivos'}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Devices List
          Expanded(
            child: _isLoadingDevices
                ? const Center(child: CircularProgressIndicator())
                : _devices.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.devices_other,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum dispositivo encontrado',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AdicionarDispositivosScreen(),
                                  ),
                                ).then((_) => _loadData());
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Adicionar Dispositivo'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.builder(
                          itemCount: _devices.length,
                          itemBuilder: (context, index) {
                            final device = _devices[index];
                            final status =
                                device['status']?.toString().toLowerCase();
                            final isOnline = status == 'online' ||
                                status == '1' ||
                                status == 'true';
                            final tipo = device['tipo']?.toString() ?? '';

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        _getDeviceColor(device['tipo'])
                                            .withOpacity(0.2),
                                    child: Icon(_getDeviceIcon(tipo),
                                        color: _getDeviceColor(tipo)),
                                  ),
                                  title: Text(device['nome']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(device['sala'] ?? 'Sem sala'),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: isOnline
                                                  ? Colors.green
                                                  : Colors.grey,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            isOnline ? 'Online' : 'Offline',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isOnline
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Switch(
                                    value: isOnline,
                                    onChanged: (value) {
                                      _toggleDevice(device['id'], index);
                                    },
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetalhesDispositivoScreen(
                                          deviceId: device['id'],
                                          nomeDispositivo: device['nome'],
                                          tipoDispositivo: device['tipo'],
                                          isOnline: isOnline,
                                          sala: device['sala'],
                                        ),
                                      ),
                                    ).then((_) =>
                                        _loadDevices(sala: _selectedRoom));
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(
    BuildContext context,
    String title,
    IconData icon,
    bool isDashed, {
    VoidCallback? onTap,
  }) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: isDashed ? Colors.transparent : Theme.of(context).cardColor,
        border: isDashed
            ? Border.all(color: Colors.grey.shade600, style: BorderStyle.solid)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: isDashed ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCard(
    BuildContext context,
    String name,
    int totalDevices,
    int onlineDevices,
    bool isSelected, {
    VoidCallback? onTap,
  }) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Theme.of(context).cardColor,
        border: isSelected
            ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.meeting_room,
                size: 32,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '$onlineDevices/$totalDevices online',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
