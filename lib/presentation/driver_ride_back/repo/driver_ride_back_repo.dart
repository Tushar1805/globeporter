import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:globeporter/presentation/authentication/model/vehicle_type_response_model.dart';
import 'package:globeporter/presentation/driver/model/ride_cancellation_reason_response.dart';
import 'package:globeporter/presentation/driver_ride_back/model/customer_posted_ride_list_model.dart';
import 'package:globeporter/presentation/driver_ride_back/model/driver_posted_ride_model.dart';
import 'package:globeporter/resources/app_api.dart';

class DriverRideBackRepository extends BaseRepository {
  Future<VehicleTypeResponseModel?> getVehicleType({
    required final String lang,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getVehicleTypeUrl,
      requestModel: {
        'lang': lang,
      },
    );

    return VehicleTypeResponseModel.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  //* Get posted ride for driver
  Future<DriverPostedRidesModel?> getDriverPostedRides({
    required final String lang,
    required final String token,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: myPlacedBookingRideUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
      },
    );

    return DriverPostedRidesModel.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  //* Get list of posted rides for customer
  Future<CustomerPostedRidesListModel?> getCustomerPostedRides({
    required final String lang,
    required final String token,
    required final String currentLat,
    required final String currentLng,
    required final String radius,
    final String? dropLat,
    final String? dropLng,
    final String? price,
    final String? orderByColumn,
    final String? orderByType,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: pendingDriverBookingUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
        'radius': radius,
        "latitude": currentLat, // current location
        "longitude": currentLng,
        "drop_lat": dropLat ?? '', //28.586643805797078 -> drop location
        "drop_lng": dropLng ?? '', //77.28683285415173
        "price": price ?? '',
        "order_by_col": orderByColumn ?? '', //price
        "order_by_type": orderByType ?? '', // only asc or desc
      },
    );

    return CustomerPostedRidesListModel.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  Future<Map<String, dynamic>> customerAccepRejectRide({
    required final String lang,
    required final String token,
    required final String bookingId,
    required final String status, // Accept or Reject
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: customerAccepRejectRideUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
        "booking_id": bookingId,
        "status": status,
      },
    );

    return responseData;
  }

  Future<Map<String, dynamic>> customerCancelRide({
    required final String lang,
    required final String token,
    required final String bookingId,
    required final String bookingCancellationId,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: cancelRideByCustomerUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
        "booking_id": bookingId,
        "booking_cancellation_reason_id": bookingCancellationId,
      },
    );

    return responseData;
  }

  Future<Map<String, dynamic>> driverCancelRide({
    required final String lang,
    required final String token,
    required final String bookingId,
    required final String bookingCancellationId,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: cancelRideByDriverUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
        "booking_id": bookingId,
        "booking_cancellation_reason_id": bookingCancellationId,
      },
    );

    return responseData;
  }

  Future<RideCancellationReasonResponse?> getRideCancellationReasons({
    required final String lang,
    required final String userType,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getRideCancellationReasonsUrl,
      requestModel: {
        'lang': lang,
        "user_type": userType,
      },
    );

    return RideCancellationReasonResponse.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  Future<Map<String, dynamic>> driverAccepRejectRide({
    required final String lang,
    required final String token,
    required final String bookingId,
    required final String userId,
    required final String status, // Accept or Reject
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: driverAccepRejectRideUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
        "booking_id": bookingId,
        "user_id": userId,
        "status": status,
      },
    );

    return responseData;
  }

  //* find customers for the ride
  Future<Map<String, dynamic>> findCustomer(
      {required final String lang,
      required final String token,
      required final String bookingId,
      required final String distance}) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: findCustomerUrl,
      accessToken: token,
      requestModel: {
        "lang": lang,
        "booking_id": bookingId,
        "distance": distance,
      },
    );

    return responseData;
  }

  //* Generate OTP
  Future<Map<String, dynamic>> generatePostedRideOtp({
    required final String lang,
    required final String token,
    required final int bookingId,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: generateOtpPostedRideUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
        'booking_id': bookingId,
      },
    );

    return responseData;
  }

  //* Verify OTP
  Future<Map<String, dynamic>> verifyOtpPostedRideByDriver({
    required final String lang,
    required final String token,
    required final String otp,
    required final int bookingId,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: verifyOtpPosterRideUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
        'booking_id': bookingId,
        'otp': otp,
      },
    );

    return responseData;
  }

  //* End ride by driver
  Future<Map<String, dynamic>> endRideByDriver({
    required final String lang,
    required final String token,
    required final int bookingId,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: endRideDriverUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
        'booking_id': bookingId,
      },
    );

    return responseData;
  }

  //* Place driver ride
  Future<Map<String, dynamic>> placeDriverBookingRide({
    required final String lang,
    required final String token,
    required final int vehicleTypeId,
    required final String pickupAddress,
    required final String dropAddress,
    required final String pickupLat,
    required final String pickupLng,
    required final String dropLat,
    required final String dropLng,
    required final String price,
    required final String moveDate,
    required final String moveTime,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: placeDriverBookingRideUrl,
      accessToken: token,
      requestModel: {
        "lang": lang,
        "vehicle_type_id": vehicleTypeId,
        "pickup_address": pickupAddress,
        "pickup_lat": pickupLat,
        "pickup_lng": pickupLng,
        "drop_address": dropAddress,
        "drop_lat": dropLat,
        "drop_lng": dropLng,
        "price": price,
        "move_date": moveDate,
        "move_time": moveTime
      },
    );

    return responseData;
  }
}
