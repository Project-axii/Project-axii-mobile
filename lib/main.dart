import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'services/api_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiConfig.initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const AxiiApp());
}

class AxiiApp extends StatelessWidget {
  const AxiiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AXII App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B5CF6),
          secondary: Color(0xFF06B6D4),
          background: Color(0xFF111827),
          surface: Color(0xFF1F2937),
          onPrimary: Colors.white,
          onSurface: Color(0xFFF9FAFB),
          onBackground: Color(0xFFF9FAFB),
        ),
        scaffoldBackgroundColor: const Color(0xFF111827),
        cardTheme: CardTheme(
          color: const Color(0xFF374151),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF8B5CF6),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFF8B5CF6)),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFF9FAFB)),
          bodyMedium: TextStyle(color: Color(0xFFF9FAFB)),
          bodySmall: TextStyle(color: Color(0xFF9CA3AF)),
          titleLarge: TextStyle(color: Color(0xFFF9FAFB)),
          titleMedium: TextStyle(color: Color(0xFFF9FAFB)),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}
