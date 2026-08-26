import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_text_styles.dart';

class QuizQuestion extends StatelessWidget {
  final int questionNumber;
  final String question;

  const QuizQuestion({
    super.key,
    required this.questionNumber,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 90,
            child: Image.asset('assets/images/bee2.png', fit: BoxFit.contain),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pertanyaan Ke-$questionNumber',
                  style: AppTextStyles.semibold14.copyWith(
                    color: const Color(0xFF181818),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  question,
                  style: AppTextStyles.regular14.copyWith(
                    color: const Color(0xFF181818),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
