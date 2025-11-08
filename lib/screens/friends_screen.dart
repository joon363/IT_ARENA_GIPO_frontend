import 'package:flutter/material.dart';
import '../models/friend_model.dart';
import '../connections/api_calls.dart';
import 'package:it_arena/themes.dart';
import 'package:flutter/services.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  late Future<List<Friend>> _friendsFuture;
  final _controller = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _friendsFuture = fetchFriendsDummy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구 목록'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bool copied = false;
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              bool isButtonEnabled = false;
              final TextEditingController _controller = TextEditingController();

              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "내 아이디: user0",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        GestureDetector(
                          onTap: copied?null:() async {
                            await Clipboard.setData(const ClipboardData(text: "user0"));
                            setState(() {
                              copied = true;
                            });
                          },
                          child: Text(
                            copied?"복사 완료":"복사",
                            style: TextStyle(
                              color: copied?gray2:orange,
                              fontSize: 14,
                              //fontWeight: FontWeight.bold,
                              //decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    content: TextField(
                      controller: _controller,
                      maxLength: 10,
                      maxLengthEnforcement: MaxLengthEnforcement.none,
                      decoration: const InputDecoration(
                        hintText: "친구추가할 닉네임을 입력해주세요.",
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      onChanged: (value) {
                        setState(() {
                          isButtonEnabled = value.length <= 10 && value.isNotEmpty;
                        });
                      },
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isButtonEnabled ? Colors.orange : gray3,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isButtonEnabled
                              ? () {
                            Navigator.pop(context);
                          }
                              : null,
                          child: const Text(
                            "친구 추가",
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
            },
          );
        },
        backgroundColor:gray,

        shape: CircleBorder(side: BorderSide(color: orange, width: 5)),
        elevation: 2,
        child: Icon(Icons.person_add_alt_1, color: Colors.black, size: 30,),
      ),
      body: Padding(padding: EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<List<Friend>>(
          future: _friendsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('친구가 없습니다.'));
            }

            final friends = snapshot.data!;

            return ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return Container(
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: gray2,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                        Text(friend.friendUsername),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(friend.location),
                            Text('📞 ${friend.phone}'),
                          ],
                        ),
                      ],),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('선호 취침 시간:${friend.preferSleepTime}'),
                          Text('선호 기상 시간:${friend.preferWakeTime}'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),),
    );
  }
}
