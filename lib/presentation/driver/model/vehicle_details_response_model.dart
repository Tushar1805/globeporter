class VehicleDetailsResponseModel {
  final bool? status;
  final int? statusCode;
  final String? message;
  final Data? data;

  VehicleDetailsResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  VehicleDetailsResponseModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as bool?,
        statusCode = json['status_code'] as int?,
        message = json['message'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'status': status, 'status_code': statusCode, 'message': message, 'data': data?.toJson()};
}

class Data {
  final int? id;
  final int? vehicleTypeId;
  final String? vehicleRc;
  final String? vehicleRcBack;
  final String? vehicleNo;
  final String? vehicleRegistration;
  final String? vehiclePhoto;
  final int? isVehicleRcVerified;
  final int? isVehicleRcBackVerified;
  final int? isVehiclePhotoVerified;
  final String? vehicleRcUrl;
  final String? vehicleRcBackUrl;
  final String? vehiclePhotoUrl;

  Data({
    this.id,
    this.vehicleTypeId,
    this.vehicleRc,
    this.vehicleRcBack,
    this.vehicleNo,
    this.vehicleRegistration,
    this.vehiclePhoto,
    this.isVehicleRcVerified,
    this.isVehicleRcBackVerified,
    this.isVehiclePhotoVerified,
    this.vehicleRcUrl,
    this.vehicleRcBackUrl,
    this.vehiclePhotoUrl,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        vehicleTypeId = json['vehicle_type_id'] as int?,
        vehicleRc = json['vehicle_rc'] as String?,
        vehicleRcBack = json['vehicle_rc_back'] as String?,
        vehicleNo = json['vehicle_no'] as String?,
        vehicleRegistration = json['vehicle_registration'] as String?,
        vehiclePhoto = json['vehicle_photo'] as String?,
        isVehicleRcVerified = json['is_vehicle_rc_verified'] as int?,
        isVehicleRcBackVerified = json['is_vehicle_rc_back_verified'] as int?,
        isVehiclePhotoVerified = json['is_vehicle_photo_verified'] as int?,
        vehicleRcUrl = json['vehicle_rc_url'] as String?,
        vehicleRcBackUrl = json['vehicle_rc_back_url'] as String?,
        vehiclePhotoUrl = json['vehicle_photo_url'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicle_type_id': vehicleTypeId,
        'vehicle_rc': vehicleRc,
        'vehicle_rc_back': vehicleRcBack,
        'vehicle_no': vehicleNo,
        'vehicle_registration': vehicleRegistration,
        'vehicle_photo': vehiclePhoto,
        'is_vehicle_rc_verified': isVehicleRcVerified,
        'is_vehicle_rc_back_verified': isVehicleRcBackVerified,
        'is_vehicle_photo_verified': isVehiclePhotoVerified,
        'vehicle_rc_url': vehicleRcUrl,
        'vehicle_rc_back_url': vehicleRcBackUrl,
        'vehicle_photo_url': vehiclePhotoUrl
      };
}
