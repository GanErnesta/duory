import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
    this.partnerName,
    this.avatarUrl,
    this.isRead = true,
  });

  final String message;
  final String time;
  final bool isMe;
  final String? partnerName;
  final String? avatarUrl;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 290,
          ),
          margin: const EdgeInsets.only(
            bottom: 12,
            left: 55,
          ),
          padding: const EdgeInsets.fromLTRB(
            14,
            10,
            10,
            7,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFE0E4FF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  message,
                  style:
                      AppTextStyles.regular14.copyWith(
                    color: const Color(0xFF303030),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style:
                        AppTextStyles.regular12.copyWith(
                      color:
                          const Color(0xFF777777),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.done_all,
                    size: 16,
                    color: isRead
                        ? const Color(0xFF6878E8)
                        : const Color(0xFF777777),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 290,
        ),
        margin: const EdgeInsets.only(
          bottom: 12,
          right: 55,
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _ChatAvatar(
              avatarUrl: avatarUrl,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.fromLTRB(
                  12,
                  9,
                  12,
                  7,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F1F5),
                  borderRadius:
                      BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    if (partnerName != null &&
                        partnerName!.isNotEmpty)
                      Text(
                        partnerName!,
                        style: AppTextStyles
                            .semibold14
                            .copyWith(
                          color:
                              const Color(0xFF6878E8),
                        ),
                      ),
                    if (partnerName != null &&
                        partnerName!.isNotEmpty)
                      const SizedBox(height: 4),
                    Text(
                      message,
                      style:
                          AppTextStyles.regular14.copyWith(
                        color:
                            const Color(0xFF303030),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Align(
                      alignment:
                          Alignment.centerRight,
                      child: Text(
                        time,
                        style: AppTextStyles
                            .regular12
                            .copyWith(
                          color:
                              const Color(0xFF777777),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar({
    required this.avatarUrl,
  });

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFD0D0D0),
      ),
      child: avatarUrl != null &&
              avatarUrl!.isNotEmpty
          ? Image.network(
              avatarUrl!,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) {
                return const Icon(
                  Icons.person,
                  size: 20,
                  color: Color(0xFF777777),
                );
              },
            )
          : const Icon(
              Icons.person,
              size: 20,
              color: Color(0xFF777777),
            ),
    );
  }
}