import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../models/userStatus.dart';

Future<bool> checkPoseSuccessFromApi({
  required String imagePath, // Flutter asset 경로
  required String refImagePath, // Flutter asset 경로
}) async {
  return true;

  // 이미지 base64 인코딩
  final File imageFile = File(imagePath);
  final Uint8List imageBytes = await imageFile.readAsBytes();
  final String base64Image = base64Encode(imageBytes);

  final File refImageFile = File(refImagePath);
  final Uint8List refImageBytes = await refImageFile.readAsBytes();
  final String base64refImage = base64Encode(refImageBytes);


  // 요청 데이터 구성
  final Map<String, dynamic> requestData = {
    "image": base64Image,
    "refImage": base64refImage,
  };
  final uri = Uri.parse("http://10.50.33.65:5001/process_image"); // 실제 API 주소로 대체
  final response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(requestData),
  );

  if (response.statusCode != 200) {
    throw Exception('API 요청 실패: ${response.statusCode}, ${response.body}');
  }

  final data = jsonDecode(response.body);
  final bool judgement = data['result'];
  return judgement;
}

Future<List<UserStatus>> fetchUserStatuses() async {

  List<UserStatus> users = [
    UserStatus(name: 'user1', status: false),
    UserStatus(name: 'user2', status: true),
    UserStatus(name: 'user3', status: false),
    UserStatus(name: 'user4', status: true),
  ];
  return users;
  try {
    final response = await http.get(Uri.parse('https://example.com/api/users'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      users = data.map((e) => UserStatus.fromJson(e)).toList();
    }
  } catch (e) {
    print('API Error: $e');
  }
  return users;
}