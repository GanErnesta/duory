import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../viewmodels/partner_viewmodel.dart';
import '../../chat/chat_screen.dart';

class StatusCard extends StatefulWidget {
  const StatusCard({super.key});

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePartner();
    });
  }

  Future<void> _initializePartner() async {
    final user = context.read<PartnerViewModel>();
    final partnerViewModel = context.read<PartnerViewModel>();

    final currentUserId = partnerViewModel.connection?.userId;

    if (currentUserId != null && currentUserId.isNotEmpty) {
      await user.initialize(currentUserId);
    }
  }

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChatScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartnerViewModel>(
      builder: (context, viewModel, _) {
        final isConnected = viewModel.isConnected;
        final partnerName = viewModel.partnerName;
        final partnerAvatar = viewModel.partnerAvatar;

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: Stack(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE0E0E0),
                          ),
                          child: ClipOval(
                            child: isConnected &&
                                    partnerAvatar != null &&
                                    partnerAvatar.isNotEmpty
                                ? Image.network(
                                    partnerAvatar,
                                    width: 54,
                                    height: 54,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) {
                                      return const Icon(
                                        Icons.person,
                                        size: 32,
                                        color: Color(0xFF8A8A8A),
                                      );
                                    },
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 32,
                                    color: Color(0xFF8A8A8A),
                                  ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: isConnected
                                  ? const Color(0xFF72D58E)
                                  : const Color(0xFFBDBDBD),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isConnected ? 'FREE' : 'BELUM TERHUBUNG',
                          style: AppTextStyles.bold14.copyWith(
                            color: const Color(0xFF181818),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isConnected
                              ? partnerName != null &&
                                      partnerName.isNotEmpty
                                  ? '$partnerName lagi senggang'
                                  : 'Pasanganmu lagi senggang'
                              : 'Hubungkan akun dengan pasanganmu',
                          style: AppTextStyles.regular12.copyWith(
                            color: const Color(0xFF252525),
                          ),
                        ),
                        if (isConnected) ...[
                          const SizedBox(height: 7),
                          GestureDetector(
                            onTap: () => _openChat(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                border: Border.all(
                                  color: AppColors.red,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Chat sekarang',
                                    style:
                                        AppTextStyles.semibold12.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}