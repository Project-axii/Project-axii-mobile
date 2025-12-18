import 'package:flutter/material.dart';
import 'perfil_screen.dart';
import 'listas_notas_screen.dart';
import 'alarmes_timers_screen.dart';
import 'notificacoes_screen.dart';
import '../services/auth_service.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final _authService = AuthService();
  String _userName = 'Usuário';
  String? _userPhoto;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _authService.getUserData();
    if (userData != null && mounted) {
      setState(() {
        _userName = userData['name'] ?? 'Usuário';
        _userPhoto = userData['foto'];
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bom dia';
    } else if (hour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  String _getFirstName(String fullName) {
    return fullName.split(' ').first;
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getFirstName(_userName),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PerfilScreen(),
                        ),
                      ).then((_) => _loadUserData());
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage:
                          _userPhoto != null && _userPhoto!.isNotEmpty
                              ? NetworkImage(_userPhoto!)
                              : null,
                      child: _userPhoto == null || _userPhoto!.isEmpty
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 22,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificacoesScreen(),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Atividades Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Atividades',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Ver tudo (5)'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Activities List
          Card(
            child: ListTile(
              leading: const Icon(Icons.list_alt, color: Colors.blue),
              title: const Text('Lista e notas'),
              trailing: const Icon(Icons.add_circle, color: Colors.blue),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListasNotasScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.timer, color: Colors.cyan),
              title: const Text('Iniciar um timer'),
              subtitle: const Text(
                  'o App pode notificar você após um\ndeterminado período de tempo'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AlarmesTimersScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Favoritos Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Favoritos',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Editar'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Favorites Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildFavoriteCard(
                  context,
                  'lab 1',
                  Icons.speaker,
                  false,
                ),
                _buildFavoriteCard(
                  context,
                  'Alarmes',
                  Icons.alarm,
                  true,
                  subtitle: 'Favorito sugerido',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    String title,
    IconData icon,
    bool isDashed, {
    String? subtitle,
  }) {
    return Card(
      child: Container(
        decoration: isDashed
            ? BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade600,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isDashed)
                  const Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.close, size: 16),
                  ),
                Icon(icon, size: 32, color: Colors.grey.shade400),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
