import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFF0F0F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildHomeItem(),
          _buildImageItem(
            index: 1,
            iconPath: 'assets/icon/inbox.png',
            label: 'Inbox',
          ),
          _buildImageItem(
            index: 2,
            iconPath: 'assets/icon/profile.png',
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeItem() {
    final isSelected = currentIndex == 0;

    return Expanded(
      child: InkWell(
        onTap: () => onChanged(0),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_outlined,
              size: 29,
              color: isSelected
                  ? AppColors.redDark
                  : const Color(0xFFB7B7B7),
            ),

            const SizedBox(height: 4),

            Text(
              'Beranda',
              style: AppTextStyles.regular12.copyWith(
                color: isSelected
                    ? AppColors.redDark
                    : const Color(0xFFB7B7B7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onChanged(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: AppTextStyles.regular12.copyWith(
                color: isSelected
                    ? AppColors.redDark
                    : const Color(0xFFB7B7B7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}