import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/partner_model.dart';
import '../models/profile_model.dart';

class PartnerService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> createPairCode() async {
    final result = await _supabase.rpc('create_pair_code');

    final code = result?.toString().trim() ?? '';

    if (code.isEmpty) {
      throw Exception('Gagal membuat kode pasangan.');
    }

    return code;
  }

  Future<PartnerModel?> getMyConnection(
    String userId,
  ) async {
    final ownResponse = await _supabase
        .from('partner_connections')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    final partnerResponse = await _supabase
        .from('partner_connections')
        .select()
        .eq('partner_id', userId)
        .maybeSingle();

    Map<String, dynamic>? response;

    if (ownResponse != null) {
      final ownData = Map<String, dynamic>.from(
        ownResponse,
      );

      final ownPartnerId =
          ownData['partner_id']?.toString();

      if (ownPartnerId != null &&
          ownPartnerId.isNotEmpty) {
        response = ownData;
      }
    }

    if (response == null && partnerResponse != null) {
      response = Map<String, dynamic>.from(
        partnerResponse,
      );
    }

    if (response == null) {
      return null;
    }

    final ownerId =
        response['user_id']?.toString();

    final connectedPartnerId =
        response['partner_id']?.toString();

    if (ownerId == null || ownerId.isEmpty) {
      return null;
    }

    final bool isOwner = ownerId == userId;

    final String? actualPartnerId = isOwner
        ? connectedPartnerId
        : ownerId;

    if (actualPartnerId == null ||
        actualPartnerId.isEmpty ||
        actualPartnerId == userId) {
      return PartnerModel(
        id: response['id'].toString(),
        userId: userId,
        partnerId: null,
        pairCode:
            response['pair_code']?.toString() ?? '',
        createdAt: DateTime.parse(
          response['created_at'].toString(),
        ),
        updatedAt: DateTime.parse(
          response['updated_at'].toString(),
        ),
        partnerProfile: null,
      );
    }

    final partnerProfile =
        await _getPartnerProfile(
      actualPartnerId,
    );

    return PartnerModel(
      id: response['id'].toString(),
      userId: userId,
      partnerId: actualPartnerId,
      pairCode:
          response['pair_code']?.toString() ?? '',
      createdAt: DateTime.parse(
        response['created_at'].toString(),
      ),
      updatedAt: DateTime.parse(
        response['updated_at'].toString(),
      ),
      partnerProfile: partnerProfile,
    );
  }

  Future<ProfileModel?> _getPartnerProfile(
    String userId,
  ) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return ProfileModel.fromMap(
      Map<String, dynamic>.from(response),
    );
  }

  Future<PartnerModel?> connectPartner({
    required String code,
    required String userId,
  }) async {
    final cleanCode =
        code.trim().toUpperCase();

    if (cleanCode.isEmpty) {
      throw Exception(
        'Masukkan kode pasangan.',
      );
    }

    await _supabase.rpc(
      'connect_partner',
      params: {
        'input_pair_code': cleanCode,
      },
    );

    for (int i = 0; i < 10; i++) {
      final connection =
          await getMyConnection(userId);

      if (connection != null &&
          connection.isConnected &&
          connection.partnerId != userId) {
        return connection;
      }

      await Future.delayed(
        const Duration(milliseconds: 300),
      );
    }

    return await getMyConnection(userId);
  }

  Stream<List<Map<String, dynamic>>>
      watchConnections() {
    return _supabase
        .from('partner_connections')
        .stream(
          primaryKey: ['id'],
        );
  }

  Future<void> disconnectPartner(
    String userId,
  ) async {
    final connection =
        await getMyConnection(userId);

    if (connection == null) {
      return;
    }

    await _supabase
        .from('partner_connections')
        .update({
      'partner_id': null,
      'updated_at':
          DateTime.now().toIso8601String(),
    }).eq(
      'id',
      connection.id,
    );
  }
}