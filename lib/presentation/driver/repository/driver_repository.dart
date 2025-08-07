import 'dart:io';

import 'package:datasource/base_repository.dart';
import 'package:datasource/network/api_call_type.dart';
import 'package:globeporter/presentation/authentication/model/vehicle_type_response_model.dart';
import 'package:globeporter/presentation/driver/model/driver_details_response_model.dart';
import 'package:globeporter/presentation/driver/model/owner_details_response_model.dart';
import 'package:globeporter/presentation/driver/model/pending_bookings_response.dart';
import 'package:globeporter/presentation/driver/model/ride_cancellation_reason_response.dart';
import 'package:globeporter/presentation/driver/model/vehicle_details_response_model.dart';
import 'package:globeporter/presentation/driver/model/verification_status_response.dart';
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

  Future<Map<String, dynamic>> declineRideByDriver({
    required final String lang,
    required final String accessToken,
    required final int bookingId,
    required final int reasonId,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: declineRideByDriverUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
        "booking_id": bookingId,
        "booking_cancellation_reason_id": reasonId,
      },
    );

    return responseData;
  }

  Future<Map<String, dynamic>> cancelRideByDriver({
    required final String lang,
    required final String accessToken,
    required final int bookingId,
    required final int reasonId,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: cancelRideDriverUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
        "booking_id": bookingId,
        "booking_cancellation_reason_id": reasonId,
      },
    );

    return responseData;
  }

  Future<Map<String, dynamic>> checkCancelRideByDriver({
    required final String lang,
    required final String accessToken,
    required final int reasonId,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: checkCancelRideDriverUrl,
      accessToken: accessToken,
      requestModel: {
        'lang': lang,
        "booking_cancellation_reason_id": reasonId,
      },
    );

    return responseData;
  }

  Future<OwnerDetailsResponseModel?> getOwnerDetails({
    required final String lang,
    required final String token,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getOwnerDetailsUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
      },
    );

    return OwnerDetailsResponseModel.fromJson(
      responseData as Map<String, dynamic>,
    );
  }

  Future<VehicleDetailsResponseModel?> getVehicleDetails({
    required final String lang,
    required final String token,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getVehicleDetailsUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
      },
    );

    return VehicleDetailsResponseModel.fromJson(
      responseData as Map<String, dynamic>,
    );
  }

  Future<DriverDetailsResponseModel?> getDriverDetails({
    required final String lang,
    required final String token,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getDriverDetailsUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
      },
    );

    return DriverDetailsResponseModel.fromJson(
      responseData as Map<String, dynamic>,
    );
  }

  Future<VerificationStatusResponse?> getVerificationStatus({
    required final String lang,
    required final String token,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getVerificationStatusUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
      },
    );

    return VerificationStatusResponse.fromJson(
      responseData as Map<String, dynamic>,
    );
  }

  Future<PendingBookingsResponse?> getDriverBookings({
    required final String lang,
    required final String token,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getDriverBookingsUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
      },
    );

    return PendingBookingsResponse.fromJson(
      responseData as Map<String, dynamic>,
    );
  }

  //* Get Pending Bookings
  Future<PendingBookingsResponse?> getPendingBookings({
    required final String lang,
    required final String token,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: getPendingBookingsUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
      },
    );

    return PendingBookingsResponse.fromJson(
      responseData as Map<String, dynamic>,
    );
  }

  //* Change Ride Status
  Future<Map<String, dynamic>> changeRideStatus({
    required final String lang,
    required final String token,
    required final int bookingId,
    required final String status,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: changeRideStatusUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
        'booking_id': bookingId,
        'status': status,
      },
    );

    return responseData;
  }


  //* Accept or Reject rides
  Future<Map<String, dynamic>> acceptOrRejectRide({
    required final String lang,
    required final String token,
    required final int bookingId,
    required final String status,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.post,
      apiUrl: acceptRejectRideUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
        'booking_id': bookingId,
        'status': status,
      },
    );

    return responseData;
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

  Future<Map<String, dynamic>?> reSubmitDocuments({
    required final String? token,
    required final String? lang,
    required final File? driverFrontAdhaar,
    required final File? driverBackAdhaar,
    required final File? driverFrontPan,
    required final File? driverBackPan,
    required final File? driverFrontLicence,
    required final File? driverBackLicence,
    required final File? driverPhoto,
    required final String? vehicleTypeId,
    required final File? vehicleFrontRC,
    required final File? vehicleBackRC,
    required final File? vehiclePhoto,
    required final File? ownerFrontAdhaar,
    required final File? ownerBackAdhaar,
    required final File? ownerFrontPan,
    required final File? ownerBackPan,
    required final File? ownerPhoto,
  }) async {
    final responseData = await fetchData(
      apiCallType: ApiCallType.postWithFile,
      apiUrl: submitDriverDetailsUrl,
      accessToken: token,
      requestModel: {
        'lang': lang,
      },
      filesWithFieldNames: {
        'driver_aadhar_card': driverFrontAdhaar,
        'driver_aadhar_card_back': driverBackAdhaar,
        'driver_pan_card': driverFrontPan,
        'driver_pan_card_back': driverBackAdhaar,
        'driver_license': driverFrontLicence,
        'driver_license_back': driverBackLicence,
        'driver_profile_image': driverPhoto,
        'vehicle_rc': vehicleFrontRC,
        'vehicle_rc_back': vehicleBackRC,
        'vehicle_photo': vehiclePhoto,
        'aadhar_card': ownerFrontAdhaar,
        'aadhar_card_back': ownerBackAdhaar,
        'pan_card': ownerFrontPan,
        'pan_card_back': ownerBackAdhaar,
        'owner_profile_photo': ownerPhoto,
      },
    );

    return responseData;
  }
}
