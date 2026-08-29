import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class ProfileMenu extends StatelessWidget {
  final VoidCallback? onAccountTap;
  final VoidCallback? onPreferenceTap;
  final VoidCallback? onHelpTap;
  final VoidCallback? onPrivacyTap;

  const ProfileMenu({
    super.key,
    this.onAccountTap,
    this.onPreferenceTap,
    this.onHelpTap,
    this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileMenuItem(
          title: 'Akun & Pasangan',
          subtitle: 'Kelola akunmu dan pasangan',
          onTap: onAccountTap,
        ),
        const SizedBox(height: 8),
        _ProfileMenuItem(
          title: 'Preferensi Aplikasi',
          subtitle: 'MVP',
          onTap: onPreferenceTap,
        ),
        const SizedBox(height: 8),
        _ProfileMenuItem(
          title: 'Bantuan & Dukungan',
          subtitle: 'MVP',
          onTap: onHelpTap,
        ),
        const SizedBox(height: 8),
        _ProfileMenuItem(
          title: 'Keamanan & Privasi',
          subtitle: 'MVP',
          onTap: onPrivacyTap,
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ProfileMenuItem({
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.semibold14.copyWith(
                        color: const Color(0xFF181818),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.regular12.copyWith(
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
              ),
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