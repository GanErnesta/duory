import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  final ProfileService _profileService;

  AuthViewModel(
    this._authService,
    this._profileService,
  );

  bool _isLoading = false;
  String? _errorMessage;
  ProfileModel? _profile;

  bool _avatarDeleted = false;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  User? get currentUser => _authService.currentUser;

  Session? get currentSession => _authService.currentSession;

  bool get isLoggedIn => _authService.isLoggedIn;

  ProfileModel? get profile => _profile;

  String get displayName {
    final profileName = _profile?.fullName.trim();

    if (profileName != null && profileName.isNotEmpty) {
      return profileName;
    }

    final metadata = currentUser?.userMetadata ?? {};

    final name =
        metadata['full_name']?.toString() ??
        metadata['name']?.toString();

    if (name != null && name.trim().isNotEmpty) {
      return name.trim();
    }

    return 'Pengguna Duory';
  }

  String? get avatarUrl {
    final profileAvatar = _profile?.avatarUrl;

    if (profileAvatar != null &&
        profileAvatar.trim().isNotEmpty) {
      return profileAvatar;
    }

    if (_avatarDeleted) {
      return null;
    }

    final metadata = currentUser?.userMetadata ?? {};

    final avatar =
        metadata['avatar_url']?.toString() ??
        metadata['picture']?.toString();

    if (avatar != null && avatar.trim().isNotEmpty) {
      return avatar.trim();
    }

    return null;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _startLoading();

    try {
      await _authService.login(
        email: email.trim(),
        password: password,
      );

      final user = _authService.currentUser;

      if (user == null) {
        throw Exception('Login gagal.');
      }

      _avatarDeleted = false;

      await _loadOrCreateProfile(user);

      _stopLoading();
      return true;
    } on AuthException catch (e) {
      _setError(_parseError(e.message));
      return false;
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _startLoading();

    try {
      final response = await _authService.register(
        fullName: fullName.trim(),
        email: email.trim(),
        password: password,
      );

      final user = response.user;

      if (user == null) {
        throw Exception('Registrasi gagal.');
      }

      _avatarDeleted = false;

      if (response.session != null) {
        await _loadOrCreateProfile(user);
      }

      _stopLoading();
      return true;
    } on AuthException catch (e) {
      _setError(_parseError(e.message));
      return false;
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    _startLoading();

    try {
      await _authService.resetPassword(
        email.trim(),
      );

      _stopLoading();
      return true;
    } on AuthException catch (e) {
      _setError(_parseError(e.message));
      return false;
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _errorMessage = null;
    notifyListeners();

    try {
      return await _authService.loginWithGoogle();
    } on AuthException catch (e) {
      _setError(_parseError(e.message));
      return false;
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  Future<void> _loadOrCreateProfile(User user) async {
    await _profileService.ensureProfileFromUser(user);

    _profile = await _profileService.getProfile(
      user.id,
    );

    notifyListeners();
  }

  Future<bool> loadProfile() async {
    final user = currentUser;

    if (user == null) {
      _setError('User belum login.');
      return false;
    }

    try {
      _profile = await _profileService.getProfile(
        user.id,
      );

      if (_profile == null) {
        await _profileService.ensureProfileFromUser(
          user,
        );

        _profile = await _profileService.getProfile(
          user.id,
        );
      }

      if (_profile == null) {
        _setError(
          'Profil pengguna tidak ditemukan.',
        );
        return false;
      }

      _errorMessage = null;
      notifyListeners();

      return true;
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  Future<bool> updateProfile({
    required String fullName,
  }) async {
    final user = currentUser;

    if (user == null) {
      _setError('User belum login.');
      return false;
    }

    final name = fullName.trim();

    if (name.isEmpty) {
      _setError(
        'Nama lengkap tidak boleh kosong.',
      );
      return false;
    }

    _startLoading();

    try {
      await _profileService.updateProfile(
        id: user.id,
        fullName: name,
      );

      _profile = await _profileService.getProfile(
        user.id,
      );

      _stopLoading();
      return true;
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  Future<bool> uploadAvatar(
    Uint8List bytes,
  ) async {
    final user = currentUser;

    if (user == null) {
      _setError('User belum login.');
      return false;
    }

    if (bytes.isEmpty) {
      _setError('Foto tidak valid.');
      return false;
    }

    _startLoading();

    try {
      final avatarUrl =
          await _profileService.uploadAvatar(
        userId: user.id,
        bytes: bytes,
      );

      if (_profile != null) {
        _profile = _profile!.copyWith(
          avatarUrl: avatarUrl,
          updatedAt: DateTime.now(),
        );
      } else {
        _profile =
            await _profileService.getProfile(
          user.id,
        );
      }

      _avatarDeleted = false;

      _stopLoading();
      return true;
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  Future<bool> deleteAvatar() async {
    final user = currentUser;

    if (user == null) {
      _setError('User belum login.');
      return false;
    }

    _startLoading();

    try {
      await _profileService.deleteAvatar(
        userId: user.id,
      );

      if (_profile != null) {
        _profile = _profile!.copyWith(
          avatarUrl: null,
          updatedAt: DateTime.now(),
        );
      }

      _avatarDeleted = true;
      _errorMessage = null;
      _isLoading = false;

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint(
        'DELETE AVATAR ERROR: $e',
      );

      _setError(
        'Gagal menghapus foto profil.',
      );

      return false;
    }
  }

  Future<bool> updateAvatar(
    String? avatarUrl,
  ) async {
    final user = currentUser;

    if (user == null) {
      _setError('User belum login.');
      return false;
    }

    _startLoading();

    try {
      await _profileService.updateAvatar(
        id: user.id,
        avatarUrl: avatarUrl,
      );

      if (_profile != null) {
        _profile = _profile!.copyWith(
          avatarUrl: avatarUrl,
          updatedAt: DateTime.now(),
        );
      } else {
        _profile =
            await _profileService.getProfile(
          user.id,
        );
      }

      _avatarDeleted = avatarUrl == null;

      _stopLoading();
      return true;
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final user = currentUser;

    if (user == null) {
      return null;
    }

    try {
      if (_profile == null) {
        final success = await loadProfile();

        if (!success) {
          return null;
        }
      }

      return _profile?.toMap();
    } catch (e) {
      _setError(_parseError(e));
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();

      _profile = null;
      _errorMessage = null;
      _isLoading = false;
      _avatarDeleted = false;

      notifyListeners();
    } on AuthException catch (e) {
      _setError(_parseError(e.message));
    } catch (e) {
      _setError(_parseError(e));
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _startLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void _setError(String message) {
    _isLoading = false;
    _errorMessage = message;
    notifyListeners();
  }

  String _parseError(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains(
      'invalid login credentials',
    )) {
      return 'Email atau password salah.';
    }

    if (message.contains(
      'user already registered',
    )) {
      return 'Email sudah terdaftar.';
    }

    if (message.contains(
      'password should be at least',
    )) {
      return 'Password terlalu pendek.';
    }

    if (message.contains('invalid email')) {
      return 'Format email tidak valid.';
    }

    if (message.contains(
      'email not confirmed',
    )) {
      return 'Email belum dikonfirmasi.';
    }

    if (message.contains(
      'email rate limit exceeded',
    )) {
      return 'Terlalu banyak percobaan. Coba lagi nanti.';
    }

    if (message.contains(
          'permission denied',
        ) ||
        message.contains(
          'row-level security',
        ) ||
        message.contains('rls')) {
      return 'Tidak memiliki izin untuk mengakses data.';
    }

    if (message.contains('storage')) {
      return 'Gagal mengunggah foto profil.';
    }

    if (message.contains('network') ||
        message.contains('socketexception') ||
        message.contains('connection')) {
      return 'Tidak dapat terhubung ke server.';
    }

    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}