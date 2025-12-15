import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const axiiApp());
}

class axiiApp extends StatelessWidget {
  const axiiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'axii App',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B5CF6),
          secondary: Color(0xFF06B6D4),
          surface: Color(0xFF1F2937),
          background: Color(0xFF111827),
          onBackground: Color(0xFFF9FAFB),
          onSurface: Color(0xFFF9FAFB),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF374151),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
