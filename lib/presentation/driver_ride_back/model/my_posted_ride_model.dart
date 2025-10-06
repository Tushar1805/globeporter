class MyPostedRidesModel {
  final bool? status;
  final int? statusCode;
  final String? message;
  final List<Data>? data;

  MyPostedRidesModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  MyPostedRidesModel.fromJson(final Map<String, dynamic>? json)
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
  final dynamic userId;
  final int? driverId;
  final int? vehicleId;
  final int? vehicleTypeId;
  final String? pickupAddress;
  final double? pickupLat;
  final double? pickupLng;
  final String? dropAddress;
  final double? dropLat;
  final double? dropLng;
  final String? bookingDate;
  final String? bookingStatus;
  final int? status;
  final dynamic nearByCustomers;
  final int? driverNotify;
  final int? searchingDistance;
  final int? isBookingActive;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final dynamic userData;
  final VehicleTypeData? vehicleTypeData;

  Data({
    this.id,
    this.userId,
    this.driverId,
    this.vehicleId,
    this.vehicleTypeId,
    this.pickupAddress,
    this.pickupLat,
    this.pickupLng,
    this.dropAddress,
    this.dropLat,
    this.dropLng,
    this.bookingDate,
    this.bookingStatus,
    this.status,
    this.nearByCustomers,
    this.driverNotify,
    this.searchingDistance,
    this.isBookingActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.userData,
    this.vehicleTypeData,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['user_id'],
        driverId = json['driver_id'] as int?,
        vehicleId = json['vehicle_id'] as int?,
        vehicleTypeId = json['vehicle_type_id'] as int?,
        pickupAddress = json['pickup_address'] as String?,
        pickupLat = json['pickup_lat'] as double?,
        pickupLng = json['pickup_lng'] as double?,
        dropAddress = json['drop_address'] as String?,
        dropLat = json['drop_lat'] as double?,
        dropLng = json['drop_lng'] as double?,
        bookingDate = json['booking_date'] as String?,
        bookingStatus = json['booking_status'] as String?,
        status = json['status'] as int?,
        nearByCustomers = json['near_by_customers'],
        driverNotify = json['driver_notify'] as int?,
        searchingDistance = json['searching_distance'] as int?,
        isBookingActive = json['is_booking_active'] as int?,
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        userData = json['user_data'],
        vehicleTypeData = (json['vehicle_type_data'] as Map<String, dynamic>?) != null
            ? VehicleTypeData.fromJson(json['vehicle_type_data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'driver_id': driverId,
        'vehicle_id': vehicleId,
        'vehicle_type_id': vehicleTypeId,
        'pickup_address': pickupAddress,
        'pickup_lat': pickupLat,
        'pickup_lng': pickupLng,
        'drop_address': dropAddress,
        'drop_lat': dropLat,
        'drop_lng': dropLng,
        'booking_date': bookingDate,
        'booking_status': bookingStatus,
        'status': status,
        'near_by_customers': nearByCustomers,
        'driver_notify': driverNotify,
        'searching_distance': searchingDistance,
        'is_booking_active': isBookingActive,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'user_data': userData,
        'vehicle_type_data': vehicleTypeData?.toJson()
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
