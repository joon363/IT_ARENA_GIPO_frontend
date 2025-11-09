// login_page.dart
import 'package:flutter/material.dart';
import '../connections/API_KEYS.dart'; // 전역 변수 import

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> users = ['노수호', '이승민', '박준혁', '강민성'];
  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading:false,title: const Text('로그인')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              hint: const Text('유저를 선택하세요'),
              value: selectedUser,
              items: users.map((String name) {
                return DropdownMenuItem<String>(
                  value: name,
                  child: Text(name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUser = value;
                });
              },
            ),
            const SizedBox(height: 200),
            ElevatedButton(
              onPressed: selectedUser == null
                  ? null
                  : () {
                // ✅ 전역 변수 값 변경
                junToken = tokens[selectedUser]??junToken_backup;
                // ✅ 다음 화면으로 이동
                Navigator.pushNamed(context, '/');
              },
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
