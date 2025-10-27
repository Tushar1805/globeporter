class CustomerPostedRidesListModel {
  final bool? status;
  final int? statusCode;
  final String? message;
  final List<Data>? data;

  CustomerPostedRidesListModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  CustomerPostedRidesListModel.fromJson(final Map<String, dynamic>? json)
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
  final dynamic startDate;
  final String? startTime;
  final dynamic endDate;
  final String? endTime;
  final dynamic cancelledBy;
  final dynamic cancellationReasonId;
  final dynamic cancellationReason;
  final String? bookingStatus;
  final int? status;
  final int? isBookingActive;
  final double? distance;
  final dynamic userData;
  final VehicleTypeData? vehicleTypeData;
  final List<dynamic>? bookingRideItem;
  final List<dynamic>? bookingRideDriverPackage;
  final List<dynamic>? bookingRideUserPackage;

  Data({
    this.id,
    this.userId,
    this.driverId,
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
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.cancelledBy,
    this.cancellationReasonId,
    this.cancellationReason,
    this.bookingStatus,
    this.status,
    this.isBookingActive,
    this.distance,
    this.userData,
    this.vehicleTypeData,
    this.bookingRideItem,
    this.bookingRideDriverPackage,
    this.bookingRideUserPackage,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['user_id'],
        driverId = json['driver_id'] as int?,
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
        startDate = json['start_date'],
        startTime = json['start_time'] as String?,
        endDate = json['end_date'],
        endTime = json['end_time'] as String?,
        cancelledBy = json['cancelled_by'],
        cancellationReasonId = json['cancellation_reason_id'],
        cancellationReason = json['cancellation_reason'],
        bookingStatus = json['booking_status'] as String?,
        status = json['status'] as int?,
        isBookingActive = json['is_booking_active'] as int?,
        distance = json['distance'] as double?,
        userData = json['user_data'],
        vehicleTypeData = (json['vehicle_type_data'] as Map<String, dynamic>?) != null
            ? VehicleTypeData.fromJson(json['vehicle_type_data'] as Map<String, dynamic>)
            : null,
        bookingRideItem = json['booking_ride_item'] as List?,
        bookingRideDriverPackage = json['booking_ride_driver_package'] as List?,
        bookingRideUserPackage = json['booking_ride_user_package'] as List?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'driver_id': driverId,
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
        'start_date': startDate,
        'start_time': startTime,
        'end_date': endDate,
        'end_time': endTime,
        'cancelled_by': cancelledBy,
        'cancellation_reason_id': cancellationReasonId,
        'cancellation_reason': cancellationReason,
        'booking_status': bookingStatus,
        'status': status,
        'is_booking_active': isBookingActive,
        'distance': distance,
        'user_data': userData,
        'vehicle_type_data': vehicleTypeData?.toJson(),
        'booking_ride_item': bookingRideItem,
        'booking_ride_driver_package': bookingRideDriverPackage,
        'booking_ride_user_package': bookingRideUserPackage
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
