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
  final String? moveDate;
  final String? moveTime;
  final int? price;
  final double? distance;
  final int? isCustomerAcceptRide;
  final dynamic userData;
  final DriverData? driverData;
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
    this.moveDate,
    this.moveTime,
    this.price,
    this.distance,
    this.isCustomerAcceptRide,
    this.userData,
    this.driverData,
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
        moveDate = json['move_date'] as String?,
        moveTime = json['move_time'] as String?,
        price = json['price'] as int?,
        distance = json['distance'] as double?,
        isCustomerAcceptRide = json['is_customer_accept_ride'] as int?,
        userData = json['user_data'],
        driverData = (json['driver_data'] as Map<String, dynamic>?) != null
            ? DriverData.fromJson(json['driver_data'] as Map<String, dynamic>)
            : null,
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
        'move_date': moveDate,
        'move_time': moveTime,
        'price': price,
        'distance': distance,
        'is_customer_accept_ride': isCustomerAcceptRide,
        'user_data': userData,
        'driver_data': driverData?.toJson(),
        'vehicle_type_data': vehicleTypeData?.toJson(),
        'booking_ride_item': bookingRideItem,
        'booking_ride_driver_package': bookingRideDriverPackage,
        'booking_ride_user_package': bookingRideUserPackage
      };
}

class DriverData {
  final int? id;
  final String? name;
  final String? email;
  final dynamic emailVerifiedAt;
  final String? dialCode;
  final String? mobile;
  final dynamic gender;
  final dynamic cityType;
  final dynamic fullAddress;
  final dynamic address;
  final dynamic city;
  final dynamic state;
  final dynamic postalCode;
  final double? longitude;
  final double? latitude;
  final String? photo;
  final dynamic otp;
  final dynamic otpExpireAt;
  final int? userType;
  final int? registrationDone;
  final int? status;
  final String? fcmToken;
  final dynamic googleId;
  final dynamic facebookId;
  final String? lang;
  final int? isDriverVerified;
  final int? isDriverOnRide;
  final int? isCustomerOnRide;
  final int? isBonusDone;
  final dynamic referUserId;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? profilePhotoUrl;
  final String? profilePhotoThumbUrl;

  DriverData({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.dialCode,
    this.mobile,
    this.gender,
    this.cityType,
    this.fullAddress,
    this.address,
    this.city,
    this.state,
    this.postalCode,
    this.longitude,
    this.latitude,
    this.photo,
    this.otp,
    this.otpExpireAt,
    this.userType,
    this.registrationDone,
    this.status,
    this.fcmToken,
    this.googleId,
    this.facebookId,
    this.lang,
    this.isDriverVerified,
    this.isDriverOnRide,
    this.isCustomerOnRide,
    this.isBonusDone,
    this.referUserId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.profilePhotoUrl,
    this.profilePhotoThumbUrl,
  });

  DriverData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        email = json['email'] as String?,
        emailVerifiedAt = json['email_verified_at'],
        dialCode = json['dial_code'] as String?,
        mobile = json['mobile'] as String?,
        gender = json['gender'],
        cityType = json['city_type'],
        fullAddress = json['full_address'],
        address = json['address'],
        city = json['city'],
        state = json['state'],
        postalCode = json['postal_code'],
        longitude = json['longitude'] as double?,
        latitude = json['latitude'] as double?,
        photo = json['photo'] as String?,
        otp = json['otp'],
        otpExpireAt = json['otp_expire_at'],
        userType = json['user_type'] as int?,
        registrationDone = json['registration_done'] as int?,
        status = json['status'] as int?,
        fcmToken = json['fcm_token'] as String?,
        googleId = json['google_id'],
        facebookId = json['facebook_id'],
        lang = json['lang'] as String?,
        isDriverVerified = json['is_driver_verified'] as int?,
        isDriverOnRide = json['is_driver_on_ride'] as int?,
        isCustomerOnRide = json['is_customer_on_ride'] as int?,
        isBonusDone = json['is_bonus_done'] as int?,
        referUserId = json['refer_user_id'],
        deletedAt = json['deleted_at'],
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        profilePhotoUrl = json['profile_photo_url'] as String?,
        profilePhotoThumbUrl = json['profile_photo_thumb_url'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'email_verified_at': emailVerifiedAt,
        'dial_code': dialCode,
        'mobile': mobile,
        'gender': gender,
        'city_type': cityType,
        'full_address': fullAddress,
        'address': address,
        'city': city,
        'state': state,
        'postal_code': postalCode,
        'longitude': longitude,
        'latitude': latitude,
        'photo': photo,
        'otp': otp,
        'otp_expire_at': otpExpireAt,
        'user_type': userType,
        'registration_done': registrationDone,
        'status': status,
        'fcm_token': fcmToken,
        'google_id': googleId,
        'facebook_id': facebookId,
        'lang': lang,
        'is_driver_verified': isDriverVerified,
        'is_driver_on_ride': isDriverOnRide,
        'is_customer_on_ride': isCustomerOnRide,
        'is_bonus_done': isBonusDone,
        'refer_user_id': referUserId,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'profile_photo_url': profilePhotoUrl,
        'profile_photo_thumb_url': profilePhotoThumbUrl
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
