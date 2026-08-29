import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    super.key,
    required this.onSend,
  });

  final ValueChanged<String> onSend;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller =
      TextEditingController();

  final FocusNode _focusNode = FocusNode();

  bool get _hasText =>
      _controller.text.trim().isNotEmpty;

  void _sendMessage() {
    final message = _controller.text.trim();

    if (message.isEmpty) return;

    widget.onSend(message);
    _controller.clear();

    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          8,
          20,
          10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints:
                    const BoxConstraints(
                  minHeight: 44,
                  maxHeight: 110,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF777777),
                  ),
                  borderRadius:
                      BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction:
                      TextInputAction.newline,
                  onChanged: (_) {
                    setState(() {});
                  },
                  decoration:
                      InputDecoration(
                    hintText:
                        'Tulis pesan disini...',
                    hintStyle:
                        AppTextStyles.regular14
                            .copyWith(
                      color:
                          const Color(0xFFAAAAAA),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 11,
                    ),
                  ),
                  style:
                      AppTextStyles.regular14.copyWith(
                    color:
                        const Color(0xFF181818),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: _hasText
                  ? _sendMessage
                  : () {},
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF777777),
                  ),
                ),
                child: Icon(
                  _hasText
                      ? Icons.send_rounded
                      : Icons.mic_none_rounded,
                  size: 22,
                  color:
                      const Color(0xFF555555),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}