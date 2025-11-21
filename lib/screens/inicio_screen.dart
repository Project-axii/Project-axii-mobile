import 'package:flutter/material.dart';
import 'adicionar_dispositivos_screen.dart';

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
                          builder: (context) =>
                              const AdicionarDispositivosScreen(),
                        ),
                      );
                    },
                    child: Icon(Icons.add,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.notifications_outlined,
                      color: Theme.of(context).colorScheme.onBackground),
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
              leading: const Icon(Icons.timer, color: Colors.cyan),
              title: const Text('Iniciar um timer'),
              subtitle: const Text(
                  'pode notificar você após um\ndeterminado período de tempo'),
              onTap: () {},
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
