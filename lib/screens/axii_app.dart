import 'package:flutter/material.dart';
import 'mais_screen.dart';
import 'inicio_screen.dart';
import 'dispositivos_screen.dart';
import 'configuracoes_screen.dart';
import '../widgets/bottom_navigation.dart';

class axiiMainScreen extends StatefulWidget {
  const axiiMainScreen({super.key});

  @override
  State<axiiMainScreen> createState() => _axiiMainScreenState();
}

class _axiiMainScreenState extends State<axiiMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const InicioScreen(),
    const DispositivosScreen(),
    const MaisScreen(),
    const ConfiguracoesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _screens[_currentIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: AxiiBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
