import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileLogout extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const ProfileLogout({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  Future<void> _showLogoutConfirmation(
    BuildContext context,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.white,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 44,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: 320,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keluar dari akun?',
                    style: AppTextStyles.bold20.copyWith(
                      color: const Color(0xFF181818),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Apakah kamu yakin ingin keluar dari akun ini?',
                    style: AppTextStyles.regular14.copyWith(
                      color: const Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(
                          dialogContext,
                        ).pop(false);
                      },
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Batal',
                        style: AppTextStyles.regular14.copyWith(
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(
                          dialogContext,
                        ).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                          double.infinity,
                          52,
                        ),
                        maximumSize: const Size(
                          double.infinity,
                          52,
                        ),
                        padding: EdgeInsets.zero,
                        backgroundColor: AppColors.red,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Keluar',
                        style: AppTextStyles.regular14.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (confirmed == true && context.mounted) {
      onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () => _showLogoutConfirmation(context),
      child: Container(
        width: double.infinity,
        height: 67,
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFB6A3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.logout,
              size: 23,
              color: Color(0xFF181818),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keluar (Log out)',
                    style: AppTextStyles.semibold14.copyWith(
                      color: const Color(0xFF181818),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Keluar dari akun',
                    style: AppTextStyles.regular12.copyWith(
                      color: const Color(0xFF252525),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}