import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'widgets/inbox_empty_content.dart';
import 'widgets/inbox_topic_content.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  bool _isOpened = false;

  void _openInbox() {
    setState(() {
      _isOpened = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 28),

            Text(
              'Inbox',
              style: AppTextStyles.bold20.copyWith(
                color: const Color(0xFF181818),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.04),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _isOpened
                    ? const InboxTopicContent(
                        key: ValueKey('opened'),
                      )
                    : InboxEmptyContent(
                        key: const ValueKey('closed'),
                        onOpen: _openInbox,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}