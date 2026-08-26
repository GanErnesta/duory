import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createProfile({
    required String id,
    required String fullName,
    required String email,
  }) async {
    await _supabase.from('profiles').insert({
      'id': id,
      'full_name': fullName.trim(),
      'email': email.trim(),
    });
  }

  Future<ProfileModel?> getProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return ProfileModel.fromMap(response);
  }

  Future<void> updateProfile({
    required String id,
    required String fullName,
  }) async {
    await _supabase
        .from('profiles')
        .update({
          'full_name': fullName.trim(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
  }
}