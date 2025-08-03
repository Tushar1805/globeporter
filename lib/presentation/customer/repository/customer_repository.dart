import 'dart:convert';
import 'package:core/custom_exception.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:datasource/network/api_response_type.dart';
import 'package:globeporter/presentation/authentication/model/vehicle_type_response_model.dart';
import 'package:globeporter/presentation/customer/model/customer_ride_response.dart';
import 'package:globeporter/presentation/customer/model/packaging_type_reponse.dart';
import 'package:globeporter/presentation/customer/view/request_details_screen.dart';
import 'package:globeporter/resources/app_api.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CustomerRepository extends BaseRepository {
  Future<PackagingTypeResponse?> getPackagingType({
    required final String lang,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getPackagingTypeUrl,
      requestModel: {
        'lang': lang,
      },
    );

    return PackagingTypeResponse.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

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

  Future<CustomerRideBookingResponse?> getCustomerRideBookings({
    required final String lang,
    required final String accessToken,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getCustomerBookingsUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
      },
    );

    return CustomerRideBookingResponse.fromJson(
      responseData as Map<String, dynamic>?,
    );
  }

  Future<Map<String, dynamic>> createRuralRequest({
    required final String lang,
    required final String accessToken,
    required final int vehicleTypeId,
    required final int packageTypeId,
    required final String receiverName,
    required final String receiverContact,
    required final String quantiry,
    required final String pickupAddress,
    required final String dropAddress,
    required final String pickupLat,
    required final String pickupLng,
    required final String dropLat,
    required final String dropLng,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: createRuralRequestUrl,
      accessToken: accessToken,
      requestModel: {
        "lang": lang,
        "vehicle_type_id": vehicleTypeId,
        "package_type_id": packageTypeId,
        "receiver_name": receiverName,
        "receiver_contact_no": receiverContact,
        "qty": quantiry,
        "pickup_address": pickupAddress,
        "pickup_lat": pickupLat,
        "pickup_lng": pickupLng,
        "drop_address": dropAddress,
        "drop_lat": dropLat,
        "drop_lng": dropLng
      },
    );

    return responseData;
  }

  Future<Map<String, dynamic>> createUrbanRequest({
    required String lang,
    required String accessToken,
    required int vehicleTypeId,
    required String receiverName,
    required String receiverContact,
    required String pickupAddress,
    required String dropAddress,
    required String pickupLat,
    required String pickupLng,
    required String dropLat,
    required String dropLng,
    required List<ItemEntry> itemEntries,
  }) async {
    final uri = Uri.parse(createUrbanRequestUrl);
    final request = http.MultipartRequest('POST', uri);

    // 🔹 Add simple fields directly
    request.fields['lang'] = lang;
    request.fields['vehicle_type_id'] = vehicleTypeId.toString();
    request.fields['receiver_name'] = receiverName;
    request.fields['receiver_contact_no'] = receiverContact;
    request.fields['pickup_address'] = pickupAddress;
    request.fields['pickup_lat'] = pickupLat;
    request.fields['pickup_lng'] = pickupLng;
    request.fields['drop_address'] = dropAddress;
    request.fields['drop_lat'] = dropLat;
    request.fields['drop_lng'] = dropLng;

    // 🔹 Loop through items and add their fields and files
    for (int i = 0; i < itemEntries.length; i++) {
      final entry = itemEntries[i];

      request.fields['items[$i][item_name]'] = ''; // optional for now
      request.fields['items[$i][description]'] = entry.descriptionController.text.trim();

      if (entry.imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'items[$i][item_image]',
            entry.imageFile!.path,
            contentType: MediaType('image', 'jpeg'), // adjust if needed
          ),
        );
      }
    }

    // 🔹 Add authorization or other headers
    request.headers.addAll({
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    // 🔹 Send the request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      customPrint('Upload successful: ${response.body}');
    } else {
      customPrint('Upload failed: ${response.statusCode}, ${response.body}');
    }
    final responseJson = _response(response, ApiResponseType.json);
    return responseJson;
  }

  dynamic _response(http.Response response, ApiResponseType apiResponseType) {
    switch (response.statusCode) {
      case 200:
        var body = utf8.decode(response.bodyBytes);
        if (apiResponseType == ApiResponseType.json) {
          dynamic responseJson = json.decode(body.toString());
          return responseJson;
        } else {
          return body;
        }
      case 201:
        var body = utf8.decode(response.bodyBytes);
        if (apiResponseType == ApiResponseType.json) {
          dynamic responseJson = json.decode(body.toString());
          return responseJson;
        } else {
          return body;
        }
      case 400:
        _checkApiErrors(response, apiResponseType);
        break;
      case 401:
      case 403:
        _checkApiErrors(response, apiResponseType);
        break;
      case 500:
        throw InternalServerException(response.body.toString());
      default:
        throw FetchDataException('Communication Error : ${response.statusCode}');
    }
  }

  void _checkApiErrors(http.Response response, ApiResponseType apiResponseType) {
    var body = utf8.decode(response.bodyBytes);
    if (apiResponseType == ApiResponseType.json) {
      dynamic responseJson = json.decode(body.toString());
      throw ApiErrorException(responseJson['message']);
    }
  }
}
