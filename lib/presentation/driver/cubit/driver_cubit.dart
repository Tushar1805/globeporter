import 'dart:io';

import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/presentation/driver/repository/driver_repository.dart';
import 'package:globeporter/presentation/driver/states/driver_states.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';

class DriverCubit extends BaseCubit {
  final DriverRepository _driverRepository;
  DriverCubit(this._driverRepository);
  final storage = sl<SecureStorage>();

  int amount = 500;

  void deductAmount() {
    amount = amount - 100;
    emit(AmountDeductedState(amount.toString()));
  }

  // Owner Fields
  String? ownerName;
  String? ownerPhoneNumber;
  File? ownerFrontAdhaar;
  File? ownerBackAdhaar;
  File? ownerFrontPan;
  File? ownerBackPan;
  File? ownerPhoto;
  bool ownerDetailsFilled = false;

  // Vehicle Fields
  String? vehicleNo;
  String? vehicleRC;
  String? vehicleTypeId;
  File? vehicleFrontRC;
  File? vehicleBackRC;
  File? vehiclePhoto;
  bool vehicleDetailsFilled = false;

  // Driver Fields
  String? driverName;
  String? driverPhoneNumber;
  String? driverLicenceNumber;
  File? driverFrontAdhaar;
  File? driverBackAdhaar;
  File? driverFrontPan;
  File? driverBackPan;
  File? driverFrontLicence;
  File? driverBackLicence;
  File? driverPhoto;
  bool driverDetailsFilled = false;

  void saveOwnerDetails({
    required final String ownerName,
    required final String ownerPhoneNumber,
    required final File ownerFrontAdhaar,
    required final File ownerBackAdhaar,
    required final File ownerFrontPan,
    required final File ownerBackPan,
    required final File ownerPhoto,
  }) {
    this.ownerName = ownerName;
    this.ownerPhoneNumber = ownerPhoneNumber;
    this.ownerFrontAdhaar = ownerFrontAdhaar;
    this.ownerBackAdhaar = ownerBackAdhaar;
    this.ownerFrontPan = ownerFrontPan;
    this.ownerBackPan = ownerBackPan;
    this.ownerPhoto = ownerPhoto;

    ownerDetailsFilled = true;

    emit(DetailsUpdatedState('Owner Details Updated'));
  }

  void saveVehicleDetails({
    required final String vehicleNo,
    required final String vehicleRC,
    required final String vehicleTypeId,
    required final File vehicleFrontRC,
    required final File vehicleBackRC,
    required final File vehiclePhoto,
  }) {
    this.vehicleNo = vehicleNo;
    this.vehicleRC = vehicleRC;
    this.vehicleTypeId = vehicleTypeId;
    this.vehicleFrontRC = vehicleFrontRC;
    this.vehicleBackRC = vehicleBackRC;
    this.vehiclePhoto = vehiclePhoto;

    vehicleDetailsFilled = true;

    emit(DetailsUpdatedState('Vehicle Details Updated'));
  }

  void saveDriverDetails({
    required final String driverName,
    required final String driverPhoneNumber,
    required final String driverLicenceNumber,
    required final File driverFrontAdhaar,
    required final File driverBackAdhaar,
    required final File driverFrontPan,
    required final File driverBackPan,
    required final File driverFrontLicence,
    required final File driverBackLicence,
    required final File driverPhoto,
  }) {
    this.driverName = driverName;
    this.driverPhoneNumber = driverPhoneNumber;
    this.driverLicenceNumber = driverLicenceNumber;
    this.driverFrontAdhaar = driverFrontAdhaar;
    this.driverBackAdhaar = driverBackAdhaar;
    this.driverFrontPan = driverFrontPan;
    this.driverBackPan = driverBackPan;
    this.driverFrontLicence = driverFrontLicence;
    this.driverBackLicence = driverBackLicence;
    this.driverPhoto = driverPhoto;

    driverDetailsFilled = true;

    emit(DetailsUpdatedState('Driver Details Updated'));
  }

  Future<void> getVehicleType() async {
    try {
      emit(VehicleTypeLoadingState('Loading vehicle types'));
      final lang = await storage.readValue(languageCodeKey);
      final response = await _driverRepository.getVehicleType(lang: lang ?? 'en');

      emit(VehicleTypeLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> submitOwnerDetails() async {
    try {
      emit(OwnerDetailsLoadingState('Submitting details'));
      final accessToken = await storage.readValue(accessTokenKey);
      final lang = await storage.readValue(languageCodeKey);

      final response = await _driverRepository.submitOwnerDetails(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        ownerName: ownerName,
        ownerPhoneNumber: ownerPhoneNumber,
        ownerFrontAdhaar: ownerFrontAdhaar,
        ownerBackAdhaar: ownerBackAdhaar,
        ownerFrontPan: ownerFrontPan,
        ownerBackPan: ownerBackPan,
        ownerPhoto: ownerPhoto,
      );
      customPrint(response.toString());

      if (response?['status_code'] == 200) {
        customPrint("Emitting owner details loaded state");
        emit(OwnerDetailsLoadedState(data: response));
      } else {
        emit(ErrorState('Details not submitted'));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> submitVehicleDetails() async {
    try {
      emit(VehicleDetailsLoadingState('Submitting details'));
      final accessToken = await storage.readValue(accessTokenKey);
      final lang = await storage.readValue(languageCodeKey);

      final response = await _driverRepository.submitVehicleDetails(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        vehicleNo: vehicleNo,
        vehicleRC: vehicleRC,
        vehicleTypeId: vehicleTypeId,
        vehicleFrontRC: vehicleFrontRC,
        vehicleBackRC: vehicleBackRC,
        vehiclePhoto: vehiclePhoto,
      );

      customPrint(response.toString());

      if (response?['status_code'] == 200) {
        emit(VehicleDetailsLoadedState(data: response));
      } else {
        emit(ErrorState('Details not submitted'));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> submitDriverDetails() async {
    try {
      emit(DriverDetailsLoadingState('Submitting details'));
      final accessToken = await storage.readValue(accessTokenKey);
      final lang = await storage.readValue(languageCodeKey);

      final response = await _driverRepository.submitDriverDetails(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        driverName: driverName,
        driverPhoneNumber: driverPhoneNumber,
        driverLicenceNumber: driverLicenceNumber,
        driverFrontAdhaar: driverFrontAdhaar,
        driverBackAdhaar: driverBackAdhaar,
        driverFrontPan: driverFrontPan,
        driverBackPan: driverBackPan,
        driverFrontLicence: driverFrontLicence,
        driverBackLicence: driverBackLicence,
        driverPhoto: driverPhoto,
      );
      customPrint(response.toString());

      if (response?['status_code'] == 200) {
        emit(DriverDetailsLoadedState(data: response));
      } else {
        emit(ErrorState('Details not submitted'));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }
}
