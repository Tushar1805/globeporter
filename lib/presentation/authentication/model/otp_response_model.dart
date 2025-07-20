class OtpResponseModel {
  final bool? status;
  final int? statusCode;
  final String? message;
  final String? token;

  OtpResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.token,
  });

  OtpResponseModel.fromJson(Map<String, dynamic>? json)
      : status = json?['status'] as bool?,
        statusCode = json?['status_code'] as int?,
        message = json?['message'] as String?,
        token = json?['token'] as String?;

  Map<String, dynamic> toJson() => {
        'status': status,
        'status_code': statusCode,
        'message': message,
        'token': token,
      };
}
