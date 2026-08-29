import 'package:flutter/material.dart';

import '../profile/profile_screen.dart';
import '../inbox/inbox_screen.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/home_bottom_nav.dart';
import 'widgets/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onNavigationChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: const [HomeContent(), InboxScreen(), ProfilePage()],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _currentIndex,
        onChanged: _onNavigationChanged,
      ),
    );
  }
}
