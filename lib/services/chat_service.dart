import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_message_model.dart';

class ChatService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<List<ChatMessageModel>> getMessages({
    required String userId,
    required String partnerId,
  }) async {
    final response = await _supabase
        .from('messages')
        .select()
        .or(
          'and(sender_id.eq.$userId,receiver_id.eq.$partnerId),'
          'and(sender_id.eq.$partnerId,receiver_id.eq.$userId)',
        )
        .order(
          'created_at',
          ascending: true,
        );

    return (response as List)
        .map(
          (item) =>
              ChatMessageModel.fromMap(item),
        )
        .toList();
  }

  Future<ChatMessageModel> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    final response = await _supabase
        .from('messages')
        .insert({
          'sender_id': senderId,
          'receiver_id': receiverId,
          'content': content.trim(),
        })
        .select()
        .single();

    return ChatMessageModel.fromMap(response);
  }

  Stream<List<Map<String, dynamic>>>
      watchMessages() {
    return _supabase
        .from('messages')
        .stream(
          primaryKey: ['id'],
        )
        .order(
          'created_at',
          ascending: true,
        );
  }
}