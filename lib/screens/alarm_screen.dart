import 'package:flutter/material.dart';
export 'package:provider/provider.dart';

// A screen that allows users to take a picture using a given camera.
class AlarmScreen extends StatefulWidget {
  const AlarmScreen({
    super.key,
  });

  @override
  AlarmScreenState createState() => AlarmScreenState();
}

class AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
          child:Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: Colors.white10,
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                try {
                  // 🔸 카메라 초기화
                  final cameras = await availableCameras();
                  final firstCamera = cameras.first;

                  // 🔸 카메라 화면으로 직접 이동
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AlarmCameraScreen(camera: firstCamera),
                      ),
                    );
                  }
                } catch (e) {
                  debugPrint("Camera initialization failed: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("카메라 초기화에 실패했습니다.")),
                  );
                }
              }
              child: Container(
                height: 100,
                width: 100,
                color: Colors.red,
                child: Text("Camera Activation"),
              ),
            ),
          ),
        )
    );
  }
}
