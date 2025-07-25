import 'dart:io';

import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:globeporter/presentation/authentication/model/vehicle_type_response_model.dart';
import 'package:globeporter/resources/app_api.dart';

class DriverRepository extends BaseRepository {

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
  Future<Map<String, dynamic>?> submitOwnerDetails({
    required final String lang,
    required final String accessToken,
    required final String? ownerName,
    required final String? ownerPhoneNumber,
    required final File? ownerFrontAdhaar,
    required final File? ownerBackAdhaar,
    required final File? ownerFrontPan,
    required final File? ownerBackPan,
    required final File? ownerPhoto,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.postWithFile,
      apiUrl: submitOwnerDetailsUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
        'owner_name': ownerName,
        'owner_dial_code': '91',
        'owner_mobile': ownerPhoneNumber,
      },
      filesWithFieldNames: {
        // 'owner_aadhar_front': ownerFrontAdhaar,
        'aadhar_card': ownerFrontAdhaar,
        // 'owner_aadhar_back': ownerFrontAdhaar,
        'aadhar_card_back': ownerBackAdhaar,
        // 'owner_pan_front': ownerFrontPan,
        'pan_card': ownerFrontPan,
        // 'owner_pan_back': ownerBackAdhaar,
        'pan_card_back': ownerBackAdhaar,
        // 'owner_photo': ownerPhoto,
        'owner_profile_photo': ownerPhoto,
      },
    );

    return responseData;
  }

  Future<Map<String, dynamic>?> submitVehicleDetails({
    required final String lang,
    required final String accessToken,
    required final String? vehicleNo,
    required final String? vehicleRC,
    required final String? vehicleTypeId,
    required final File? vehicleFrontRC,
    required final File? vehicleBackRC,
    required final File? vehiclePhoto,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.postWithFile,
      apiUrl: submitVehicleDetailsUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
        'vehicle_type_id': vehicleTypeId,
        'vehicle_no': vehicleNo,
        'vehicle_registration': vehicleRC,
      },
      filesWithFieldNames: {
        'vehicle_rc': vehicleFrontRC,
        'vehicle_rc_back': vehicleBackRC,
        'vehicle_photo': vehiclePhoto,
      },
    );

    return responseData;
  }

  Future<Map<String, dynamic>?> submitDriverDetails({
    required final String lang,
    required final String accessToken,
    required final String? driverName,
    required final String? driverPhoneNumber,
    required final String? driverLicenceNumber,
    required final File? driverFrontAdhaar,
    required final File? driverBackAdhaar,
    required final File? driverFrontPan,
    required final File? driverBackPan,
    required final File? driverFrontLicence,
    required final File? driverBackLicence,
    required final File? driverPhoto,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.postWithFile,
      apiUrl: submitDriverDetailsUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
        'driver_name': driverName,
        'driver_dial_code': '91',
        'driver_mobile': driverPhoneNumber,
        'driver_license_number': driverLicenceNumber,
      },
      filesWithFieldNames: {
        'driver_aadhar_card': driverFrontAdhaar,
        // 'driver_aadhar_back': driverBackAdhaar,
        'driver_aadhar_card_back': driverBackAdhaar,
        // 'driver_pan_front': driverFrontPan,
        'driver_pan_card': driverFrontPan,
        // 'driver_pan_back': driverBackAdhaar,
        'driver_pan_card_back': driverBackAdhaar,
        'driver_license': driverFrontLicence,
        'driver_license_back': driverBackLicence,
        'driver_profile_image': driverPhoto,
      },
    );

    return responseData;
  }
}
