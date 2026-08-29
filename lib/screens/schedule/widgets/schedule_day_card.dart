import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class ScheduleDayCard extends StatelessWidget {
  final String day;
  final String date;
  final String status;
  final Color statusColor;
  final IconData icon;
  final String duration;
  final String level;
  final Color levelColor;
  final String start;
  final String end;
  final Color freeColor;
  final VoidCallback onTap;

  const ScheduleDayCard({
    super.key,
    required this.day,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.duration,
    required this.level,
    required this.levelColor,
    required this.start,
    required this.end,
    required this.freeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFAFAFA),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: AppTextStyles.semibold16.copyWith(
                        color: const Color(0xFF181818),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      date,
                      style: AppTextStyles.regular12.copyWith(
                        color: const Color(0xFF181818),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 82,
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCE4EB),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 22,
                        color: const Color(0xFF181818),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.regular12.copyWith(
                              color: const Color(0xFF181818),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: double.infinity,
                        height: 12,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                color: const Color(0xFF80C5F4),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: const Color(0xFFFF7652),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: const Color(0xFFFFE66D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          start,
                          style: AppTextStyles.regular12.copyWith(
                            color: const Color(0xFF252525),
                          ),
                        ),
                        Text(
                          end,
                          style: AppTextStyles.regular12.copyWith(
                            color: const Color(0xFF252525),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 58,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      duration,
                      style: AppTextStyles.semibold16.copyWith(
                        color: const Color(0xFF181818),
                      ),
                    ),
                    const SizedBox(height: 7),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: levelColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            level,
                            maxLines: 1,
                            style: AppTextStyles.regular12.copyWith(
                              color: const Color(0xFF181818),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                size: 22,
                color: Color(0xFF181818),
              ),
            ],
          ),
        ),
      ),
    );
  }
}