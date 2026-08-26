import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hai Nasyaaja!',
                style: AppTextStyles.bold20.copyWith(
                  color: const Color(0xFF181818),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Yuk, jaga hubungan kita',
                style: AppTextStyles.regular14.copyWith(
                  color: const Color(0xFF252525),
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          icon: const Icon(
            Icons.notifications_none_outlined,
            size: 30,
            color: Colors.black,
          ),
        ),

        const SizedBox(width: 8),

        const ProfileAvatar(),
      ],
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.redLightActive,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: SvgPicture.asset(
          'assets/images/profile.svg',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}