import 'package:flutter/material.dart';
import 'controle_sala_screen.dart';
import 'monitoramento_screen.dart';
import 'rotinas_screen.dart';
import 'listas_notas_screen.dart';
import 'alarmes_timers_screen.dart';
import 'calendario_screen.dart';
import 'configuracoes_screen.dart';
import 'adicionar_dispositivos_screen.dart';

class MaisScreen extends StatelessWidget {
  const MaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.control_camera,
        'title': 'Controle de Sala',
        'color': const Color(0xFF8B5CF6),
        'route': const ControleSalaScreen(),
      },
      {
        'icon': Icons.monitor,
        'title': 'Monitoramento',
        'color': Colors.blue,
        'route': const MonitoramentoScreen(),
      },
      {
        'icon': Icons.list_alt,
        'title': 'Listas e notas',
        'color': Colors.yellow,
        'route': const ListasNotasScreen(),
      },
      {
        'icon': Icons.lightbulb_outline,
        'title': 'Lembretes',
        'color': Colors.orange,
        'route': null,
      },
      {
        'icon': Icons.refresh,
        'title': 'Rotinas',
        'color': Colors.purple,
        'route': const RotinasScreen(),
      },
      {
        'icon': Icons.access_time,
        'title': 'Alarmes e timers',
        'color': Colors.red,
        'route': const AlarmesTimersScreen(),
      },
      {
        'icon': Icons.calendar_today,
        'title': 'Calendário',
        'color': Colors.pink,
        'route': const CalendarioScreen(),
      },
    ];

    final bottomItems = [
      {'icon': Icons.settings, 'title': 'Configurações'},
      {'icon': Icons.security, 'title': 'Privacidade'},
      {'icon': Icons.help_outline, 'title': 'Ajuda'},
    ];

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
                'Mais',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdicionarDispositivosScreen(),
                    ),
                  );
                },
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Menu Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      if (item['route'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => item['route'] as Widget,
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            color: item['color'] as Color,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item['title'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Bottom Menu
          ...bottomItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Card(
                child: InkWell(
                  onTap: () {
                    if (index == 0) {
                      // Configurações
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConfiguracoesScreen(),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item['title'] as String,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
