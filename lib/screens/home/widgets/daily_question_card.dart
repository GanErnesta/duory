import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../quiz/quiz_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class DailyQuestionCard extends StatelessWidget {
  const DailyQuestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 12, 40),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pertanyaan hari ini',
                      style: AppTextStyles.semibold16.copyWith(
                        color: const Color(0xFF171717),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Hal kecil apa yang merasa anda dicintai?',
                      style: AppTextStyles.regular14.copyWith(
                        color: const Color(0xFF252525),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: 85,
                height: 75,
                child: Image.asset(
                  'assets/images/bee.png',
                  width: 85,
                  height: 75,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          SizedBox(
            width: double.infinity,
            height: 49,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: Text(
                'Mulai Kuis',
                style: AppTextStyles.regular16.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
