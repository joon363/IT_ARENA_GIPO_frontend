import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'sleep_party_list_screen.dart';
import 'friends_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    SleepPartyListScreen(),
    FriendsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    double iconSize = 30;
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 60.0, // 하단 바 높이
          child: Row(
            // Row의 자식들을 1:1:1 비율로 나누기 위해 Expanded 사용
            children: [
              // 1. 버튼 (왼쪽)
              Expanded(
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => setState(() => _selectedIndex = 0),
                  child: Container(
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Image.asset(
                      _selectedIndex == 0 ?
                        'assets/images/alarm-clock_active.png' :
                        'assets/images/alarm-clock.png',
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                ),
              ),

              // 2. /alarm 버튼 (가운데, sleep_mode.png)
              Expanded(
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => setState(() => _selectedIndex = 1),
                  child: Container(
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Image.asset(
                      _selectedIndex == 1 ?
                        'assets/images/bell_active.png' :
                        'assets/images/bell.png',
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                ),
              ),

              // 3. /friend 버튼 (오른쪽)
              Expanded(
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => setState(() => _selectedIndex = 2),
                  child: Container(
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Image.asset(
                      _selectedIndex == 2 ?
                        'assets/images/users_active.png' :
                        'assets/images/users.png',
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
