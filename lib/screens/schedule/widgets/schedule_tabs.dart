import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class ScheduleTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const ScheduleTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  static const tabs = [
    'Hari',
    'Kesibukan',
    'Jadwal Kita',
    'Quality Time',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Row(
        children: List.generate(
          tabs.length,
          (index) {
            final selected = index == selectedIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(index),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: AppTextStyles.regular14.copyWith(
                      color: const Color(0xFF181818),
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}