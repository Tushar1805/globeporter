class WalletDataResponse {
  final bool? status;
  final int? statusCode;
  final String? message;
  final Data? data;

  WalletDataResponse({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  WalletDataResponse.fromJson(final Map<String, dynamic>? json)
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
  final int? userId;
  final int? balance;
  final int? credit;
  final int? debit;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Data({
    this.id,
    this.userId,
    this.balance,
    this.credit,
    this.debit,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['user_id'] as int?,
        balance = json['balance'] as int?,
        credit = json['credit'] as int?,
        debit = json['debit'] as int?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'balance': balance,
        'credit': credit,
        'debit': debit,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}
