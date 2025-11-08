import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import '../connections/api_calls.dart';
import '../themes.dart';
import 'dart:convert';
export 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../models/userStatus.dart';

// A widget that displays the picture taken by the user.
class AlarmWaitingScreen extends StatefulWidget {
  final String imagePath;
  const AlarmWaitingScreen({super.key, required this.imagePath});

  @override
  State<AlarmWaitingScreen> createState() => _AlarmWaitingScreenState();
}

class _AlarmWaitingScreenState extends State<AlarmWaitingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container()
    );
  }
}
