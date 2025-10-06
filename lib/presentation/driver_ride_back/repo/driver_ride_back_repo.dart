import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:globeporter/presentation/authentication/model/vehicle_type_response_model.dart';
import 'package:globeporter/presentation/driver_ride_back/model/my_posted_ride_model.dart';
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

  Future<MyPostedRidesModel?> getMyPostedRides({
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

    return MyPostedRidesModel.fromJson(
      responseData as Map<String, dynamic>?,
    );
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
