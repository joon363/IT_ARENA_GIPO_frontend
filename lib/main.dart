import 'package:flutter/material.dart';
import 'themes.dart';
import 'screens/home_screen.dart';
import 'screens/alarm_screen.dart';
import 'screens/sleep_method_list.dart';

void main()  {
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
        '/': (context) => const HomeScreen(),
        '/alarm': (context) => const AlarmScreen(),
        '/sleep_method_list': (context) => const SleepMethodListScreen(),
      },
    );
  }
}
