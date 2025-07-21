class GoogleLoginResponseModel {
  final bool? status;
  final int? statusCode;
  final String? token;
  final String? message;
  final int? userId;
  final int? userType;
  final int? registrationDone;
  final bool? detailsFilled;

  GoogleLoginResponseModel({
    this.status,
    this.statusCode,
    this.token,
    this.message,
    this.userId,
    this.userType,
    this.registrationDone,
    this.detailsFilled,
  });

  GoogleLoginResponseModel.fromJson(final Map<String, dynamic>? json)
      : status = json?['status'] as bool?,
        statusCode = json?['status_code'] as int?,
        token = json?['token'] as String?,
        message = json?['message'] as String?,
        userId = json?['user_id'] as int?,
        userType = json?['userType'] as int?,
        registrationDone = json?['registration_done'] as int?,
        detailsFilled = json?['details_filled'] as bool?;

  Map<String, dynamic> toJson() => {
        'status': status,
        'status_code': statusCode,
        'token': token,
        'message': message,
        'user_id': userId,
        'userType': userType,
        'registration_done': registrationDone,
        'details_filled': detailsFilled
      };
}
