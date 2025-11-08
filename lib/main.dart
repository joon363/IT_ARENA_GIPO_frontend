import 'package:flutter/material.dart';
import 'themes.dart';
import 'screens/home_screen.dart';
import 'screens/alarm_camera_screen.dart';
import 'screens/alarm_screen.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 카메라 리스트 가져오기
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ITARENA',
      theme: AppTheme.lightTheme(context),
      // 첫 화면: 로그인
      initialRoute: '/alarm',
      routes: {
        '/': (context) => const HomeScreen(),
        '/alarm': (context) => const AlarmScreen(),
      },
    );
  }
}
