import 'profile_model.dart';

class PartnerModel {
  final String id;
  final String userId;
  final String? partnerId;
  final String pairCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProfileModel? partnerProfile;

  const PartnerModel({
    required this.id,
    required this.userId,
    this.partnerId,
    required this.pairCode,
    required this.createdAt,
    required this.updatedAt,
    this.partnerProfile,
  });

  bool get isConnected {
    return partnerId != null && partnerId!.isNotEmpty;
  }

  factory PartnerModel.fromMap(
    Map<String, dynamic> map, {
    ProfileModel? partnerProfile,
  }) {
    return PartnerModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      partnerId: map['partner_id']?.toString(),
      pairCode: map['pair_code']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updated_at']?.toString() ?? '') ??
          DateTime.now(),
      partnerProfile: partnerProfile,
    );
  }

  PartnerModel copyWith({
    String? id,
    String? userId,
    Object? partnerId = _undefined,
    String? pairCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? partnerProfile = _undefined,
  }) {
    return PartnerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      partnerId: partnerId == _undefined
          ? this.partnerId
          : partnerId as String?,
      pairCode: pairCode ?? this.pairCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      partnerProfile: partnerProfile == _undefined
          ? this.partnerProfile
          : partnerProfile as ProfileModel?,
    );
  }
}

const Object _undefined = Object();
