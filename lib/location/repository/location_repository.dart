import 'package:core/utils/core_utils.dart';
import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:globeporter/location/model/search_places_response.dart';
import 'package:globeporter/resources/app_api.dart';
import 'package:globeporter/resources/app_api_keys.dart';

class LocationRepository extends BaseRepository {
  Future<SearchPlacesResponse?> searchPlaces({
    required final String input,
    required final String? sessionToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.get,
      apiUrl: '$searchPlacesUrl$input&key=$googleMapAPIKey&sessiontoken=',
    );
    customPrint(responseData.toString());
    return SearchPlacesResponse.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }
}
