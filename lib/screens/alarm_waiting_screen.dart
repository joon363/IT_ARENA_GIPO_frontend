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
  List<UserStatus> users = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _loadUsers(),
    );
  }

  Future<void> _loadUsers() async {
    users = await fetchUserStatuses();

    // 모든 사용자가 awake 상태인지 확인
    final allAwake = users.every((u) => u.status == true);

    if (mounted) {
      setState(() {});

      // 🔸 전부 awake이면 다이얼로그 표시
      if (allAwake) {
        _timer?.cancel();
        await showDialog(
          context: context,
          barrierDismissible: false, // 배경 터치로 닫히지 않도록
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "성공적으로 종료되었습니다",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: const SizedBox(height: 8),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // 다이얼로그 닫기
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/alarm', // 메인으로
                            (route) => false,
                      );
                    },
                    child: const Text(
                      "메인으로",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildUserTile(UserStatus user) {
    final isAwake = user.status;

    if (isAwake && user.imageUrl != null && user.imageUrl!.isNotEmpty) {
      return Container(
        color: primaryColor,
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                user.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error, size: 48, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                user.name,
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    // 자는 중(Zzz...)
    return Container(
      color: Colors.grey.shade400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Z  ", style: TextStyle(height:0,fontSize: 36, color: Colors.white)),
                const Text(" z", style: TextStyle(height:0,fontSize: 32, color: Colors.white70)),
                const Text("z", style: TextStyle(height:0,fontSize: 26, color: Colors.white54)),
              ],
            )),
          Text(
            user.name,
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("알람",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("07:15",
                style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("멤버 현황", style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),

              // ✅ 2x2 Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.8,
                  children: [
                    // 첫 칸: 나
                    Container(
                      color: primaryColor,
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(padding: EdgeInsets.all(8),
                              child: Image.file(
                                width: double.infinity,
                                fit: BoxFit.cover,
                                File(widget.imagePath)
                              ),)
                          ),
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              "me",
                              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...users.map((u) => _buildUserTile(u)).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
