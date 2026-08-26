import 'package:flutter/material.dart';

import 'home_header.dart';
import 'daily_question_card.dart';
import 'status_card.dart';
import 'best_time_card.dart';
import 'action_buttons.dart';
import 'weekly_summary.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          HomeHeader(),

          SizedBox(height: 28),

          DailyQuestionCard(),

          SizedBox(height: 18),

          StatusCard(),

          SizedBox(height: 16),

          BestTimeCard(),

          SizedBox(height: 16),

          ActionButtons(),

          SizedBox(height: 12),

          WeeklySummary(),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}