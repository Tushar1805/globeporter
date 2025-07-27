class VerificationStatusResponse {
  final bool? status;
  final int? statusCode;
  final String? message;
  final int? isDocVerified;
  final List<Data>? data;

  VerificationStatusResponse({
    this.status,
    this.statusCode,
    this.message,
    this.isDocVerified,
    this.data,
  });

  VerificationStatusResponse.fromJson(final Map<String, dynamic>? json)
      : status = json?['status'] as bool?,
        statusCode = json?['status_code'] as int?,
        message = json?['message'] as String?,
        isDocVerified = json?['is_doc_verified'] as int?,
        data = (json?['data'] as List?)
            ?.map((dynamic e) => Data.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'status': status,
        'status_code': statusCode,
        'message': message,
        'is_doc_verified': isDocVerified,
        'data': data?.map((e) => e.toJson()).toList()
      };
}

class Data {
  final String? title;
  final String? description;
  final String? type;

  Data({
    this.title,
    this.description,
    this.type,
  });

  Data.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String?,
        description = json['description'] as String?,
        type = json['type'] as String?;

  Map<String, dynamic> toJson() => {'title': title, 'description': description, 'type': type};
}
