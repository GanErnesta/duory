import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class QuizProgress extends StatelessWidget {
  final double progress;

  const QuizProgress({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 10,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                color: const Color(0xFFF8F8F8),
              ),

              FractionallySizedBox(
                widthFactor: progress.clamp(0, 1),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(10),
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