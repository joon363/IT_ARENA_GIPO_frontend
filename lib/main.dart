import 'package:flutter/material.dart';
import 'themes.dart';
import 'screens/home_screen.dart';
import 'screens/alarm_screen.dart';
import 'screens/sleep_method_list.dart';
import 'screens/sleep_method_normal.dart';
import 'screens/sleep_method_Ronaldo.dart';
import 'screens/sleep_method_Dwayne.dart';
import 'screens/sleep_method_Davinci.dart';

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
        '/sleep_method_normal': (context) => const SleepMethodNormalScreen(),
        '/sleep_method_Ronaldo': (context) => const SleepMethodRonaldoScreen(),
        '/sleep_method_Dwayne': (context) => const SleepMethodDwayneScreen(),
        '/sleep_method_Davinci': (context) => const SleepMethodDavinciScreen(),
      },
    );
  }
}
