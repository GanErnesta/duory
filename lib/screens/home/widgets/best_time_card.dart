import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class BestTimeCard extends StatelessWidget {
  const BestTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 101,
      padding: const EdgeInsets.fromLTRB(
        19,
        25,
        19,
        16,
      ),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Waktu terbaik kamu mengobrol',
            style: AppTextStyles.regular12.copyWith(
              color: const Color(0xFF252525),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '20:00 - 23:00 WIB',
            style: AppTextStyles.bold18.copyWith(
              color: const Color(0xFF181818),
            ),
          ),
        ],
      ),
    );
  }
}