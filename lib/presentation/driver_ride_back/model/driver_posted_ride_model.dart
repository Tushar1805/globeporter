class DriverPostedRidesModel {
  final bool? status;
  final int? statusCode;
  final String? message;
  final List<Data>? data;

  DriverPostedRidesModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  DriverPostedRidesModel.fromJson(final Map<String, dynamic>? json)
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
        'data': data?.map((e) => e.toJson()).toList()
      };
}

class Data {
  final int? id;
  final dynamic userId;
  final int? driverId;
  final int? vehicleId;
  final int? vehicleTypeId;
  final dynamic rideType;
  final dynamic receiverName;
  final dynamic receiverContactNo;
  final String? bookingDate;
  final dynamic rideCompletedTiming;
  final String? pickupAddress;
  final double? pickupLat;
  final double? pickupLng;
  final String? dropAddress;
  final double? dropLat;
  final double? dropLng;
  final int? price;
  final String? moveDate;
  final String? moveTime;
  final dynamic startDate;
  final String? startTime;
  final dynamic endDate;
  final String? endTime;
  final dynamic cancelledBy;
  final dynamic cancellationReasonId;
  final dynamic cancellationReason;
  final String? bookingStatus;
  final int? status;
  final dynamic otp;
  final dynamic rating;
  final dynamic comment;
  final dynamic nearByCustomers;
  final int? customerNotify;
  final int? searchingDistance;
  final int? isBookingActive;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final dynamic userData;
  final VehicleTypeData? vehicleTypeData;
  final List<AcceptedDriverBookingRideStatus>? acceptedDriverBookingRideStatus;

