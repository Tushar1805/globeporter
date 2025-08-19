class NotificationsResponse {
  final bool? status;
  final int? statusCode;
  final String? message;
  final List<Data>? data;

  NotificationsResponse({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  NotificationsResponse.fromJson(final Map<String, dynamic>? json)
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
  final int? bookingId;
  final String? title;
  final String? message;
  final String? rideType;
  final String? userType;
  final String? type;
  final dynamic paramId;
  final dynamic senderId;
  final dynamic senderName;
  final dynamic receiverId;
  final dynamic receiverName;
  final dynamic receiverImageUrl;
  final int? readStatus;
  final int? status;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Data({
    this.id,
    this.userId,
    this.bookingId,
    this.title,
    this.message,
    this.rideType,
    this.userType,
    this.type,
    this.paramId,
    this.senderId,
    this.senderName,
    this.receiverId,
    this.receiverName,
    this.receiverImageUrl,
    this.readStatus,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['user_id'] as int?,
        bookingId = json['booking_id'] as int?,
        title = json['title'] as String?,
        message = json['message'] as String?,
        rideType = json['ride_type'] as String?,
        userType = json['user_type'] as String?,
        type = json['type'] as String?,
        paramId = json['param_id'],
        senderId = json['sender_id'],
        senderName = json['senderName'],
        receiverId = json['receiver_id'],
        receiverName = json['receiverName'],
        receiverImageUrl = json['receiverImageUrl'],
        readStatus = json['read_status'] as int?,
        status = json['status'] as int?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'booking_id': bookingId,
        'title': title,
        'message': message,
        'ride_type': rideType,
        'user_type': userType,
        'type': type,
        'param_id': paramId,
        'sender_id': senderId,
        'senderName': senderName,
        'receiver_id': receiverId,
        'receiverName': receiverName,
        'receiverImageUrl': receiverImageUrl,
        'read_status': readStatus,
        'status': status,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}
