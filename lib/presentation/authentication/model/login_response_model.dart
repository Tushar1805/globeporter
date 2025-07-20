class LoginResponseModel {
  final bool? status;
  final int? statusCode;
  final String? message;
  final int? otp;
  final Data? data;

  LoginResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.otp,
    this.data,
  });

  LoginResponseModel.fromJson(Map<String, dynamic>? json)
      : status = json?['status'] as bool?,
        statusCode = json?['status_code'] as int?,
        message = json?['message'] as String?,
        otp = json?['otp'] as int?,
        data = (json?['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json?['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'status': status,
        'status_code': statusCode,
        'message': message,
        'otp': otp,
        'data': data?.toJson()
      };
}

class Data {
  final int? id;
  final String? name;
  final String? email;
  final dynamic emailVerifiedAt;
  final String? dialCode;
  final String? mobile;
  final dynamic gender;
  final dynamic cityType;
  final dynamic fullAddress;
  final dynamic address;
  final dynamic city;
  final dynamic state;
  final dynamic postalCode;
  final dynamic longitude;
  final dynamic latitude;
  final dynamic photo;
  final int? otp;
  final String? otpExpireAt;
  final dynamic userType;
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
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        email = json['email'] as String?,
        emailVerifiedAt = json['email_verified_at'],
        dialCode = json['dial_code'] as String?,
        mobile = json['mobile'] as String?,
        gender = json['gender'],
        cityType = json['city_type'],
        fullAddress = json['full_address'],
        address = json['address'],
        city = json['city'],
        state = json['state'],
        postalCode = json['postal_code'],
        longitude = json['longitude'],
        latitude = json['latitude'],
        photo = json['photo'],
        otp = json['otp'] as int?,
        otpExpireAt = json['otp_expire_at'] as String?,
        userType = json['user_type'],
        registrationDone = json['registration_done'] as int?,
        status = json['status'] as int?,
        fcmToken = json['fcm_token'] as String?,
        googleId = json['google_id'],
        facebookId = json['facebook_id'],
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        profilePhotoUrl = json['profile_photo_url'],
        profilePhotoThumbUrl = json['profile_photo_thumb_url'];

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
        'profile_photo_thumb_url': profilePhotoThumbUrl
      };
}
