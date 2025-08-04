class RideAcceptedResponse {
  final bool? status;
  final int? statusCode;
  final String? message;
  final Data? data;

  RideAcceptedResponse({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  RideAcceptedResponse.fromJson(final Map<String, dynamic>? json)
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
  final User? user;
  final Driver? driver;

  Data({
    this.user,
    this.driver,
  });

  Data.fromJson(final Map<String, dynamic> json)
      : user = (json['user'] as Map<String, dynamic>?) != null
            ? User.fromJson(json['user'] as Map<String, dynamic>)
            : null,
        driver = (json['driver'] as Map<String, dynamic>?) != null
            ? Driver.fromJson(json['driver'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'user': user?.toJson(),
        'driver': driver?.toJson(),
      };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? dialCode;
  final String? mobile;
  final dynamic profilePhotoUrl;
  final dynamic profilePhotoThumbUrl;

  User({
    this.id,
    this.name,
    this.email,
    this.dialCode,
    this.mobile,
    this.profilePhotoUrl,
    this.profilePhotoThumbUrl,
  });

  User.fromJson(final Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        email = json['email'] as String?,
        dialCode = json['dial_code'] as String?,
        mobile = json['mobile'] as String?,
        profilePhotoUrl = json['profile_photo_url'],
        profilePhotoThumbUrl = json['profile_photo_thumb_url'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'dial_code': dialCode,
        'mobile': mobile,
        'profile_photo_url': profilePhotoUrl,
        'profile_photo_thumb_url': profilePhotoThumbUrl
      };
}

class Driver {
  final int? id;
  final String? name;
  final dynamic email;
  final String? dialCode;
  final String? mobile;
  final dynamic profilePhotoUrl;
  final dynamic profilePhotoThumbUrl;

  Driver({
    this.id,
    this.name,
    this.email,
    this.dialCode,
    this.mobile,
    this.profilePhotoUrl,
    this.profilePhotoThumbUrl,
  });

  Driver.fromJson(final Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        email = json['email'],
        dialCode = json['dial_code'] as String?,
        mobile = json['mobile'] as String?,
        profilePhotoUrl = json['profile_photo_url'],
        profilePhotoThumbUrl = json['profile_photo_thumb_url'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'dial_code': dialCode,
        'mobile': mobile,
        'profile_photo_url': profilePhotoUrl,
        'profile_photo_thumb_url': profilePhotoThumbUrl
      };
}
