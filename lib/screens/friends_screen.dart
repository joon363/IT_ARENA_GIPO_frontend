import 'package:flutter/material.dart';
import '../models/friend_model.dart';
import '../connections/api_calls.dart';
import '../connections/API_KEYS.dart';
import 'package:it_arena/themes.dart';
import 'package:flutter/services.dart';
import '../constants.dart';


class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  late Future<List<User>> _friendsFuture;
  final _controller = TextEditingController();
  bool isButtonEnabled = false;
  bool isWaitingForResponse = false;

  @override
  void initState() {
    super.initState();
    _friendsFuture = fetchFriends(junToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("친구 목록", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
      ),
      backgroundColor: backGround,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bool copied = false;
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              bool isButtonEnabled = false;
              final TextEditingController controller = TextEditingController();

              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text(
                      "친구의 아이디를 입력해주세요",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: TextField(
                      controller: controller,
                      maxLength: 10,
                      maxLengthEnforcement: MaxLengthEnforcement.none,
                      decoration: const InputDecoration(
                        hintText: "친구추가할 닉네임을 입력해주세요.",
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      onChanged: (value) {
                        setState(() {
                            isButtonEnabled = !isWaitingForResponse && (value.length <= 10 && value.isNotEmpty);
                          });
                      },
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isButtonEnabled ? primaryColor : gray3,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isButtonEnabled
                            ? () async {
                              setState(() {
                                  isButtonEnabled = false;
                                });
                              final nickname = controller.text.trim();
                              final success = await addFriend(nickname);
                              setState(() {
                                  isButtonEnabled = true;
                                });

                              if (success) {
                                Navigator.pop(context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('오류'),
                                    content: const Text('존재하지 않는 닉네임이거나 요청에 실패했습니다.'),
                                    actions: [
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: WidgetStateProperty.all(primaryColor.withAlpha(100)),

                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('확인', style: TextStyle(color: primaryColor),),
                                      ),
                                    ],
                                  ),
                                );
                              }
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
        backgroundColor: primaryColor,
        shape: CircleBorder(),
        elevation: 2,
        child: Icon(Icons.person_add_alt_1, color: Colors.white, size: 30,),
      ),
      body: FutureBuilder<List<User>>(
        future: _friendsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("오류 발생: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("친구가 없습니다."));
          }

          final List<User> friends = snapshot.data!;

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final User friend = friends[index];
              return Container(
                margin: EdgeInsets.only(right: 12, left: 12, top: 12),
                padding: EdgeInsets.symmetric(horizontal: 24),
                height: 87,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        spacing: 12,
                        children: [
                          Text(friend.nickname, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(friend.room, style: TextStyle(color: gray, fontSize: 12, fontWeight: FontWeight.bold),),
                              Text(friend.tel, style: TextStyle(color: gray, fontSize: 12, fontWeight: FontWeight.bold),),

                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 39,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: primaryColor
                      ),
                      child: Text(
                        SleepTypesString(friend.sleeptype),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )

                  ]
                )
              );
            },
          );
        },
      ),
    );
  }
}
