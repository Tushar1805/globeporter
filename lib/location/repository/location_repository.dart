import 'package:core/custom_exception.dart';
import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:globeporter/location/model/route_direction_response.dart';
import 'package:globeporter/location/model/search_places_response.dart';
import 'package:globeporter/resources/app_api.dart';
import 'package:globeporter/resources/app_api_keys.dart';

class LocationRepository extends BaseRepository {
  Future<Map<String, dynamic>> updateUserLocation({
    required final String lang,
    required final String token,
    required final String logitude,
    required final String latitude,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: updateUserLocationUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
        'longitude': logitude,
        'latitude': latitude,
      },
    );

    return responseData;
  }

  Future<SearchPlacesResponse?> searchPlaces({
    required final String input,
    required final String? sessionToken,
  }) async {
    try {
      final responseData = await fetchData(
        apiCallType: ApiCallType.get,
        apiUrl: '$searchPlacesUrl$input&key=$googleMapAPIKey&sessiontoken=$sessionToken',
      );
      // customPrint(responseData.toString());
      return SearchPlacesResponse.fromJson(
        responseData as Map<String, dynamic>?,
      );
    } catch (e) {
      ApiErrorException(e.toString());
      return null;
    }
  }

  Future<RouteDirectionsResponse?> routeDirection({
    required final double pickupLat,
    required final double pickupLng,
    required final double dropLat,
    required final double dropLng,
  }) async {
    try {
      final responseData = await fetchData(
        apiCallType: ApiCallType.get,
        apiUrl:
            '$routeDirectionUrl$pickupLat,$pickupLng&destination=$dropLat,$dropLng&key=$googleMapAPIKey',
      );
      // customPrint(responseData.toString());

      if (responseData['status'] == 'OK') {
        return RouteDirectionsResponse.fromJson(
          responseData as Map<String, dynamic>?,
        );
      }
      return null;
    } catch (e) {
      ApiErrorException(e.toString());
      return null;
    }
  }
}
