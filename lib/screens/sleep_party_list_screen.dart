import 'package:flutter/material.dart';
import 'package:it_arena/connections/API_KEYS.dart';
import '../connections/api_calls.dart';
import '../constants.dart';
import '../models/alarm_model.dart';
import '../themes.dart';
import 'package:flutter/cupertino.dart';
class SleepPartyListScreen extends StatefulWidget {
  const SleepPartyListScreen({super.key});

  @override
  State<SleepPartyListScreen> createState() => _SleepPartyListScreenState();
}

class _SleepPartyListScreenState extends State<SleepPartyListScreen> {
  late final Future<List<Alarm>> _alarmPartiesFuture;
  List<Alarm> alarms = [];
  Duration duration = const Duration(hours: 1, minutes: 30);
  int selectedHour = 0;
  int selectedMinute = 0;
  bool onInit = true;
  final List<int> hours = List.generate(24, (index) => index);
  final List<int> minutes = [0, 15, 30, 45];

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts
  // a CupertinoTimerPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.only(top: 6.0),
        // The bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: Material(
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("수면팟 생성하기", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                Text("기상 알람 시간을 설정해주세요", style: TextStyle(fontSize: 18, color: gray),),
                child,
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            highlightColor: Colors.white10,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,  // ✅ InkWell이 전체 채우게
                              //height: double.infinity, // ✅ 높이도 맞춰줌
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: Text(
                                "취소",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )

                    ),
                    Expanded(child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            highlightColor: Colors.red,
                            onTap: () async {
                              await createAlarm(
                                junToken,
                                "alarmTest",
                                selectedHour,
                                selectedMinute,
                                "date",
                                "pose_1",
                                [
                                  "0b6ea4fd-7182-41cc-a9a4-93dc9ab6e950",
                                  "7f27800b-c7ab-4cf5-ba33-14739aa11ca8"
                                ]
                              );
                              var res = await fetchAlarms(junToken);
                              setState(() {
                                  alarms = res;
                                });
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,  // ✅ InkWell이 전체 채우게
                              //height: double.infinity, // ✅ 높이도 맞춰줌
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: Text(
                                "확인",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )

                    ),
                  ],
                ),
                SizedBox(height: 50,)
              ],)
          ),
        )
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _alarmPartiesFuture = fetchAlarms(junToken);
  }

  @override
  Widget build(BuildContext context) {
    const double itemExtent = 40.0;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text("수면팟 목록", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      backgroundColor: backGround,
      body: FutureBuilder<List<Alarm>>(
        future: _alarmPartiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("오류 발생: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("참여 가능한 파티가 없습니다."));
          }
          if (onInit) {
            final List<Alarm> a = snapshot.data!;
            alarms = a;
            onInit = false;
          }

          return ListView.builder(
            itemCount: alarms.length,
            itemBuilder: (context, index) {
              final Alarm alarm = alarms[index];
              bool isParticipated = false;
              for (Member member in alarm.members){
                if (member.userId == junToken) {
                  if (member.verified) {
                    isParticipated = true;
                  }
                }
              }
              return Container(
                margin: EdgeInsets.only(right: 12, left: 12, top: 12),
                padding: EdgeInsets.symmetric(horizontal: 24),
                height: 100,
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
                          SizedBox(width: 95,
                            child:
                            Text(formatDuration(alarm.start), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Padding(padding: EdgeInsets.symmetric(vertical: 8),
                              child: SingleChildScrollView(
                                child: Text(alarm.members.map((m) => m.nickname).join('\n'),
                                  style: TextStyle(color: gray, fontSize: 14, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Material(
                          color: isParticipated ? gray : primaryColor,
                          borderRadius: BorderRadius.circular(8),
                          elevation: 0,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            enableFeedback: !isParticipated,
                            onTap: isParticipated
                                ? null
                                : () {
                              //TODO: call API;
                            },
                            splashColor: isParticipated ? Colors.transparent : null,
                            highlightColor: isParticipated ? Colors.transparent : null,
                            child: Container(
                              height: 39,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              alignment: Alignment.center,
                              child: Text(
                                isParticipated ? "이미 참여함" : "참여하기",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(onPressed: () async{
                          await deleteAlarm(junToken,alarm.id);
                          var res = await fetchAlarms(junToken);
                          setState(() {
                            alarms = res;
                          });
                        }, icon: Icon(CupertinoIcons.delete))

                      ],
                    )
                  ]
                )
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(
            SizedBox(
              height: 200,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 시 Picker
                  Expanded(
                    child: CupertinoPicker(
                      magnification: 1.2,
                      squeeze: 1.1,
                      useMagnifier: true,
                      itemExtent: itemExtent,
                      scrollController: FixedExtentScrollController(initialItem: selectedHour),
                      onSelectedItemChanged: (int index) {
                        setState(() => selectedHour = index);
                      },
                      children: List<Widget>.generate(
                        hours.length,
                        (int index) => Center(child: Text('${hours[index]}시')),
                      ),
                    ),
                  ),
                  // 분 Picker
                  Expanded(
                    child: CupertinoPicker(
                      magnification: 1.2,
                      squeeze: 1.1,
                      useMagnifier: true,
                      itemExtent: itemExtent,
                      scrollController: FixedExtentScrollController(
                        initialItem: minutes.indexOf(selectedMinute),
                      ),
                      onSelectedItemChanged: (int index) {
                        setState(() => selectedMinute = minutes[index]);
                      },
                      children: List<Widget>.generate(
                        minutes.length,
                        (int index) => Center(child: Text('${minutes[index]}분')),
                      ),
                    ),
                  ),
                ],
              ),
            )
          );
        },
        backgroundColor: primaryColor,

        shape: CircleBorder(),
        elevation: 2,
        child: Icon(Icons.alarm_add, color: Colors.white, size: 30,),
      ),
    );
  }
}
