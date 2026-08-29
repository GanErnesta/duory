import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const String _avatarBucket = 'avatars';

  Future<void> createProfile({
    required String id,
    required String fullName,
    required String email,
    String? avatarUrl,
  }) async {
    await _supabase.from('profiles').insert({
      'id': id,
      'full_name': fullName.trim(),
      'email': email.trim(),
      'avatar_url': avatarUrl,
    });
  }

  Future<void> ensureProfileFromUser(User user) async {
    final metadata = user.userMetadata ?? {};

    final metadataFullName =
        metadata['full_name']?.toString() ??
        metadata['name']?.toString() ??
        '';

    final metadataAvatar =
        metadata['avatar_url']?.toString() ??
        metadata['picture']?.toString();

    final existingProfile = await getProfile(user.id);

    if (existingProfile == null) {
      await createProfile(
        id: user.id,
        fullName: metadataFullName.isNotEmpty
            ? metadataFullName
            : 'Pengguna Duory',
        email: user.email ?? '',
        avatarUrl: metadataAvatar,
      );

      return;
    }

    if (metadataAvatar != null &&
        metadataAvatar.isNotEmpty &&
        (existingProfile.avatarUrl == null ||
            existingProfile.avatarUrl!.isEmpty)) {
      await _supabase.from('profiles').update({
        'avatar_url': metadataAvatar,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id);
    }
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
    await _supabase.from('profiles').update({
      'full_name': fullName.trim(),
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
  }) async {
    if (bytes.isEmpty) {
      throw Exception('File foto kosong.');
    }

    final filePath = '$userId/profile.jpg';

    final storage = _supabase.storage.from(_avatarBucket);

    try {
      await storage.remove([filePath]);
    } catch (e) {
      debugPrint(
        'OLD AVATAR REMOVE: $e',
      );
    }

    await storage.uploadBinary(
      filePath,
      bytes,
      fileOptions: const FileOptions(
        contentType: 'image/jpeg',
        upsert: false,
      ),
    );

    final publicUrl = storage.getPublicUrl(
      filePath,
    );

    final cacheBustedUrl =
        '$publicUrl?v=${DateTime.now().millisecondsSinceEpoch}';

    await updateAvatar(
      id: userId,
      avatarUrl: cacheBustedUrl,
    );

    return cacheBustedUrl;
  }

  Future<void> deleteAvatar({
    required String userId,
  }) async {
    final filePath = '$userId/profile.jpg';

    final storage = _supabase.storage.from(
      _avatarBucket,
    );

    debugPrint(
      'DELETE USER ID: $userId',
    );

    debugPrint(
      'DELETE FILE PATH: $filePath',
    );

    final result = await storage.remove([
      filePath,
    ]);

    debugPrint(
      'DELETE RESULT: $result',
    );

    await updateAvatar(
      id: userId,
      avatarUrl: null,
    );
  }

  Future<void> updateAvatar({
    required String id,
    required String? avatarUrl,
  }) async {
    await _supabase.from('profiles').update({
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }
}