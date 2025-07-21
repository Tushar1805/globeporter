class UserDetailsResponseModel {
  final bool? status;
  final int? statusCode;
  final String? message;
  final Data? data;

  UserDetailsResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  UserDetailsResponseModel.fromJson(final Map<String, dynamic>? json)
      : status = json?['status'] as bool?,
        statusCode = json?['status_code'] as int?,
        message = json?['message'] as String?,
        data = (json?['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json?['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'status': status, 'status_code': statusCode, 'message': message, 'data': data?.toJson()};
}

class Data {
  final int? id;
  final String? name;
  final String? email;
  final dynamic emailVerifiedAt;
  final String? dialCode;
  final String? mobile;
  final dynamic gender;
  final String? cityType;
  final String? fullAddress;
  final String? address;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? longitude;
  final String? latitude;
  final dynamic photo;
  final dynamic otp;
  final dynamic otpExpireAt;
  final int? userType;
  final int? registrationDone;
  final int? status;
  final String? fcmToken;
  final dynamic googleId;
  final dynamic facebookId;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final dynamic profilePhotoUrl;
  final dynamic profilePhotoThumbUrl;
  final UserTypeData? userTypeData;
  final VehicleDetailData? vehicleDetailData;

  Data({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.dialCode,
    this.mobile,
    this.gender,
    this.cityType,
    this.fullAddress,
    this.address,
    this.city,
    this.state,
    this.postalCode,
    this.longitude,
    this.latitude,
    this.photo,
    this.otp,
    this.otpExpireAt,
    this.userType,
    this.registrationDone,
    this.status,
    this.fcmToken,
    this.googleId,
    this.facebookId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.profilePhotoUrl,
    this.profilePhotoThumbUrl,
    this.userTypeData,
    this.vehicleDetailData,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        email = json['email'] as String?,
        emailVerifiedAt = json['email_verified_at'],
        dialCode = json['dial_code'] as String?,
        mobile = json['mobile'] as String?,
        gender = json['gender'],
        cityType = json['city_type'] as String?,
        fullAddress = json['full_address'] as String?,
        address = json['address'] as String?,
        city = json['city'] as String?,
        state = json['state'] as String?,
        postalCode = json['postal_code'] as String?,
        longitude = json['longitude'] as String?,
        latitude = json['latitude'] as String?,
        photo = json['photo'],
        otp = json['otp'],
        otpExpireAt = json['otp_expire_at'],
        userType = json['user_type'] as int?,
        registrationDone = json['registration_done'] as int?,
        status = json['status'] as int?,
        fcmToken = json['fcm_token'] as String?,
        googleId = json['google_id'],
        facebookId = json['facebook_id'],
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        profilePhotoUrl = json['profile_photo_url'],
        profilePhotoThumbUrl = json['profile_photo_thumb_url'],
        userTypeData = (json['user_type_data'] as Map<String, dynamic>?) != null
            ? UserTypeData.fromJson(json['user_type_data'] as Map<String, dynamic>)
            : null,
        vehicleDetailData = (json['vehicle_detail_data'] as Map<String, dynamic>?) != null
            ? VehicleDetailData.fromJson(json['vehicle_detail_data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'email_verified_at': emailVerifiedAt,
        'dial_code': dialCode,
        'mobile': mobile,
        'gender': gender,
        'city_type': cityType,
        'full_address': fullAddress,
        'address': address,
        'city': city,
        'state': state,
        'postal_code': postalCode,
        'longitude': longitude,
        'latitude': latitude,
        'photo': photo,
        'otp': otp,
        'otp_expire_at': otpExpireAt,
        'user_type': userType,
        'registration_done': registrationDone,
        'status': status,
        'fcm_token': fcmToken,
        'google_id': googleId,
        'facebook_id': facebookId,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'profile_photo_url': profilePhotoUrl,
        'profile_photo_thumb_url': profilePhotoThumbUrl,
        'user_type_data': userTypeData?.toJson(),
        'vehicle_detail_data': vehicleDetailData?.toJson()
      };
}

class UserTypeData {
  final int? id;
  final String? name;
  final int? status;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;

  UserTypeData({
    this.id,
    this.name,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  UserTypeData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        status = json['status'] as int?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class VehicleDetailData {
  final int? id;
  final int? userId;
  final String? ownerName;
  final String? ownerDialCode;
  final String? ownerMobile;
  final String? aadharCard;
  final String? aadharCardBack;
  final String? panCard;
  final String? panCardBack;
  final String? driverName;
  final String? driverDialCode;
  final String? driverMobile;
  final String? driverAadharCard;
  final String? driverAadharCardBack;
  final String? driverPanCard;
  final String? driverPanCardBack;
  final String? driverLicenseNumber;
  final String? driverLicense;
  final String? driverLicenseBack;
  final int? vehicleTypeId;
  final String? vehicleRc;
  final String? vehicleRcBack;
  final String? vehicleNo;
  final String? vehicleRegistration;
  final String? vehiclePhoto;
  final String? profilePhoto;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? vehicleTypeName;
  final String? aadharCardUrl;
  final String? panCardUrl;
  final String? driverAadharCardUrl;
  final String? driverPanCardUrl;
  final String? driverLicenseUrl;
  final String? vehicleRcUrl;
  final String? vehiclePhotoUrl;
  final String? profilePhotoUrl;
  final VehicleTypeData? vehicleTypeData;

  VehicleDetailData({
    this.id,
    this.userId,
    this.ownerName,
    this.ownerDialCode,
    this.ownerMobile,
    this.aadharCard,
    this.aadharCardBack,
    this.panCard,
    this.panCardBack,
    this.driverName,
    this.driverDialCode,
    this.driverMobile,
    this.driverAadharCard,
    this.driverAadharCardBack,
    this.driverPanCard,
    this.driverPanCardBack,
    this.driverLicenseNumber,
    this.driverLicense,
    this.driverLicenseBack,
    this.vehicleTypeId,
    this.vehicleRc,
    this.vehicleRcBack,
    this.vehicleNo,
    this.vehicleRegistration,
    this.vehiclePhoto,
    this.profilePhoto,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.vehicleTypeName,
    this.aadharCardUrl,
    this.panCardUrl,
    this.driverAadharCardUrl,
    this.driverPanCardUrl,
    this.driverLicenseUrl,
    this.vehicleRcUrl,
    this.vehiclePhotoUrl,
    this.profilePhotoUrl,
    this.vehicleTypeData,
  });

  VehicleDetailData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['user_id'] as int?,
        ownerName = json['owner_name'] as String?,
        ownerDialCode = json['owner_dial_code'] as String?,
        ownerMobile = json['owner_mobile'] as String?,
        aadharCard = json['aadhar_card'] as String?,
        aadharCardBack = json['aadhar_card_back'] as String?,
        panCard = json['pan_card'] as String?,
        panCardBack = json['pan_card_back'] as String?,
        driverName = json['driver_name'] as String?,
        driverDialCode = json['driver_dial_code'] as String?,
        driverMobile = json['driver_mobile'] as String?,
        driverAadharCard = json['driver_aadhar_card'] as String?,
        driverAadharCardBack = json['driver_aadhar_card_back'] as String?,
        driverPanCard = json['driver_pan_card'] as String?,
        driverPanCardBack = json['driver_pan_card_back'] as String?,
        driverLicenseNumber = json['driver_license_number'] as String?,
        driverLicense = json['driver_license'] as String?,
        driverLicenseBack = json['driver_license_back'] as String?,
        vehicleTypeId = json['vehicle_type_id'] as int?,
        vehicleRc = json['vehicle_rc'] as String?,
        vehicleRcBack = json['vehicle_rc_back'] as String?,
        vehicleNo = json['vehicle_no'] as String?,
        vehicleRegistration = json['vehicle_registration'] as String?,
        vehiclePhoto = json['vehicle_photo'] as String?,
        profilePhoto = json['profile_photo'] as String?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        vehicleTypeName = json['vehicle_type_name'] as String?,
        aadharCardUrl = json['aadhar_card_url'] as String?,
        panCardUrl = json['pan_card_url'] as String?,
        driverAadharCardUrl = json['driver_aadhar_card_url'] as String?,
        driverPanCardUrl = json['driver_pan_card_url'] as String?,
        driverLicenseUrl = json['driver_license_url'] as String?,
        vehicleRcUrl = json['vehicle_rc_url'] as String?,
        vehiclePhotoUrl = json['vehicle_photo_url'] as String?,
        profilePhotoUrl = json['profile_photo_url'] as String?,
        vehicleTypeData = (json['vehicle_type_data'] as Map<String, dynamic>?) != null
            ? VehicleTypeData.fromJson(json['vehicle_type_data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'owner_name': ownerName,
        'owner_dial_code': ownerDialCode,
        'owner_mobile': ownerMobile,
        'aadhar_card': aadharCard,
        'aadhar_card_back': aadharCardBack,
        'pan_card': panCard,
        'pan_card_back': panCardBack,
        'driver_name': driverName,
        'driver_dial_code': driverDialCode,
        'driver_mobile': driverMobile,
        'driver_aadhar_card': driverAadharCard,
        'driver_aadhar_card_back': driverAadharCardBack,
        'driver_pan_card': driverPanCard,
        'driver_pan_card_back': driverPanCardBack,
        'driver_license_number': driverLicenseNumber,
        'driver_license': driverLicense,
        'driver_license_back': driverLicenseBack,
        'vehicle_type_id': vehicleTypeId,
        'vehicle_rc': vehicleRc,
        'vehicle_rc_back': vehicleRcBack,
        'vehicle_no': vehicleNo,
        'vehicle_registration': vehicleRegistration,
        'vehicle_photo': vehiclePhoto,
        'profile_photo': profilePhoto,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'vehicle_type_name': vehicleTypeName,
        'aadhar_card_url': aadharCardUrl,
        'pan_card_url': panCardUrl,
        'driver_aadhar_card_url': driverAadharCardUrl,
        'driver_pan_card_url': driverPanCardUrl,
        'driver_license_url': driverLicenseUrl,
        'vehicle_rc_url': vehicleRcUrl,
        'vehicle_photo_url': vehiclePhotoUrl,
        'profile_photo_url': profilePhotoUrl,
        'vehicle_type_data': vehicleTypeData?.toJson()
      };
}

class VehicleTypeData {
  final int? id;
  final String? nameEn;
  final String? nameMr;
  final String? nameHi;
  final String? image;
  final int? status;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? imageUrl;

  VehicleTypeData({
    this.id,
    this.nameEn,
    this.nameMr,
    this.nameHi,
    this.image,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  VehicleTypeData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        nameEn = json['name_en'] as String?,
        nameMr = json['name_mr'] as String?,
        nameHi = json['name_hi'] as String?,
        image = json['image'] as String?,
        status = json['status'] as int?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        imageUrl = json['image_url'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_en': nameEn,
        'name_mr': nameMr,
        'name_hi': nameHi,
        'image': image,
        'status': status,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'image_url': imageUrl
      };
}
