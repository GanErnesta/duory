import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileStats extends StatelessWidget {
  final String togetherDays;
  final String streakDays;

  const ProfileStats({
    super.key,
    this.togetherDays = '-',
    this.streakDays = '-',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Hari Bersama',
            value: togetherDays,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _StatCard(
            title: 'Hari Streak',
            value: streakDays,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.redLightActive,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyles.regular12.copyWith(
              color: const Color(0xFF252525),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: AppTextStyles.regular12.copyWith(
              color: const Color(0xFF777777),
            ),
          ),
        ],
      ),
    );
  }
}