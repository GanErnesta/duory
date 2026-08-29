import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_text_styles.dart';
import '../../models/partner_model.dart';
import '../../services/partner_service.dart';
import '../../viewmodels/chat_viewmodel.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_header.dart';
import 'widgets/chat_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController =
      ScrollController();

  final PartnerService _partnerService =
      PartnerService();

  bool _isInitializing = true;
  String? _errorMessage;

  PartnerModel? _connection;

  String? _userId;
  String? _partnerId;
  String? _partnerName;
  String? _partnerAvatar;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  Future<void> _initializeChat() async {
    if (!mounted) return;

    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          _isInitializing = false;
          _errorMessage = 'User belum login.';
        });

        return;
      }

      final connection =
          await _partnerService.getMyConnection(user.id);

      if (connection == null ||
          !connection.isConnected ||
          connection.partnerProfile == null) {
        if (!mounted) return;

        setState(() {
          _isInitializing = false;
          _connection = connection;
          _userId = user.id;
          _partnerId = null;
          _partnerName = null;
          _partnerAvatar = null;
          _errorMessage =
              'Pasangan belum terhubung.';
        });

        return;
      }

      final partnerId = connection.partnerId;

      if (partnerId == null ||
          partnerId.isEmpty) {
        if (!mounted) return;

        setState(() {
          _isInitializing = false;
          _connection = connection;
          _userId = user.id;
          _partnerId = null;
          _partnerName = null;
          _partnerAvatar = null;
          _errorMessage =
              'Pasangan belum terhubung.';
        });

        return;
      }

      final chatViewModel =
          context.read<ChatViewModel>();

      final initialized =
          await chatViewModel.initialize(
        userId: user.id,
        partnerId: partnerId,
      );

      if (!mounted) return;

      if (!initialized) {
        setState(() {
          _isInitializing = false;
          _connection = connection;
          _userId = user.id;
          _partnerId = partnerId;
          _partnerName =
              connection.partnerProfile?.fullName;
          _partnerAvatar =
              connection.partnerProfile?.avatarUrl;
          _errorMessage =
              chatViewModel.errorMessage ??
              'Gagal memuat chat.';
        });

        return;
      }

      setState(() {
        _isInitializing = false;
        _connection = connection;
        _userId = user.id;
        _partnerId = partnerId;
        _partnerName =
            connection.partnerProfile?.fullName;
        _partnerAvatar =
            connection.partnerProfile?.avatarUrl;
        _errorMessage = null;
      });

      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isInitializing = false;
        _errorMessage =
            'Gagal memuat data pasangan.';
      });
    }
  }

  void _sendMessage(String message) async {
    final chatViewModel =
        context.read<ChatViewModel>();

    final success =
        await chatViewModel.sendMessage(message);

    if (!mounted) return;

    if (!success &&
        chatViewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            chatViewModel.errorMessage!,
          ),
        ),
      );
    }

    if (success) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration:
            const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  String _formatTime(DateTime dateTime) {
    final hour =
        dateTime.hour.toString().padLeft(2, '0');

    final minute =
        dateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(64),
        child: ChatHeader(
          onBack: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isInitializing) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          textAlign: TextAlign.center,
          style: AppTextStyles.regular14.copyWith(
            color: const Color(0xFF888888),
          ),
        ),
      );
    }

    return Consumer<ChatViewModel>(
      builder: (
        context,
        viewModel,
        _,
      ) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (viewModel.errorMessage != null &&
            viewModel.messages.isEmpty) {
          return Center(
            child: Text(
              viewModel.errorMessage!,
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.regular14.copyWith(
                color:
                    const Color(0xFF888888),
              ),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: viewModel.messages.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada pesan.',
                        style: AppTextStyles
                            .regular14
                            .copyWith(
                          color:
                              const Color(
                            0xFF888888,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller:
                          _scrollController,
                      padding:
                          const EdgeInsets.fromLTRB(
                        20,
                        10,
                        20,
                        20,
                      ),
                      itemCount:
                          viewModel.messages.length,
                      itemBuilder:
                          (context, index) {
                        final message =
                            viewModel.messages[
                                index];

                        final isMe =
                            message.senderId ==
                                _userId;

                        return ChatBubble(
                          message:
                              message.content,
                          time:
                              _formatTime(
                            message.createdAt,
                          ),
                          isMe: isMe,
                          partnerName:
                              isMe
                                  ? null
                                  : _partnerName,
                          avatarUrl:
                              isMe
                                  ? null
                                  : _partnerAvatar,
                        );
                      },
                    ),
            ),
            ChatInput(
              onSend: _sendMessage,
            ),
          ],
        );
      },
    );
  }
}