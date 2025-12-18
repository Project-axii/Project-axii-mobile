import 'package:flutter/material.dart';
import 'adicionar_dispositivos_screen.dart';
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
          _rooms = (result['data'] ?? [])
              .where((room) =>
                  room is Map &&
                  room['name'] != null &&
                  room['name'].toString().isNotEmpty)
              .toList();
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
            _devices[index] = result['data'];
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

  Future<void> _toggleCategory(
      String roomName, String tipo, String action) async {
    final result =
        await _deviceService.toggleCategoryDevices(roomName, tipo, action);

    if (mounted) {
      if (result['success'] == true) {
        await _loadDevices(sala: _selectedRoom);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Categoria atualizada'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Erro ao atualizar categoria'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleRoomDevices(String roomName, String action) async {
    final result = await _deviceService.toggleRoomDevices(roomName, action);

    if (mounted) {
      if (result['success'] == true) {
        await _loadDevices(sala: _selectedRoom);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Sala atualizada com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Erro ao atualizar sala'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Map<String, List<dynamic>> _groupDevicesByType() {
    final Map<String, List<dynamic>> grouped = {};

    for (var device in _devices) {
      final tipo = device['tipo']?.toString() ?? 'outros';
      if (!grouped.containsKey(tipo)) {
        grouped[tipo] = [];
      }
      grouped[tipo]!.add(device);
    }

    return grouped;
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

  String _getTypeName(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'computador':
        return 'Computadores';
      case 'projetor':
        return 'Projetores';
      case 'iluminacao':
        return 'Iluminação';
      case 'ar_condicionado':
        return 'Ar Condicionado';
      default:
        return 'Outros';
    }
  }

  void _showRoomDetails(String roomName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomDetailsScreen(
          roomName: roomName,
          onRefresh: () => _loadData(),
        ),
      ),
    ).then((_) => _loadData());
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

          // Grupos Section
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
            ],
          ),
          const SizedBox(height: 16),

          // Rooms Grid
          Expanded(
            child: _isLoadingRooms
                ? const Center(child: CircularProgressIndicator())
                : _rooms.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.meeting_room_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhuma sala com dispositivos',
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
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _rooms.length,
                          itemBuilder: (context, index) {
                            final room = _rooms[index];
                            final roomName = room['name'] ?? room['sala'] ?? '';
                            final total = int.tryParse(
                                    room['devices']?.toString() ?? '0') ??
                                0;
                            final online = int.tryParse(
                                    room['online']?.toString() ?? '0') ??
                                0;
                            return _buildRoomCard(
                              context,
                              roomName,
                              total,
                              online,
                              onTap: () => _showRoomDetails(roomName),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(
    BuildContext context,
    String name,
    int totalDevices,
    int onlineDevices, {
    VoidCallback? onTap,
  }) {
    final percentage = totalDevices > 0 ? (onlineDevices / totalDevices) : 0.0;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    radius: 24,
                    child: Icon(
                      Icons.meeting_room,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: onlineDevices > 0
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$onlineDevices/$totalDevices',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: onlineDevices > 0 ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Online',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        '${(percentage * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: Colors.grey[300],
                    color: onlineDevices > 0 ? Colors.green : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Nova tela de detalhes da sala
class RoomDetailsScreen extends StatefulWidget {
  final String roomName;
  final VoidCallback onRefresh;

  const RoomDetailsScreen({
    super.key,
    required this.roomName,
    required this.onRefresh,
  });

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  final _deviceService = DeviceService();
  List<dynamic> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _deviceService.getDevices(sala: widget.roomName);

    if (mounted) {
      setState(() {
        if (result['success'] == true) {
          _devices = result['data'] ?? [];
        } else {
          _devices = [];
        }
        _isLoading = false;
      });
    }
  }

  Map<String, List<dynamic>> _groupDevicesByType() {
    final Map<String, List<dynamic>> grouped = {};

    for (var device in _devices) {
      final tipo = device['tipo']?.toString() ?? 'outros';
      if (!grouped.containsKey(tipo)) {
        grouped[tipo] = [];
      }
      grouped[tipo]!.add(device);
    }

    return grouped;
  }

  Future<void> _toggleDevice(int deviceId) async {
    final result =
        await _deviceService.toggleDevice(deviceId, action: 'toggle_status');

    if (mounted) {
      if (result['success'] == true) {
        await _loadDevices();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Status alterado'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Erro'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleCategory(String tipo, String action) async {
    final result = await _deviceService.toggleCategoryDevices(
      widget.roomName,
      tipo,
      action,
    );

    if (mounted) {
      if (result['success'] == true) {
        await _loadDevices();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Categoria atualizada'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _toggleAllDevices(String action) async {
    final result =
        await _deviceService.toggleRoomDevices(widget.roomName, action);

    if (mounted) {
      if (result['success'] == true) {
        await _loadDevices();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Sala atualizada'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _openDeviceDetails(dynamic device) {
    final status = device['status']?.toString().toLowerCase();
    final isOnline = status == 'online' || status == '1' || status == 'true';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesDispositivoScreen(
          deviceId: device['id'],
          nomeDispositivo: device['nome'] ?? 'Sem nome',
          tipoDispositivo: device['tipo'] ?? 'outros',
          isOnline: isOnline,
          sala: widget.roomName,
        ),
      ),
    ).then((_) => _loadDevices());
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

  String _getTypeName(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'computador':
        return 'Computadores';
      case 'projetor':
        return 'Projetores';
      case 'iluminacao':
        return 'Iluminação';
      case 'ar_condicionado':
        return 'Ar Condicionado';
      default:
        return 'Outros';
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedDevices = _groupDevicesByType();
    final totalDevices = _devices.length;
    final onlineDevices = _devices.where((d) {
      final status = d['status']?.toString().toLowerCase();
      return status == 'online' || status == '1' || status == 'true';
    }).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDevices,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Cabeçalho da sala com controle geral
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status Geral',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$onlineDevices de $totalDevices online',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton.filled(
                                onPressed: () => _toggleAllDevices('ligar'),
                                icon: const Icon(Icons.power_settings_new),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton.filled(
                                onPressed: () => _toggleAllDevices('desligar'),
                                icon: const Icon(Icons.power_off),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Lista de categorias
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: groupedDevices.length,
                    itemBuilder: (context, index) {
                      final tipo = groupedDevices.keys.elementAt(index);
                      final devices = groupedDevices[tipo]!;
                      final onlineCount = devices.where((d) {
                        final status = d['status']?.toString().toLowerCase();
                        return status == 'online' ||
                            status == '1' ||
                            status == 'true';
                      }).length;

                      return _buildCategoryCard(
                        tipo,
                        devices,
                        onlineCount,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCategoryCard(
      String tipo, List<dynamic> devices, int onlineCount) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: _getDeviceColor(tipo).withOpacity(0.2),
            child: Icon(
              _getDeviceIcon(tipo),
              color: _getDeviceColor(tipo),
            ),
          ),
          title: Text(
            _getTypeName(tipo),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text('$onlineCount de ${devices.length} online'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.power_settings_new, size: 20),
                onPressed: () => _toggleCategory(tipo, 'ligar'),
                color: Colors.green,
                tooltip: 'Ligar todos',
              ),
              IconButton(
                icon: const Icon(Icons.power_off, size: 20),
                onPressed: () => _toggleCategory(tipo, 'desligar'),
                color: Colors.red,
                tooltip: 'Desligar todos',
              ),
              const Icon(Icons.expand_more),
            ],
          ),
          children: devices.map((device) {
            final status = device['status']?.toString().toLowerCase();
            final isOnline =
                status == 'online' || status == '1' || status == 'true';

            return ListTile(
              leading: Icon(
                isOnline ? Icons.check_circle : Icons.circle_outlined,
                color: isOnline ? Colors.green : Colors.grey,
              ),
              title: Text(device['nome']),
              subtitle: Text(device['ip'] ?? ''),
              trailing: Switch(
                value: isOnline,
                onChanged: (value) => _toggleDevice(device['id']),
              ),
              onTap: () => _openDeviceDetails(device),
            );
          }).toList(),
        ),
      ),
    );
  }
}
