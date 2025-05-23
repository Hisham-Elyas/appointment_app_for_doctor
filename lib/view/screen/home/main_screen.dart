import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constant/image_asset.dart';
import 'Schedule/schedule_screen.dart';
import 'chats/message_history_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final page = [
    const ScheduleScreen(),
    const MessageHistoryScreen(),
    // Container(
    //   child: const Text('ScheduleScreen'),
    // )
  ];

  int indexpage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: page[indexpage],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: indexpage,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (value) {
            setState(() {
              indexpage = value;
            });
            // print(value);
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                indexpage == 0
                    ? ImageAssetSVG.homeIcon
                    : ImageAssetSVG.homeWIcon,
                fit: BoxFit.scaleDown,
                height: 24.h,
                width: 24.w,
              ),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                indexpage == 1
                    ? ImageAssetSVG.messageIcon
                    : ImageAssetSVG.messageWIcon,
                fit: BoxFit.scaleDown,
                height: 24.h,
                width: 24.w,
              ),
              label: 'message',
            ),
          ]),
    );
  }
}
