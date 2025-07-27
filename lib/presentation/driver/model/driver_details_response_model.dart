class DriverDetailsResponseModel {
  final bool? status;
  final int? statusCode;
  final String? message;
  final Data? data;

  DriverDetailsResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  DriverDetailsResponseModel.fromJson(final Map<String, dynamic>? json)
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
  final int? isDriverAadharCardVerified;
  final int? isDriverPanCardVerified;
  final int? isDriverPanCardBackVerified;
  final int? isDriverLicenseVerified;
  final int? isDriverAadharCardBackVerified;
  final int? isDriverLicenseBackVerified;
  final String? driverAadharCardUrl;
  final String? driverAadharCardBackUrl;
  final String? driverPanCardUrl;
  final String? driverPanCardBackUrl;
  final String? driverLicenseUrl;
  final String? driverLicenseBackUrl;

  Data({
    this.id,
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
    this.isDriverAadharCardVerified,
    this.isDriverPanCardVerified,
    this.isDriverPanCardBackVerified,
    this.isDriverLicenseVerified,
    this.isDriverAadharCardBackVerified,
    this.isDriverLicenseBackVerified,
    this.driverAadharCardUrl,
    this.driverAadharCardBackUrl,
    this.driverPanCardUrl,
    this.driverPanCardBackUrl,
    this.driverLicenseUrl,
    this.driverLicenseBackUrl,
  });

  Data.fromJson(final Map<String, dynamic> json)
      : id = json['id'] as int?,
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
        isDriverAadharCardVerified = json['is_driver_aadhar_card_verified'] as int?,
        isDriverPanCardVerified = json['is_driver_pan_card_verified'] as int?,
        isDriverPanCardBackVerified = json['is_driver_pan_card_back_verified'] as int?,
        isDriverLicenseVerified = json['is_driver_license_verified'] as int?,
        isDriverAadharCardBackVerified = json['is_driver_aadhar_card_back_verified'] as int?,
        isDriverLicenseBackVerified = json['is_driver_license_back_verified'] as int?,
        driverAadharCardUrl = json['driver_aadhar_card_url'] as String?,
        driverAadharCardBackUrl = json['driver_aadhar_card_back_url'] as String?,
        driverPanCardUrl = json['driver_pan_card_url'] as String?,
        driverPanCardBackUrl = json['driver_pan_card_back_url'] as String?,
        driverLicenseUrl = json['driver_license_url'] as String?,
        driverLicenseBackUrl = json['driver_license_back_url'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
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
        'is_driver_aadhar_card_verified': isDriverAadharCardVerified,
        'is_driver_pan_card_verified': isDriverPanCardVerified,
        'is_driver_pan_card_back_verified': isDriverPanCardBackVerified,
        'is_driver_license_verified': isDriverLicenseVerified,
        'is_driver_aadhar_card_back_verified': isDriverAadharCardBackVerified,
        'is_driver_license_back_verified': isDriverLicenseBackVerified,
        'driver_aadhar_card_url': driverAadharCardUrl,
        'driver_aadhar_card_back_url': driverAadharCardBackUrl,
        'driver_pan_card_url': driverPanCardUrl,
        'driver_pan_card_back_url': driverPanCardBackUrl,
        'driver_license_url': driverLicenseUrl,
        'driver_license_back_url': driverLicenseBackUrl
      };
}
