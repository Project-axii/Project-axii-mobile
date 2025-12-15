import 'package:flutter/material.dart';
import 'perfil_screen.dart';
import 'listas_notas_screen.dart';
import 'alarmes_timers_screen.dart';
import 'notificacoes_screen.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

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
                'Início',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
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
                      );
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 18,
                      ),
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
              title: const Text('Lista de compras'),
              subtitle: const Text('1 item'),
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

          Card(
            child: ListTile(
              leading: const Icon(Icons.music_note, color: Colors.green),
              title: const Text('Vincule serviços de música'),
              subtitle: const Text(
                  'Faça o streaming de sua música favorita e\nmais.'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 24),

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
