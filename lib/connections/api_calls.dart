import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../models/userStatus.dart';
import '../models/friend_model.dart';

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
    UserStatus(name: 'user1', status: true, imageUrl: "https://example.com/images/user1.jpg"),
    UserStatus(name: 'user2', status: true, imageUrl: "https://example.com/images/user1.jpg"),
    UserStatus(name: 'user3', status: true, imageUrl: "https://example.com/images/user1.jpg"),
    UserStatus(name: 'user4', status: true, imageUrl: "https://example.com/images/user1.jpg"),
  ];
  return users;
  try {
    final response = await http.get(Uri.parse('https://example.com/api/userStatus'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      users = data.map((e) => UserStatus.fromJson(e)).toList();
    } else {
      print("서버 오류: ${response.statusCode}");
    }
  } catch (e) {
    print("통신 오류: $e");
  }
  return users;
}
Future<List<Friend>> fetchFriendsDummy() async {
  await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 흉내

  final dummyResponse = [
    {
      "id": "1",
      "user_id": "u001",
      "friend_id": "f001",
      "is_active": true,
      "location": "기숙사 7동 312호",
      "phone": "010-1234-5678",
      "preferSleepTime": "08:30",
      "preferWakeTime": "08:30",
      "friend_username": "김하늘"
    },
    {
      "id": "2",
      "user_id": "u001",
      "friend_id": "f002",
      "is_active": false,
      "location": "기숙사 9동 214호",
      "phone": "010-9876-5432",
      "preferSleepTime": "09:00",
      "preferWakeTime": "09:00",
      "friend_username": "이준호"
    },
    {
      "id": "3",
      "user_id": "u001",
      "friend_id": "f003",
      "is_active": true,
      "location": "기숙사 5동 120호",
      "phone": "010-5555-8888",
      "preferSleepTime": "07:45",
      "preferWakeTime": "07:45",
      "friend_username": "박지현"
    },
    {
      "id": "4",
      "user_id": "u001",
      "friend_id": "f004",
      "is_active": false,
      "location": "기숙사 3동 410호",
      "phone": "010-2222-9999",
      "preferSleepTime": "10:00",
      "preferWakeTime": "10:00",
      "friend_username": "정유진"
    },
  ];

  return dummyResponse.map((e) => Friend.fromJson(e)).toList();
}


Future<List<Friend>> fetchFriends() async {
  const url = 'https://example.com/api/friends'; // 🔸 실제 API 주소로 변경

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((data) => Friend.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load friends');
  }
}
