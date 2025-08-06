class CustomerRideBookingResponse {
  final bool? status;
  final int? statusCode;
  final String? message;
  final List<Data>? data;

  CustomerRideBookingResponse({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  CustomerRideBookingResponse.fromJson(final Map<String, dynamic>? json)
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
  final int? userId;
  final dynamic driverId;
  final dynamic vehicleId;
  final int? vehicleTypeId;
  final int? packageTypeId;
  final String? rideType;
  final String? receiverName;
  final String? receiverContactNo;
  final String? qty;
  final String? bookingDate;
  final dynamic rideCompletedTiming;
  final String? pickupAddress;
  final double? pickupLat;
  final double? pickupLng;
  final String? dropAddress;
  final double? dropLat;
  final double? dropLng;
  final dynamic startDate;
  final String? startTime;
  final dynamic endDate;
  final String? endTime;
  final dynamic cancelledBy;
  final dynamic cancellationReasonId;
  final dynamic cancellationReason;
  final String? bookingStatus;
  final int? status;
  final int? otp;
  final dynamic rating;
  final dynamic comment;
  final dynamic nearByDirvers;
  final int? driverNotify;
  final int? searchingDistance;
  final int? isBookingActive;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final dynamic driverData;
  final VehicleTypeData? vehicleTypeData;
  final PackageTypeData? packageTypeData;
  final List<BookingRideItem>? bookingRideItem;

  Data({
    this.id,
    this.userId,
    this.driverId,
    this.vehicleId,
    this.vehicleTypeId,
    this.packageTypeId,
    this.rideType,
    this.receiverName,
    this.receiverContactNo,
    this.qty,
    this.bookingDate,
    this.rideCompletedTiming,
    this.pickupAddress,
    this.pickupLat,
    this.pickupLng,
    this.dropAddress,
    this.dropLat,
    this.dropLng,
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
    this.nearByDirvers,
    this.driverNotify,
    this.searchingDistance,
    this.isBookingActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.driverData,
    this.vehicleTypeData,
    this.packageTypeData,
    this.bookingRideItem,
  });

  Data.fromJson(final Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['user_id'] as int?,
        driverId = json['driver_id'],
        vehicleId = json['vehicle_id'],
        vehicleTypeId = json['vehicle_type_id'] as int?,
        packageTypeId = json['package_type_id'] as int?,
        rideType = json['ride_type'] as String?,
        receiverName = json['receiver_name'] as String?,
        receiverContactNo = json['receiver_contact_no'] as String?,
        qty = json['qty'] as String?,
        bookingDate = json['booking_date'] as String?,
        rideCompletedTiming = json['ride_completed_timing'],
        pickupAddress = json['pickup_address'] as String?,
        pickupLat = json['pickup_lat'] as double?,
        pickupLng = json['pickup_lng'] as double?,
        dropAddress = json['drop_address'] as String?,
        dropLat = json['drop_lat'] as double?,
        dropLng = json['drop_lng'] as double?,
        startDate = json['start_date'],
        startTime = json['start_time'] as String?,
        endDate = json['end_date'],
        endTime = json['end_time'] as String?,
        cancelledBy = json['cancelled_by'],
        cancellationReasonId = json['cancellation_reason_id'],
        cancellationReason = json['cancellation_reason'],
        bookingStatus = json['booking_status'] as String?,
        status = json['status'] as int?,
        otp = json['otp'] as int?,
        rating = json['rating'],
        comment = json['comment'],
        nearByDirvers = json['near_by_dirvers'],
        driverNotify = json['driver_notify'] as int?,
        searchingDistance = json['searching_distance'] as int?,
        isBookingActive = json['is_booking_active'] as int?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        driverData = json['driver_data'],
        vehicleTypeData = (json['vehicle_type_data'] as Map<String, dynamic>?) != null
            ? VehicleTypeData.fromJson(json['vehicle_type_data'] as Map<String, dynamic>)
            : null,
        packageTypeData = (json['package_type_data'] as Map<String, dynamic>?) != null
            ? PackageTypeData.fromJson(json['package_type_data'] as Map<String, dynamic>)
            : null,
        bookingRideItem = ((json['booking_ride_item'] as List?) != null &&
                (json['booking_ride_item'] as List?)!.isNotEmpty)
            ? (json['booking_ride_item'] as List?)
                ?.map((dynamic e) => BookingRideItem.fromJson(e as Map<String, dynamic>))
                .toList()
            : [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'driver_id': driverId,
        'vehicle_id': vehicleId,
        'vehicle_type_id': vehicleTypeId,
        'package_type_id': packageTypeId,
        'ride_type': rideType,
        'receiver_name': receiverName,
        'receiver_contact_no': receiverContactNo,
        'qty': qty,
        'booking_date': bookingDate,
        'ride_completed_timing': rideCompletedTiming,
        'pickup_address': pickupAddress,
        'pickup_lat': pickupLat,
        'pickup_lng': pickupLng,
        'drop_address': dropAddress,
        'drop_lat': dropLat,
        'drop_lng': dropLng,
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
        'near_by_dirvers': nearByDirvers,
        'driver_notify': driverNotify,
        'searching_distance': searchingDistance,
        'is_booking_active': isBookingActive,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'driver_data': driverData,
        'vehicle_type_data': vehicleTypeData?.toJson(),
        'package_type_data': packageTypeData?.toJson(),
        'booking_ride_item': bookingRideItem?.map((e) => e.toJson()).toList()
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

  VehicleTypeData.fromJson(final Map<String, dynamic> json)
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

class PackageTypeData {
  final int? id;
  final String? nameEn;
  final String? nameMr;
  final String? nameHi;
  final int? status;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;

  PackageTypeData({
    this.id,
    this.nameEn,
    this.nameMr,
    this.nameHi,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  PackageTypeData.fromJson(final Map<String, dynamic> json)
      : id = json['id'] as int?,
        nameEn = json['name_en'] as String?,
        nameMr = json['name_mr'] as String?,
        nameHi = json['name_hi'] as String?,
        status = json['status'] as int?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_en': nameEn,
        'name_mr': nameMr,
        'name_hi': nameHi,
        'status': status,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}

class BookingRideItem {
  final int? id;
  final int? bookingId;
  final dynamic itemName;
  final String? itemImage;
  final String? description;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? itemImageUrl;

  BookingRideItem({
    this.id,
    this.bookingId,
    this.itemName,
    this.itemImage,
    this.description,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.itemImageUrl,
  });

  BookingRideItem.fromJson(final Map<String, dynamic> json)
      : id = json['id'] as int?,
        bookingId = json['booking_id'] as int?,
        itemName = json['item_name'],
        itemImage = json['item_image'] as String?,
        description = json['description'] as String?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        itemImageUrl = json['item_image_url'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'booking_id': bookingId,
        'item_name': itemName,
        'item_image': itemImage,
        'description': description,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'item_image_url': itemImageUrl
      };
}
