import 'package:flutter/material.dart';
import 'package:task_manager/presentation/screens/cancel_task_screen.dart';
import 'package:task_manager/presentation/screens/complete_task_screen.dart';
import 'package:task_manager/presentation/screens/new_task_screen.dart';
import 'package:task_manager/presentation/screens/progress_task_screen.dart';
import 'package:task_manager/presentation/utils/app_color.dart';

class MainBottomNavigationScreen extends StatefulWidget {
  const MainBottomNavigationScreen({super.key});

  @override
  State<MainBottomNavigationScreen> createState() =>
      _MainBottomNavigationScreenState();
}

class _MainBottomNavigationScreenState
    extends State<MainBottomNavigationScreen> {
  int _currentSelectedIndex = 0;
  List<Widget> _screens = [
    const NewTaskScreen(),
    const CompleteTaskScreen(),
    const ProgressTaskScreen(),
    const CancelTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentSelectedIndex,
        selectedItemColor: AppColors.themColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          _currentSelectedIndex = index;
          if (mounted) {
            setState(() {});
          }
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.file_copy_outlined), label: "New"),
          const BottomNavigationBarItem(icon: Icon(Icons.done_all), label: "Completed"),
          const BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "Progress"),
          const BottomNavigationBarItem(icon: Icon(Icons.close_rounded), label: "Cancled"),
        ],
      ),
      body: _screens[_currentSelectedIndex],
    );
  }
}
