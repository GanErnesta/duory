import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../viewmodels/auth_viewmodel.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, _) {
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hai ${viewModel.displayName}!',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

            ProfileAvatar(
              avatarUrl: viewModel.avatarUrl,
            ),
          ],
        );
      },
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;

  const ProfileAvatar({
    super.key,
    this.avatarUrl,
  });

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
        child: avatarUrl != null &&
                avatarUrl!.trim().isNotEmpty
            ? Image.network(
                avatarUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Icon(
                    Icons.person,
                    size: 28,
                    color: AppColors.blueDark,
                  );
                },
              )
            : const Icon(
                Icons.person,
                size: 28,
                color: AppColors.blueDark,
              ),
      ),
    );
  }
}