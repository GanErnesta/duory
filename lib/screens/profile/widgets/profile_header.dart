import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/partner_viewmodel.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback? onAvatarTap;
  final VoidCallback? onEditName;
  final VoidCallback? onAddPartner;

  const ProfileHeader({
    super.key,
    this.onAvatarTap,
    this.onEditName,
    this.onAddPartner,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthViewModel, PartnerViewModel>(
      builder: (context, authViewModel, partnerViewModel, _) {
        final isConnected = partnerViewModel.isConnected;
        final partnerName = partnerViewModel.partnerName;
        final partnerAvatar = partnerViewModel.partnerAvatar;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ProfileAvatar(
                  avatarUrl: authViewModel.avatarUrl,
                  onTap: onAvatarTap,
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 72,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 1,
                        width: 72,
                        color: AppColors.red,
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        color: AppColors.white,
                        child: const Icon(
                          Icons.favorite_border,
                          size: 28,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _PartnerAvatar(
                  avatarUrl: partnerAvatar,
                  isConnected: isConnected,
                  onTap: onAddPartner,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 110,
                  child: GestureDetector(
                    onTap: onEditName,
                    child: Text(
                      authViewModel.displayName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.semibold14.copyWith(
                        color: const Color(0xFF181818),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 44),
                SizedBox(
                  width: 110,
                  child: Text(
                    isConnected
                        ? (partnerName?.isNotEmpty == true
                            ? partnerName!
                            : 'Pasangan')
                        : 'Tambah pasangan',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.semibold14.copyWith(
                      color: const Color(0xFF181818),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              isConnected
                  ? 'Kalian sudah terhubung ❤️'
                  : 'Akun anda belum terhubung dengan\npasangan anda',
              textAlign: TextAlign.center,
              style: AppTextStyles.regular12.copyWith(
                color: const Color(0xFF252525),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback? onTap;

  const _ProfileAvatar({
    required this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 84,
        height: 84,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.red,
            width: 1,
          ),
        ),
        child: ClipOval(
          child: avatarUrl != null && avatarUrl!.isNotEmpty
              ? Image.network(
                  avatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return _defaultAvatar();
                  },
                )
              : _defaultAvatar(),
        ),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: const Color(0xFFE0E0E0),
      child: const Icon(
        Icons.person,
        size: 48,
        color: Color(0xFF8A8A8A),
      ),
    );
  }
}

class _PartnerAvatar extends StatelessWidget {
  final String? avatarUrl;
  final bool isConnected;
  final VoidCallback? onTap;

  const _PartnerAvatar({
    required this.avatarUrl,
    required this.isConnected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isConnected ? null : onTap,
      child: Container(
        width: 84,
        height: 84,
        padding: isConnected ? const EdgeInsets.all(3) : EdgeInsets.zero,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isConnected
              ? Colors.transparent
              : const Color(0xFFBDBDBD),
          border: Border.all(
            color: const Color(0xFF8AA1B5),
            width: 1,
          ),
        ),
        child: ClipOval(
          child: isConnected &&
                  avatarUrl != null &&
                  avatarUrl!.isNotEmpty
              ? Image.network(
                  avatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return _connectedDefaultAvatar();
                  },
                )
              : isConnected
                  ? _connectedDefaultAvatar()
                  : const Icon(
                      Icons.add,
                      size: 32,
                      color: Color(0xFF333333),
                    ),
        ),
      ),
    );
  }

  Widget _connectedDefaultAvatar() {
    return Container(
      color: const Color(0xFFE0E0E0),
      child: const Icon(
        Icons.person,
        size: 48,
        color: Color(0xFF8A8A8A),
      ),
    );
  }
}