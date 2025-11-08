import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ITARENA',
      theme: AppTheme.lightTheme(context),
      // 첫 화면: 로그인
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen()
      },
    );
  }
}
