class OwnerDetailsResponseModel {
  final bool? status;
  final int? statusCode;
  final String? message;
  final Data? data;

  OwnerDetailsResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  OwnerDetailsResponseModel.fromJson(final Map<String, dynamic>? json)
      : status = json?['status'] as bool?,
        statusCode = json?['status_code'] as int?,
        message = json?['message'] as String?,
        data = (json?['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json?['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'status': status,
        'status_code': statusCode,
        'message': message,
        'data': data?.toJson(),
      };
}

class Data {
  final int? id;
  final String? ownerName;
  final String? ownerDialCode;
  final String? ownerMobile;
  final String? aadharCard;
  final String? aadharCardBack;
  final String? panCard;
  final String? panCardBack;
  final String? profilePhoto;
  final int? isAadharCardVerified;
  final int? isAadharCardBackVerified;
  final int? isPanCardVerified;
  final int? isPanCardBackVerified;
  final String? aadharCardUrl;
  final String? aadharCardBackUrl;
  final String? panCardUrl;
  final String? panCardBackUrl;
  final String? profilePhotoUrl;

  Data({
    this.id,
    this.ownerName,
    this.ownerDialCode,
    this.ownerMobile,
    this.aadharCard,
    this.aadharCardBack,
    this.panCard,
    this.panCardBack,
    this.profilePhoto,
    this.isAadharCardVerified,
    this.isAadharCardBackVerified,
    this.isPanCardVerified,
    this.isPanCardBackVerified,
    this.aadharCardUrl,
    this.aadharCardBackUrl,
    this.panCardUrl,
    this.panCardBackUrl,
    this.profilePhotoUrl,
  });

  Data.fromJson(final Map<String, dynamic> json)
      : id = json['id'] as int?,
        ownerName = json['owner_name'] as String?,
        ownerDialCode = json['owner_dial_code'] as String?,
        ownerMobile = json['owner_mobile'] as String?,
        aadharCard = json['aadhar_card'] as String?,
        aadharCardBack = json['aadhar_card_back'] as String?,
        panCard = json['pan_card'] as String?,
        panCardBack = json['pan_card_back'] as String?,
        profilePhoto = json['profile_photo'] as String?,
        isAadharCardVerified = json['is_aadhar_card_verified'] as int?,
        isAadharCardBackVerified = json['is_aadhar_card_back_verified'] as int?,
        isPanCardVerified = json['is_pan_card_verified'] as int?,
        isPanCardBackVerified = json['is_pan_card_back_verified'] as int?,
        aadharCardUrl = json['aadhar_card_url'] as String?,
        aadharCardBackUrl = json['aadhar_card_back_url'] as String?,
        panCardUrl = json['pan_card_url'] as String?,
        panCardBackUrl = json['pan_card_back_url'] as String?,
        profilePhotoUrl = json['profile_photo_url'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'owner_name': ownerName,
        'owner_dial_code': ownerDialCode,
        'owner_mobile': ownerMobile,
        'aadhar_card': aadharCard,
        'aadhar_card_back': aadharCardBack,
        'pan_card': panCard,
        'pan_card_back': panCardBack,
        'profile_photo': profilePhoto,
        'is_aadhar_card_verified': isAadharCardVerified,
        'is_aadhar_card_back_verified': isAadharCardBackVerified,
        'is_pan_card_verified': isPanCardVerified,
        'is_pan_card_back_verified': isPanCardBackVerified,
        'aadhar_card_url': aadharCardUrl,
        'aadhar_card_back_url': aadharCardBackUrl,
        'pan_card_url': panCardUrl,
        'pan_card_back_url': panCardBackUrl,
        'profile_photo_url': profilePhotoUrl
      };
}