  Data({
    this.id,
    this.userId,
    this.driverId,
    this.vehicleId,
    this.vehicleTypeId,
    this.rideType,
    this.receiverName,
    this.receiverContactNo,
    this.bookingDate,
    this.rideCompletedTiming,
    this.pickupAddress,
    this.pickupLat,
    this.pickupLng,
    this.dropAddress,
    this.dropLat,
    this.dropLng,
    this.price,
    this.moveDate,
    this.moveTime,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.cancelledBy,
    this.cancellationReasonId,
    this.cancellationReason,
    this.bookingStatus,
    this.status,
    this.otp,
    this.rating,
    this.comment,
    this.nearByCustomers,
    this.customerNotify,
    this.searchingDistance,
    this.isBookingActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.userData,
    this.vehicleTypeData,
    this.acceptedDriverBookingRideStatus,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['user_id'],
        driverId = json['driver_id'] as int?,
        vehicleId = json['vehicle_id'] as int?,
        vehicleTypeId = json['vehicle_type_id'] as int?,
        rideType = json['ride_type'],
        receiverName = json['receiver_name'],
        receiverContactNo = json['receiver_contact_no'],
        bookingDate = json['booking_date'] as String?,
        rideCompletedTiming = json['ride_completed_timing'],
        pickupAddress = json['pickup_address'] as String?,
        pickupLat = json['pickup_lat'] as double?,
        pickupLng = json['pickup_lng'] as double?,
        dropAddress = json['drop_address'] as String?,
        dropLat = json['drop_lat'] as double?,
        dropLng = json['drop_lng'] as double?,
        price = json['price'] as int?,
        moveDate = json['move_date'] as String?,
        moveTime = json['move_time'] as String?,
        startDate = json['start_date'],
        startTime = json['start_time'] as String?,
        endDate = json['end_date'],
        endTime = json['end_time'] as String?,
        cancelledBy = json['cancelled_by'],
        cancellationReasonId = json['cancellation_reason_id'],
        cancellationReason = json['cancellation_reason'],
        bookingStatus = json['booking_status'] as String?,
        status = json['status'] as int?,
        otp = json['otp'],
        rating = json['rating'],
        comment = json['comment'],
        nearByCustomers = json['near_by_customers'],
        customerNotify = json['customer_notify'] as int?,
        searchingDistance = json['searching_distance'] as int?,
        isBookingActive = json['is_booking_active'] as int?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        userData = json['user_data'],
        vehicleTypeData = (json['vehicle_type_data'] as Map<String, dynamic>?) != null
            ? VehicleTypeData.fromJson(json['vehicle_type_data'] as Map<String, dynamic>)
            : null,
        acceptedDriverBookingRideStatus = (json['accepted_driver_booking_ride_status'] as List?)
            ?.map(
                (dynamic e) => AcceptedDriverBookingRideStatus.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'driver_id': driverId,
        'vehicle_id': vehicleId,
        'vehicle_type_id': vehicleTypeId,
        'ride_type': rideType,
        'receiver_name': receiverName,
        'receiver_contact_no': receiverContactNo,
        'booking_date': bookingDate,
        'ride_completed_timing': rideCompletedTiming,
        'pickup_address': pickupAddress,
        'pickup_lat': pickupLat,
        'pickup_lng': pickupLng,
        'drop_address': dropAddress,
        'drop_lat': dropLat,
        'drop_lng': dropLng,
        'price': price,
        'move_date': moveDate,
        'move_time': moveTime,
        'start_date': startDate,
        'start_time': startTime,
        'end_date': endDate,
        'end_time': endTime,
        'cancelled_by': cancelledBy,
        'cancellation_reason_id': cancellationReasonId,
        'cancellation_reason': cancellationReason,
        'booking_status': bookingStatus,
        'status': status,
        'otp': otp,
        'rating': rating,
        'comment': comment,
        'near_by_customers': nearByCustomers,
        'customer_notify': customerNotify,
        'searching_distance': searchingDistance,
        'is_booking_active': isBookingActive,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'user_data': userData,
        'vehicle_type_data': vehicleTypeData?.toJson(),
        'accepted_driver_booking_ride_status':
            acceptedDriverBookingRideStatus?.map((e) => e.toJson()).toList()
      };
}

class VehicleTypeData {
  final int? id;
  final String? nameEn;
  final String? nameMr;
  final String? nameHi;
  final String? image;
  final int? status;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? imageUrl;

  VehicleTypeData({
    this.id,
    this.nameEn,
    this.nameMr,
    this.nameHi,
    this.image,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  VehicleTypeData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        nameEn = json['name_en'] as String?,
        nameMr = json['name_mr'] as String?,
        nameHi = json['name_hi'] as String?,
        image = json['image'] as String?,
        status = json['status'] as int?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        imageUrl = json['image_url'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_en': nameEn,
        'name_mr': nameMr,
        'name_hi': nameHi,
        'image': image,
        'status': status,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'image_url': imageUrl
      };
}

class AcceptedDriverBookingRideStatus {
  final int? id;
  final int? userId;
  final int? bookingId;
  final dynamic cancellationReasonId;
  final String? status;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? userName;
  final UserData? userData;

  AcceptedDriverBookingRideStatus({
    this.id,
    this.userId,
    this.bookingId,
    this.cancellationReasonId,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.userData,
  });

  AcceptedDriverBookingRideStatus.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['user_id'] as int?,
        bookingId = json['booking_id'] as int?,
        cancellationReasonId = json['cancellation_reason_id'],
        status = json['status'] as String?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        userName = json['user_name'] as String?,
        userData = (json['user_data'] as Map<String, dynamic>?) != null
            ? UserData.fromJson(json['user_data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'booking_id': bookingId,
        'cancellation_reason_id': cancellationReasonId,
        'status': status,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'user_name': userName,
        'user_data': userData?.toJson()
      };
}

class UserData {
  final int? id;
  final String? name;
  final String? email;
  final String? dialCode;
  final String? mobile;
  final dynamic profilePhotoUrl;
  final dynamic profilePhotoThumbUrl;

  UserData({
    this.id,
    this.name,
    this.email,
    this.dialCode,
    this.mobile,
    this.profilePhotoUrl,
    this.profilePhotoThumbUrl,
  });

  UserData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        email = json['email'] as String?,
        dialCode = json['dial_code'] as String?,
        mobile = json['mobile'] as String?,
        profilePhotoUrl = json['profile_photo_url'],
        profilePhotoThumbUrl = json['profile_photo_thumb_url'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'dial_code': dialCode,
        'mobile': mobile,
        'profile_photo_url': profilePhotoUrl,
        'profile_photo_thumb_url': profilePhotoThumbUrl
      };
}
