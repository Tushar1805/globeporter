class CreateOrderResponse {
  final bool? status;
  final int? statusCode;
  final String? message;
  final Data? data;

  CreateOrderResponse({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  CreateOrderResponse.fromJson(final Map<String, dynamic>? json)
      : status = json?['status'] as bool?,
        statusCode = json?['status_code'] as int?,
        message = json?['message'] as String?,
        data = (json?['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json?['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'status': status, 'status_code': statusCode, 'message': message, 'data': data?.toJson()};
}

class Data {
  final String? orderId;
  final int? amount;

  Data({
    this.orderId,
    this.amount,
  });

  Data.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'] as String?,
        amount = json['amount'] as int?;

  Map<String, dynamic> toJson() => {'order_id': orderId, 'amount': amount};
}
