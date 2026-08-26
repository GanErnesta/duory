import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../schedule/schedule_screen.dart';

class WeeklySummary extends StatelessWidget {
  const WeeklySummary({super.key});

  static const List<Map<String, dynamic>> days = [
    {
      'day': 'Sen',
      'date': '23',
      'color': Color(0xFFFF7351),
    },
    {
      'day': 'Sel',
      'date': '24',
      'color': Color(0xFF72D58E),
    },
    {
      'day': 'Rab',
      'date': '25',
      'color': Color(0xFF72D58E),
    },
    {
      'day': 'Kam',
      'date': '26',
      'color': Color(0xFFFF7351),
    },
    {
      'day': 'Jum',
      'date': '27',
      'color': Color(0xFF72D58E),
    },
    {
      'day': 'Sab',
      'date': '28',
      'color': Color(0xFF72D58E),
    },
    {
      'day': 'Min',
      'date': '29',
      'color': Color(0xFF72D58E),
    },
  ];

  void _openSchedule(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ScheduleScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        15,
        15,
        15,
        8,
      ),
      decoration: BoxDecoration(
        color: AppColors.blueLightActive,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan jadwal minggu ini',
            style: AppTextStyles.regular14.copyWith(
              color: const Color(0xFF181818),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: days.map((day) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                  ),
                  child: Container(
                    height: 94,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          day['day'] as String,
                          style: AppTextStyles.regular12.copyWith(
                            color: const Color(0xFF252525),
                          ),
                        ),

                        Text(
                          day['date'] as String,
                          style: AppTextStyles.regular12.copyWith(
                            color: const Color(0xFF252525),
                          ),
                        ),

                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: day['color'] as Color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 7),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                _openSchedule(context);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Lihat kalender',
                style: AppTextStyles.regular12.copyWith(
                  color: const Color(0xFF181818),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}