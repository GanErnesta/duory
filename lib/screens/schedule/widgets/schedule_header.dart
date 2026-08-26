import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        0,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                'Jadwal Minggu Ini',
                style: AppTextStyles.bold20.copyWith(
                  color: const Color(0xFF181818),
                ),
              ),
            ),
          ),

          const SizedBox(width: 18),
        ],
      ),
    );
  }
}