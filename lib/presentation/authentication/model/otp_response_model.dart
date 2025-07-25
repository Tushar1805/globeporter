class OtpResponseModel {
  final bool? status;
  final int? statusCode;
  final String? message;
  final String? token;
  final int? userType;
  final bool? detailsFilled;
  final int? ownerDetailsFilled;
  final int? vehicleDetailsFilled;
  final int? driverDetailsFilled;

  OtpResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.token,
    this.userType,
    this.detailsFilled,
    this.ownerDetailsFilled,
    this.vehicleDetailsFilled,
    this.driverDetailsFilled,
  });

  OtpResponseModel.fromJson(final Map<String, dynamic>? json)
      : status = json?['status'] as bool?,
        statusCode = json?['status_code'] as int?,
        message = json?['message'] as String?,
        token = json?['token'] as String?,
        userType = json?['userType'] as int?,
        detailsFilled = json?['details_filled'] as bool?,
        ownerDetailsFilled = json?['vehicleDetail_owner'] as int?,
        vehicleDetailsFilled = json?['vehicleDetail_vehicle'] as int?,
        driverDetailsFilled = json?['vehicleDetail_driver'] as int?;

  Map<String, dynamic> toJson() => {
        'status': status,
        'status_code': statusCode,
        'message': message,
        'token': token,
        'userType': userType,
        'details_filled': detailsFilled,
        'vehicleDetail_owner': ownerDetailsFilled,
        'vehicleDetail_vehicle': vehicleDetailsFilled,
        'vehicleDetail_driver': driverDetailsFilled,
      };
}
