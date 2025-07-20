class RegisterResponseModel {
  final bool? status;
  final int? statusCode;
  final String? token;
  final String? message;
  final int? userId;
  final int? registrationDone;

  RegisterResponseModel({
    this.status,
    this.statusCode,
    this.token,
    this.message,
    this.userId,
    this.registrationDone,
  });

  RegisterResponseModel.fromJson(final Map<String, dynamic>? json)
      : status = json?['status'] as bool?,
        statusCode = json?['status_code'] as int?,
        token = json?['token'] as String?,
        message = json?['message'] as String?,
        userId = json?['user_id'] as int?,
        registrationDone = json?['registration_done'] as int?;

  Map<String, dynamic> toJson() => {
        'status': status,
        'status_code': statusCode,
        'token': token,
        'message': message,
        'user_id': userId,
        'registration_done': registrationDone
      };
}
