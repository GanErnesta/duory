import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Color(0xFF181818),
              ),
            ),
          ),
          Text(
            'Chat',
            style: AppTextStyles.bold20.copyWith(
              color: const Color(0xFF181818),
            ),
          ),
        ],
      ),
    );
  }
}