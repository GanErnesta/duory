import 'dart:async';

import 'package:flutter/material.dart';

import '../models/chat_message_model.dart';
import '../services/chat_service.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService;

  ChatViewModel(this._chatService);

  final List<ChatMessageModel> _messages = [];

  bool _isLoading = false;
  bool _isSending = false;
  String? _errorMessage;

  String? _userId;
  String? _partnerId;

  StreamSubscription<List<Map<String, dynamic>>>?
      _subscription;

  List<ChatMessageModel> get messages =>
      List.unmodifiable(_messages);

  bool get isLoading => _isLoading;

  bool get isSending => _isSending;

  String? get errorMessage => _errorMessage;

  Future<bool> initialize({
    required String userId,
    required String partnerId,
  }) async {
    if (userId == partnerId) {
      _messages.clear();
      _userId = userId;
      _partnerId = null;
      _isLoading = false;
      _errorMessage =
          'ID pasangan tidak valid.';
      notifyListeners();
      return false;
    }

    await _subscription?.cancel();
    _subscription = null;

    _userId = userId;
    _partnerId = partnerId;

    _messages.clear();
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await _loadMessages();

      _listenToMessages();

      _isLoading = false;

      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _parseError(e);

      notifyListeners();

      return false;
    }
  }

  Future<void> _loadMessages() async {
    final userId = _userId;
    final partnerId = _partnerId;

    if (userId == null ||
        partnerId == null ||
        userId == partnerId) {
      _messages.clear();
      return;
    }

    final messages =
        await _chatService.getMessages(
      userId: userId,
      partnerId: partnerId,
    );

    final validMessages = messages.where(
      (message) {
        return message.senderId !=
            message.receiverId;
      },
    ).toList();

    validMessages.sort(
      (a, b) => a.createdAt.compareTo(
        b.createdAt,
      ),
    );

    _messages
      ..clear()
      ..addAll(validMessages);
  }

  void _listenToMessages() {
    final userId = _userId;
    final partnerId = _partnerId;

    if (userId == null ||
        partnerId == null ||
        userId == partnerId) {
      return;
    }

    _subscription?.cancel();

    _subscription =
        _chatService.watchMessages().listen(
      (rows) {
        final messages = rows
            .where((row) {
              final senderId =
                  row['sender_id']?.toString();

              final receiverId =
                  row['receiver_id']?.toString();

              if (senderId == null ||
                  receiverId == null) {
                return false;
              }

              if (senderId == receiverId) {
                return false;
              }

              return (senderId == userId &&
                      receiverId == partnerId) ||
                  (senderId == partnerId &&
                      receiverId == userId);
            })
            .map(
              (row) =>
                  ChatMessageModel.fromMap(row),
            )
            .toList();

        messages.sort(
          (a, b) => a.createdAt.compareTo(
            b.createdAt,
          ),
        );

        _messages
          ..clear()
          ..addAll(messages);

        notifyListeners();
      },
      onError: (error) {
        _errorMessage = _parseError(error);
        notifyListeners();
      },
    );
  }

  Future<bool> sendMessage(
    String content,
  ) async {
    final userId = _userId;
    final partnerId = _partnerId;

    final message = content.trim();

    if (userId == null ||
        partnerId == null) {
      _errorMessage =
          'Pasangan belum terhubung.';

      notifyListeners();

      return false;
    }

    if (userId == partnerId) {
      _errorMessage =
          'Tidak dapat mengirim pesan ke akun sendiri.';

      notifyListeners();

      return false;
    }

    if (message.isEmpty) {
      return false;
    }

    if (_isSending) {
      return false;
    }

    _isSending = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await _chatService.sendMessage(
        senderId: userId,
        receiverId: partnerId,
        content: message,
      );

      _isSending = false;

      notifyListeners();

      return true;
    } catch (e) {
      _isSending = false;
      _errorMessage = _parseError(e);

      notifyListeners();

      return false;
    }
  }

  Future<void> refresh() async {
    try {
      await _loadMessages();

      notifyListeners();
    } catch (e) {
      _errorMessage = _parseError(e);

      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;

    notifyListeners();
  }

  String _parseError(Object error) {
    final message =
        error.toString().toLowerCase();

    if (message.contains('permission denied')) {
      return 'Tidak memiliki izin untuk mengakses chat.';
    }

    if (message.contains('row-level security')) {
      return 'Tidak memiliki izin untuk mengakses chat.';
    }

    if (message.contains('network')) {
      return 'Tidak dapat terhubung ke server.';
    }

    if (message.contains('socketexception')) {
      return 'Tidak dapat terhubung ke server.';
    }

    return 'Gagal memuat chat.';
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}