import 'package:flutter/material.dart';
import 'package:frontend/home.dart';
import 'package:frontend/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Papa\'s Restoranto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red[600]!,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red[600],
        ),
      ),
      home: HomePage(
        isDarkTheme: false,
        title: 'user123',
      ),
    );
  }
}
