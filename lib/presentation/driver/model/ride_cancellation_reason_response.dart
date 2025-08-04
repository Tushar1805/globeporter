class RideCancellationReasonResponse {
  final bool? status;
  final int? statusCode;
  final String? message;
  final List<Data>? data;

  RideCancellationReasonResponse({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  RideCancellationReasonResponse.fromJson(final Map<String, dynamic>? json)
      : status = json?['status'] as bool?,
        statusCode = json?['status_code'] as int?,
        message = json?['message'] as String?,
        data = (json?['data'] as List?)
            ?.map((final dynamic e) => Data.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'status': status,
        'status_code': statusCode,
        'message': message,
        'data': data?.map((final e) => e.toJson()).toList()
      };
}

class Data {
  final int? id;
  final String? reason;
  final int? status;

  Data({
    this.id,
    this.reason,
    this.status,
  });

  Data.fromJson(final Map<String, dynamic> json)
      : id = json['id'] as int?,
        reason = json['reason'] as String?,
        status = json['status'] as int?;

  Map<String, dynamic> toJson() => {'id': id, 'reason': reason, 'status': status};
}
