class WalletHistoryResponse {
  final bool? status;
  final int? statusCode;
  final String? message;
  final List<Data>? data;

  WalletHistoryResponse({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  WalletHistoryResponse.fromJson(final Map<String, dynamic>? json)
      : status = json?['status'] as bool?,
        statusCode = json?['status_code'] as int?,
        message = json?['message'] as String?,
        data = (json?['data'] as List?)
            ?.map((dynamic e) => Data.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'status': status,
        'status_code': statusCode,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList()
      };
}

class Data {
  final int? id;
  final int? userId;
  final String? invoiceId;
  final int? balance;
  final int? credit;
  final int? debit;
  final int? remaining;
  final String? transactionsType;
  final dynamic transactionId;
  final dynamic transactionDate;
  final dynamic transactionTime;
  final int? transactionAmount;
  final dynamic paymentStatus;
  final int? bookingId;
  final int? status;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Data({
    this.id,
    this.userId,
    this.invoiceId,
    this.balance,
    this.credit,
    this.debit,
    this.remaining,
    this.transactionsType,
    this.transactionId,
    this.transactionDate,
    this.transactionTime,
    this.transactionAmount,
    this.paymentStatus,
    this.bookingId,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['user_id'] as int?,
        invoiceId = json['invoice_id'] as String?,
        balance = json['balance'] as int?,
        credit = json['credit'] as int?,
        debit = json['debit'] as int?,
        remaining = json['remaining'] as int?,
        transactionsType = json['transactions_type'] as String?,
        transactionId = json['transaction_id'],
        transactionDate = json['transaction_date'],
        transactionTime = json['transaction_time'],
        transactionAmount = json['transaction_amount'] as int?,
        paymentStatus = json['payment_status'],
        bookingId = json['booking_id'] as int?,
        status = json['status'] as int?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'invoice_id': invoiceId,
        'balance': balance,
        'credit': credit,
        'debit': debit,
        'remaining': remaining,
        'transactions_type': transactionsType,
        'transaction_id': transactionId,
        'transaction_date': transactionDate,
        'transaction_time': transactionTime,
        'transaction_amount': transactionAmount,
        'payment_status': paymentStatus,
        'booking_id': bookingId,
        'status': status,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}
