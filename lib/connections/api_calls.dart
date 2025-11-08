import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../models/alarm_model.dart';
import '../models/friend_model.dart';
const String baseUrl = 'https://api.isttech.franknoh.dev/v1';

Future<bool> checkPoseSuccessFromApi(String token, {
    required String imagePath, // Flutter asset 경로
    required String alarmId, // Flutter asset 경로
  }) async {

  // 이미지 base64 인코딩
  final File imageFile = File(imagePath);
  final Uint8List imageBytes = await imageFile.readAsBytes();
  final String base64Image = base64Encode(imageBytes);

  // 요청 데이터 구성
  final Map<String, dynamic> requestData = {
    "image": base64Image,
  };
  final uri = Uri.parse('$baseUrl/media'); // 실제 API 주소로 대체
  final response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(requestData),
  );

  if (response.statusCode != 200) {
    throw Exception('API 요청 실패: ${response.statusCode}, ${response.body}');
  }

  final data = jsonDecode(response.body);
  final String imageUrl = data['image_url'];

  /////////////////// Second Phase ///////////////////

  // 요청 데이터 구성
  final Map<String, dynamic> requestData2 = {
    "image_url": imageUrl,
  };
  final uri2 = Uri.parse('$baseUrl/alarms/$alarmId/verify'); // 실제 API 주소로 대체
  final response2 = await http.post(
    uri2,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestData2),
  );

  if (response2.statusCode != 200) {
    throw Exception('API 요청 실패: ${response2.statusCode}, ${response2.body}');
  }

  final data2 = jsonDecode(response2.body);
  final bool verified = data2['verified'];
  return verified;
}

Future<List<User>> fetchFriends(String token) async {
  const url = '$baseUrl/users/friends';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((data) => Friend.fromJson(data).user).toList();
  } else {
    throw Exception('Failed to load friends: ${response.statusCode}');
  }
}


Future<List<Alarm>> fetchAlarms(String token) async {
  print("fetching alarms from API");
  const url = '$baseUrl/alarms'; // 실제 API 주소로 변경

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((data) => Alarm.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load alarms: ${response.statusCode}');
  }
}

Future<Alarm> fetchAlarm(String token, String id) async {
  final url = '$baseUrl/alarms/$id'; // 실제 API 주소로 변경

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    return Alarm.fromJson(jsonData);
  } else {
    throw Exception('Failed to load alarm: ${response.statusCode}');
  }
}

Future<void> createAlarm(String token, String name, int hour, int min, String alarmType, String challenge, List<String> memberIds) async {
  final url = '$baseUrl/alarms'; // 실제 API 주소로 변경
  print("${hour.toString()}:${min.toString()}:00.000Z");
  final Map<String, dynamic> requestData = {
    "name": name,
    "start": "${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:00.000Z",
    "alarm_type": alarmType,
    "challenge": challenge,
    "member_ids": memberIds
  };
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestData),
  );

  if (response.statusCode == 200) {
    return;
  } else {
    throw Exception('Failed to create alarm: ${response.statusCode}');
  }
}


Future<bool> addFriend(String nickname) async {
  await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 시뮬레이션
  return false; //TODO: call API
  final url = Uri.parse('$baseUrl/friends');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'nickname': nickname});

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
