import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class ScheduleInsight extends StatelessWidget {
  const ScheduleInsight({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFD7E0E8),
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insight minggu ini',
            style: AppTextStyles.semibold14.copyWith(
              color: const Color(0xFF181818),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                width: 134,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF849BB0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total quality time',
                      style: AppTextStyles.regular12.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '6j 56m',
                      style: AppTextStyles.bold25.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '▲ 20% minggu lalu',
                      style: AppTextStyles.regular12.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hari Terbaik',
                      style: AppTextStyles.regular12.copyWith(
                        color: const Color(0xFF3B332E),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Sabtu',
                      style: AppTextStyles.bold25.copyWith(
                        color: const Color(0xFF3B332E),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Full free berdua',
                      style: AppTextStyles.regular12.copyWith(
                        color: const Color(0xFF3B332E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}