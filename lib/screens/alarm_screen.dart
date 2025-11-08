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
              onTap: () {
                Navigator.pushNamed(context, '/alarmCamera');
              },
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
