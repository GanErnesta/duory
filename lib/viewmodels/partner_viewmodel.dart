import 'dart:async';

import 'package:flutter/material.dart';

import '../models/partner_model.dart';
import '../services/partner_service.dart';

class PartnerViewModel extends ChangeNotifier {
  final PartnerService _partnerService;

  PartnerViewModel(this._partnerService);

  PartnerModel? _connection;

  bool _isLoading = false;

  String? _errorMessage;

  String? _currentUserId;

  String? _pairCode;

  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  PartnerModel? get connection => _connection;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get isConnected => _connection?.isConnected ?? false;

  String? get pairCode =>
      _connection?.pairCode ?? _pairCode;

  String? get partnerName =>
      _connection?.partnerProfile?.fullName;

  String? get partnerAvatar =>
      _connection?.partnerProfile?.avatarUrl;

  Future<bool> initialize(String userId) async {
    final cleanUserId = userId.trim();

    if (cleanUserId.isEmpty) {
      _setError('User belum login.');
      return false;
    }

    _currentUserId = cleanUserId;

    _startLoading();

    try {
      PartnerModel? connection =
          await _partnerService.getMyConnection(
        cleanUserId,
      );

      if (connection != null) {
        _connection = connection;
        _pairCode = connection.pairCode;
      }

      if (connection == null) {
        final code =
            await _partnerService.createPairCode();

        if (code.trim().isEmpty) {
          _setError(
            'Gagal membuat kode pasangan.',
          );
          return false;
        }

        _pairCode = code.trim().toUpperCase();

        notifyListeners();

        for (int i = 0; i < 10; i++) {
          connection =
              await _partnerService.getMyConnection(
            cleanUserId,
          );

          if (connection != null) {
            break;
          }

          await Future.delayed(
            const Duration(milliseconds: 300),
          );
        }

        if (connection != null) {
          _connection = connection;

          if (connection.pairCode != null &&
              connection.pairCode!.trim().isNotEmpty) {
            _pairCode =
                connection.pairCode!.trim().toUpperCase();
          }
        }
      }

      _errorMessage = null;

      _listenToChanges(cleanUserId);

      _stopLoading();

      return true;
    } catch (e) {
      _setError(
        _parseError(e),
      );

      return false;
    }
  }

  Future<bool> connectPartner({
    required String code,
    required String userId,
  }) async {
    final cleanCode =
        code.trim().toUpperCase();

    final cleanUserId =
        userId.trim();

    if (cleanCode.isEmpty) {
      _setError(
        'Masukkan kode pasangan.',
      );
      return false;
    }

    if (cleanUserId.isEmpty) {
      _setError(
        'User belum login.',
      );
      return false;
    }

    _currentUserId = cleanUserId;

    _startLoading();

    try {
      final connection =
          await _partnerService.connectPartner(
        code: cleanCode,
        userId: cleanUserId,
      );

      if (connection == null) {
        _setError(
          'Akun gagal terhubung.',
        );
        return false;
      }

      _connection = connection;

      if (connection.pairCode != null &&
          connection.pairCode!.trim().isNotEmpty) {
        _pairCode =
            connection.pairCode!.trim().toUpperCase();
      } else if (_pairCode == null ||
          _pairCode!.isEmpty) {
        _pairCode = cleanCode;
      }

      _errorMessage = null;

      _listenToChanges(cleanUserId);

      _stopLoading();

      return true;
    } catch (e) {
      _setError(
        _parseError(e),
      );

      return false;
    }
  }

  Future<void> refresh(String userId) async {
    final cleanUserId = userId.trim();

    if (cleanUserId.isEmpty) {
      return;
    }

    try {
      final connection =
          await _partnerService.getMyConnection(
        cleanUserId,
      );

      if (connection != null) {
        _connection = connection;

        final databasePairCode =
            connection.pairCode;

        if (databasePairCode != null &&
            databasePairCode.trim().isNotEmpty) {
          _pairCode =
              databasePairCode.trim().toUpperCase();
        }
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = _parseError(e);
      notifyListeners();
    }
  }

  void _listenToChanges(String userId) {
    _subscription?.cancel();

    _subscription =
        _partnerService.watchConnections().listen(
      (rows) async {
        final relatedConnection = rows.where(
          (row) {
            final ownerId =
                row['user_id']?.toString();

            final partnerId =
                row['partner_id']?.toString();

            return ownerId == userId ||
                partnerId == userId;
          },
        );

        if (relatedConnection.isNotEmpty) {
          await refresh(userId);
        }
      },
      onError: (error) {
        _errorMessage = _parseError(error);
        notifyListeners();
      },
    );
  }

  Future<void> disconnectPartner(
    String userId,
  ) async {
    final cleanUserId =
        userId.trim();

    if (cleanUserId.isEmpty) {
      _setError(
        'User belum login.',
      );
      return;
    }

    _startLoading();

    try {
      await _partnerService.disconnectPartner(
        cleanUserId,
      );

      await refresh(cleanUserId);

      _stopLoading();
    } catch (e) {
      _setError(
        _parseError(e),
      );
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearConnection() {
    _connection = null;
    _pairCode = null;
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
    final message =
        error.toString().toLowerCase();

    if (message.contains(
      'kode pasangan tidak ditemukan',
    )) {
      return 'Kode pasangan tidak ditemukan.';
    }

    if (message.contains(
      'tidak dapat menggunakan kode sendiri',
    )) {
      return 'Kamu tidak dapat menggunakan kode sendiri.';
    }

    if (message.contains(
      'kode pasangan sudah digunakan',
    )) {
      return 'Kode pasangan sudah digunakan.';
    }

    if (message.contains(
      'user belum login',
    )) {
      return 'User belum login.';
    }

    if (message.contains(
      'permission denied',
    )) {
      return 'Tidak memiliki izin untuk mengakses data pasangan.';
    }

    if (message.contains(
      'row-level security',
    )) {
      return 'Tidak memiliki izin untuk mengakses data pasangan.';
    }

    if (message.contains(
      'duplicate',
    )) {
      return 'Kode pasangan sudah digunakan.';
    }

    if (message.contains(
      'network',
    )) {
      return 'Tidak dapat terhubung ke server.';
    }

    if (message.contains(
      'socketexception',
    )) {
      return 'Tidak dapat terhubung ke server.';
    }

    return 'Gagal memuat data pasangan.';
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}