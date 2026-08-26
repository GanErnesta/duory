import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class InboxEmptyContent extends StatelessWidget {
  final VoidCallback onOpen;

  const InboxEmptyContent({super.key, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 70),

            GestureDetector(
              onTap: onOpen,
              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.94, end: 1),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Image.asset(
                      'assets/images/box_gift.png',
                      width: 350,
                      height: 310,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.red, width: 1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Box kamu sudah penuh nih',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.semibold14.copyWith(
                            color: const Color(0xFF181818),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Ada 5 topik yang menunggu untuk dibahas',
                          textAlign: TextAlign.center,
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
          ],
        ),
      ),
    );
  }
}
