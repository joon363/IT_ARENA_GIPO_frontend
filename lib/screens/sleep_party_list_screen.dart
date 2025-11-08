import 'package:flutter/material.dart';
import '../connections/api_calls.dart';
import '../models/party_model.dart';
import '../themes.dart';
import 'package:flutter/cupertino.dart';
class SleepPartyListScreen extends StatefulWidget {
  const SleepPartyListScreen({super.key});

  @override
  State<SleepPartyListScreen> createState() => _SleepPartyListScreenState();
}

class _SleepPartyListScreenState extends State<SleepPartyListScreen> {
  late Future<List<AlarmParty>> _alarmPartiesFuture;
  Duration duration = const Duration(hours: 1, minutes: 30);
  int selectedHour = 0;
  int selectedMinute = 0;
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
                            //highlightColor: Colors.white10,
                            onTap: () {
                              // TODO: 서버에 요청
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
    _alarmPartiesFuture = fetchAlarmParties();
  }

  @override
  Widget build(BuildContext context) {
    const double itemExtent = 40.0;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text("수면팟 목록", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      backgroundColor: backGround,
      body: FutureBuilder<List<AlarmParty>>(
        future: _alarmPartiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("오류 발생: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("참여 가능한 파티가 없습니다."));
          }

          final parties = snapshot.data!;

          return ListView.builder(
            itemCount: parties.length,
            itemBuilder: (context, index) {
              final party = parties[index];
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
                          SizedBox(width: 95,
                            child:
                            Text(party.time, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                              child: Padding(padding: EdgeInsets.symmetric(vertical: 8),
                              child: SingleChildScrollView(
                                child: Text(party.members.join('\n'),
                                  style: TextStyle(color: gray, fontSize: 14, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
                              ),
                              )
                          )
                        ],
                      ),
                    ),
                    Material(
                      color: party.isParticipating ? gray : primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      elevation: 0,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        enableFeedback: !party.isParticipating,
                        onTap: party.isParticipating
                          ? null
                          : () {
                            //TODO: call API;
                          },
                        splashColor: party.isParticipating ? Colors.transparent : null,
                        highlightColor: party.isParticipating ? Colors.transparent : null,
                        child: Container(
                          height: 39,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          child: Text(
                            party.isParticipating ? "이미 참여함" : "참여하기",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
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
        ),
        backgroundColor: primaryColor,

        shape: CircleBorder(),
        elevation: 2,
        child: Icon(Icons.alarm_add, color: Colors.white, size: 30,),
      ),
    );
  }
}
