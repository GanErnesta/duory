import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'widgets/add_schedule_button.dart';
import 'widgets/add_schedule_sheet.dart';
import 'widgets/schedule_day_card.dart';
import 'widgets/schedule_header.dart';
import 'widgets/schedule_insight.dart';
import 'widgets/schedule_tabs.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedTab = 0;

  final List<Map<String, dynamic>> _schedule = [
    {
      'day': 'Sen',
      'date': '23/8',
      'status': 'Sibuk',
      'statusColor': const Color(0xFFFF7652),
      'icon': Icons.work_outline,
      'duration': '45m',
      'level': 'Low',
      'levelColor': const Color(0xFFFF7652),
      'start': '09:00',
      'end': '18:00',
      'freeColor': const Color(0xFFFF7652),
    },
    {
      'day': 'Sel',
      'date': '24/8',
      'status': 'Focus',
      'statusColor': const Color(0xFFFFE66D),
      'icon': Icons.menu_book_outlined,
      'duration': '2j',
      'level': 'Medium',
      'levelColor': const Color(0xFFFFE66D),
      'start': '09:00',
      'end': '18:00',
      'freeColor': const Color(0xFFFFE66D),
    },
    {
      'day': 'Rab',
      'date': '25/8',
      'status': 'Di perjalanan',
      'statusColor': const Color(0xFFFFE66D),
      'icon': Icons.directions_car_outlined,
      'duration': '50m',
      'level': 'Low',
      'levelColor': const Color(0xFFFF7652),
      'start': '09:00',
      'end': '18:00',
      'freeColor': const Color(0xFFFF7652),
    },
    {
      'day': 'Kam',
      'date': '26/8',
      'status': 'Di perjalanan',
      'statusColor': const Color(0xFFFFE66D),
      'icon': Icons.directions_car_outlined,
      'duration': '50m',
      'level': 'Low',
      'levelColor': const Color(0xFFFF7652),
      'start': '09:00',
      'end': '18:00',
      'freeColor': const Color(0xFFFF7652),
    },
    {
      'day': 'Jum',
      'date': '27/8',
      'status': 'Focus',
      'statusColor': const Color(0xFFFFE66D),
      'icon': Icons.menu_book_outlined,
      'duration': '50m',
      'level': 'Low',
      'levelColor': const Color(0xFFFF7652),
      'start': '09:00',
      'end': '18:00',
      'freeColor': const Color(0xFFFF7652),
    },
    {
      'day': 'Sab',
      'date': '28/8',
      'status': 'Free',
      'statusColor': const Color(0xFF7BD69A),
      'icon': Icons.sentiment_satisfied_alt_outlined,
      'duration': '18j',
      'level': 'High',
      'levelColor': const Color(0xFF7BD69A),
      'start': '09:00',
      'end': '18:00',
      'freeColor': const Color(0xFF7BD69A),
    },
    {
      'day': 'Min',
      'date': '29/8',
      'status': 'Focus',
      'statusColor': const Color(0xFFFFE66D),
      'icon': Icons.menu_book_outlined,
      'duration': '50m',
      'level': 'Low',
      'levelColor': const Color(0xFFFF7652),
      'start': '09:00',
      'end': '18:00',
      'freeColor': const Color(0xFFFF7652),
    },
  ];

  void _openAddSchedule() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddScheduleScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ScheduleHeader(),

            const SizedBox(height: 20),

            Container(
              color: const Color(0xFFF2D6CC),
              child: ScheduleTabs(
                selectedIndex: _selectedTab,
                onChanged: (index) {
                  setState(() {
                    _selectedTab = index;
                  });
                },
              ),
            ),

            Expanded(
              child: Container(
                color: const Color(0xFFF2D6CC),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    0,
                    12,
                    20,
                  ),
                  child: Column(
                    children: [
                      ..._schedule.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8,
                          ),
                          child: ScheduleDayCard(
                            day: item['day'],
                            date: item['date'],
                            status: item['status'],
                            statusColor: item['statusColor'],
                            icon: item['icon'],
                            duration: item['duration'],
                            level: item['level'],
                            levelColor: item['levelColor'],
                            start: item['start'],
                            end: item['end'],
                            freeColor: item['freeColor'],
                            onTap: () {
                              _openAddSchedule();
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      AddScheduleButton(
                        onPressed: _openAddSchedule,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const ScheduleInsight(),
          ],
        ),
      ),
    );
  }
}