import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const SmartRetailApp());
}

class SmartRetailApp extends StatelessWidget {
  const SmartRetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartRetail POS',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD9DEE7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
