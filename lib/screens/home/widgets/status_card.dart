import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        24,
        12,
        20,
        14,
      ),
      decoration: BoxDecoration(
        color: AppColors.blueLightActive,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status',
            style: AppTextStyles.semibold14.copyWith(
              color: const Color(0xFF181818),
            ),
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              SizedBox(
                width: 54,
                height: 54,
                child: Stack(
                  children: [
                    ClipOval(
                      child: SvgPicture.asset(
                        'assets/images/status.svg',
                        width: 54,
                        height: 54,
                        fit: BoxFit.contain,
                      ),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: const Color(0xFF72D58E),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.blueLightActive,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FREE',
                    style: AppTextStyles.bold14.copyWith(
                      color: const Color(0xFF181818),
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'Pasanganmu lagi senggang',
                    style: AppTextStyles.regular12.copyWith(
                      color: const Color(0xFF252525),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}