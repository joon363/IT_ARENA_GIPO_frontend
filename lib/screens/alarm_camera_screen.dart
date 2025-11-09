import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:it_arena/connections/API_KEYS.dart';
import '../connections/api_calls.dart';
import '../themes.dart';
export 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

// A screen that allows users to take a picture using a given camera.
class AlarmCameraScreen extends StatefulWidget {
  const AlarmCameraScreen({
    super.key,
    required this.camera,
    required this.alarmId,
  });

  final CameraDescription camera;
  final String alarmId;

  @override
  AlarmCameraScreenState createState() => AlarmCameraScreenState();
}

class AlarmCameraScreenState extends State<AlarmCameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String _refImagePath;
  final List<String> _refImagePaths = [
    "assets/images/ref_good.jpg"
  ];
  String _selectRandomImagePath() {
    var random = Random();
    int index = random.nextInt(_refImagePaths.length);
    return _refImagePaths[index];
  }

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    _refImagePath = _selectRandomImagePath();

  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return Stack(
                children: [
                  Expanded(child: Container(
                      color: Colors.black,
                    )),
                  Center(child: CameraPreview(_controller),),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 16,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 16 * 4,
                        children: [
                          Material(
                            elevation: 0,
                            color: Colors.white, // 배경색
                            borderRadius: BorderRadius.circular(999),
                            child: InkWell(
                              //highlightColor: primaryColor,
                              borderRadius: BorderRadius.circular(999),
                              onTap: () async {
                                Navigator.pop(context);
                              },
                              child: CircleAvatar(
                                radius: 30, // 원의 반지름
                                backgroundColor: Colors.white, // 하얀 배경
                                child: Icon(CupertinoIcons.xmark, size: 25, color: Colors.black,)
                              ),
                            ),
                          ),
                          Material(
                            elevation: 0,
                            color: Colors.white, // 배경색
                            borderRadius: BorderRadius.circular(999),
                            child: InkWell(
                              //highlightColor: primaryColor,
                              borderRadius: BorderRadius.circular(999),
                              onTap: () async {
                                try {
                                  await _initializeControllerFuture;

                                  // --- 카운트다운 다이얼로그 표시 ---
                                  int count = 5;
                                  await showDialog(
                                    context: context,
                                    //barrierDismissible: false, // 중간에 닫히지 않게
                                    barrierColor: Colors.black26,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          // 1초마다 count 감소
                                          Future.delayed(const Duration(seconds: 1), () {
                                              if (count > 1) {
                                                setState(() => count--);
                                              } else {
                                                Navigator.pop(context); // 카운트 끝나면 닫기
                                              }
                                            });

                                          return Center(
                                            child: Container(
                                              child: Text(
                                                '$count',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 100,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );

                                  await _controller.pausePreview();

                                  final image = await _controller.takePicture();

                                  if (!context.mounted) return;

                                  await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    barrierColor: Colors.black26,
                                    builder: (context) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        spacing: 16,
                                        children: [
                                          Expanded(flex: 1, child: Container()),
                                          Expanded(flex: 7, child: SizedBox(
                                              width: 250,
                                              child: Image.file(
                                                fit: BoxFit.fitWidth,
                                                scale: 0.5,
                                                File(image.path)
                                              ),
                                            ),),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 200,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(16)
                                              ),
                                              child: StatefulBuilder(
                                                builder: (context, setState) {
                                                  return FutureBuilder<bool>(
                                                    future: checkPoseSuccessFromApi(
                                                      junToken,
                                                      imagePath: image.path,
                                                      alarmId: widget.alarmId,
                                                    ),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState ==
                                                        ConnectionState.waiting) {
                                                        // 로딩 중일 때
                                                        return Center(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              CircularProgressIndicator(
                                                                color: blue,),
                                                              Text(
                                                                '사진 분석 중 ...',
                                                                //textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.black54,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight
                                                                    .bold,
                                                                ),
                                                              )
                                                            ],

                                                          ),
                                                        );
                                                      } else if (snapshot.hasError) {
                                                        // 에러 처리
                                                        return Center(
                                                          child: Text('에러 발생: ${snapshot
                                                              .error}'));
                                                      } else if (!snapshot.hasData) {
                                                        // 데이터 없을 때
                                                        return Container(
                                                          padding: EdgeInsets.symmetric(
                                                            vertical: 10),
                                                          child: Text(
                                                            '에러링',
                                                            //textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: Colors.black54,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight
                                                                .bold,
                                                            ),
                                                          )
                                                        );
                                                      }
                                                      final result = snapshot.data!;
                                                      if (result) {
                                                        Future.delayed(const Duration(seconds: 3), () {
                                                            Navigator.popUntil(context, ModalRoute.withName('/alarm'));
                                                          });
                                                      }
                                                      return result ?
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(Icons.check, size: 32, color: primaryColor,),
                                                            Text(
                                                              '인증 성공',
                                                              style: TextStyle(
                                                                color: primaryColor,
                                                                fontSize: 32,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            SizedBox(width: 16,)
                                                          ],
                                                        )
                                                        : Column(
                                                          children: [
                                                            Expanded(child:
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Icon(CupertinoIcons.xmark, size: 32, color: errorRed,),
                                                                  Text(
                                                                    '인증 실패',
                                                                    style: TextStyle(
                                                                      color: errorRed,
                                                                      fontSize: 32,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 16,)
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child:
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                spacing:4,
                                                                children: [
                                                                  Material(
                                                                    color: gray2,
                                                                    borderRadius: BorderRadius.circular(999),
                                                                    elevation: 0,
                                                                    child: InkWell(
                                                                      onTap: () {

                                                                        Navigator.pop(context);
                                                                      },
                                                                      borderRadius: BorderRadius.circular(999),
                                                                      //highlightColor: primaryColorLight,
                                                                      child:

                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                        ),
                                                                        padding: EdgeInsets.all(8),
                                                                        child: Icon(CupertinoIcons.restart, size: 20, color: Colors.black),
                                                                      ),
                                                                    )
                                                                  ),
                                                                  Text(
                                                                    '재시도',
                                                                    style: TextStyle(
                                                                      fontSize: 24,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                          ],
                                                        );
                                                    }
                                                  );
                                                },
                                              ),
                                            )),
                                          Expanded(flex: 3, child: Container()),

                                        ],
                                      );
                                    },
                                  );

                                  // 🔸 복귀 후 카메라 다시 시작
                                  await _controller.resumePreview();
                                } catch (e) {
                                  print(e);
                                }
                              },

                              child: CircleAvatar(
                                radius: 30, // 원의 반지름
                                backgroundColor: Colors.white, // 하얀 배경
                                child: Icon(Icons.camera_alt, size: 25, color: Colors.black,)
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16 * 2,)
                    ]
                  ),

                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      spacing: 8,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 16 * 3),
                          height: 200,
                          width: 200,
                          child: Image.asset(_refImagePath, scale: 0.5, fit: BoxFit.scaleDown,),
                        ),
                        Container(
                          color: Colors.black,
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '위 사진과 동일한 포즈를 취해주세요. \n버튼 클릭 후 5초 뒤 촬영됩니다.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  )
                ],
              );
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),)
    );
  }
}
