import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  User? get currentUser => _authService.currentUser;

  Session? get currentSession => _authService.currentSession;

  bool get isLoggedIn => _authService.isLoggedIn;

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

      if (response.user == null) {
        throw Exception('Registrasi gagal.');
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
      await _authService.resetPassword(email.trim());

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

  Future<void> logout() async {
    try {
      await _authService.logout();
      _errorMessage = null;
    } on AuthException catch (e) {
      _setError(_parseError(e.message));
      return;
    } catch (e) {
      _setError(_parseError(e));
      return;
    }

    notifyListeners();
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final user = currentUser;

    if (user == null) {
      return null;
    }

    try {
      final profile = await _profileService.getProfile(user.id);

      if (profile == null) {
        return null;
      }

      return profile.toMap();
    } catch (e) {
      _setError(_parseError(e));
      return null;
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

    _startLoading();

    try {
      await _profileService.updateProfile(
        id: user.id,
        fullName: fullName.trim(),
      );

      _stopLoading();
      return true;
    } catch (e) {
      _setError(_parseError(e));
      return false;
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

    if (message.contains('invalid login credentials')) {
      return 'Email atau password salah.';
    }

    if (message.contains('user already registered')) {
      return 'Email sudah terdaftar.';
    }

    if (message.contains('password should be at least')) {
      return 'Password terlalu pendek.';
    }

    if (message.contains('invalid email')) {
      return 'Format email tidak valid.';
    }

    if (message.contains('email not confirmed')) {
      return 'Email belum dikonfirmasi.';
    }

    if (message.contains('email rate limit exceeded')) {
      return 'Terlalu banyak percobaan. Coba lagi nanti.';
    }

    if (message.contains('network')) {
      return 'Tidak dapat terhubung ke server.';
    }

    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}