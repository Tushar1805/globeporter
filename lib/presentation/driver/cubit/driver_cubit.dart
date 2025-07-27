import 'dart:io';

import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/presentation/driver/repository/driver_repository.dart';
import 'package:globeporter/presentation/driver/states/driver_states.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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
  }) async {
    this.ownerName = ownerName;
    this.ownerPhoneNumber = ownerPhoneNumber;
    this.ownerFrontAdhaar = ownerFrontAdhaar;
    this.ownerBackAdhaar = ownerBackAdhaar;
    this.ownerFrontPan = ownerFrontPan;
    this.ownerBackPan = ownerBackPan;
    this.ownerPhoto = ownerPhoto;

    await storage.saveValue(value: ownerName, key: ownerNameKey);
    await storage.saveValue(value: ownerPhoneNumber, key: ownerPhoneKey);
    await storage.saveValue(value: ownerFrontAdhaar.path, key: ownerAadharCardFrontKey);
    await storage.saveValue(value: ownerBackAdhaar.path, key: ownerAadharCardBackKey);
    await storage.saveValue(value: ownerFrontPan.path, key: ownerPanCardFrontKey);
    await storage.saveValue(value: ownerBackPan.path, key: ownerPanCardBackKey);
    await storage.saveValue(value: ownerPhoto.path, key: ownerPhotoKey);

    ownerDetailsFilled = true;

    emit(DetailsUpdatedState('Owner Details Updated'));
  }

  Future<void> getOwnerDetailsData() async {
    final frontAadhar = await storage.readValue(ownerAadharCardFrontKey);
    final backAadhar = await storage.readValue(ownerAadharCardBackKey);
    final frontPan = await storage.readValue(ownerPanCardFrontKey);
    final backPan = await storage.readValue(ownerPanCardBackKey);
    final photoPath = await storage.readValue(ownerPhotoKey);

    ownerName = await storage.readValue(ownerNameKey);
    ownerPhoneNumber = await storage.readValue(ownerPhoneKey);
    ownerFrontAdhaar = frontAadhar != null ? File(frontAadhar) : null;
    ownerBackAdhaar = backAadhar != null ? File(backAadhar) : null;
    ownerFrontPan = frontPan != null ? File(frontPan) : null;
    ownerBackPan = backPan != null ? File(backPan) : null;
    ownerPhoto = photoPath != null ? File(photoPath) : null;
    if (ownerName != null && ownerName != '') {
      ownerDetailsFilled = true;
    }
    emit(DetailsUpdatedState('Owner Details Updated'));
  }

  void saveVehicleDetails({
    required final String vehicleNo,
    required final String vehicleRC,
    required final String vehicleTypeId,
    required final File vehicleFrontRC,
    required final File vehicleBackRC,
    required final File vehiclePhoto,
  }) async {
    this.vehicleNo = vehicleNo;
    this.vehicleRC = vehicleRC;
    this.vehicleTypeId = vehicleTypeId;
    this.vehicleFrontRC = vehicleFrontRC;
    this.vehicleBackRC = vehicleBackRC;
    this.vehiclePhoto = vehiclePhoto;

    await storage.saveValue(value: vehicleNo, key: vehicleNumberKey);
    await storage.saveValue(value: vehicleRC, key: vehicleRCNumberKey);
    await storage.saveValue(value: vehicleTypeId, key: vehicleTypeKey);
    await storage.saveValue(value: vehicleFrontRC.path, key: vehicleRCFrontKey);
    await storage.saveValue(value: vehicleBackRC.path, key: vehicleRCBackKey);
    await storage.saveValue(value: vehiclePhoto.path, key: vehiclePhotoKey);

    vehicleDetailsFilled = true;

    emit(DetailsUpdatedState('Vehicle Details Updated'));
  }

  Future<void> getVehicleDetailsData() async {
    final frontRCPath = await storage.readValue(vehicleRCFrontKey);
    final backRCPath = await storage.readValue(vehicleRCBackKey);
    final photoPath = await storage.readValue(vehiclePhotoKey);

    vehicleNo = await storage.readValue(vehicleNumberKey);
    vehicleRC = await storage.readValue(vehicleRCNumberKey);
    vehicleTypeId = await storage.readValue(vehicleTypeKey);
    vehicleFrontRC = frontRCPath != null ? File(frontRCPath) : null;
    vehicleBackRC = backRCPath != null ? File(backRCPath) : null;
    vehiclePhoto = photoPath != null ? File(photoPath) : null;
    if (vehicleNo != null && vehicleNo != '') {
      vehicleDetailsFilled = true;
    }
    emit(DetailsUpdatedState('Owner Details Updated'));
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
  }) async {
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

    await storage.saveValue(value: driverName, key: driverNameKey);
    await storage.saveValue(value: driverPhoneNumber, key: driverPhoneKey);
    await storage.saveValue(value: driverLicenceNumber, key: driverLicenceKey);
    await storage.saveValue(value: driverFrontAdhaar.path, key: driverAadharCardFrontKey);
    await storage.saveValue(value: driverBackAdhaar.path, key: driverAadharCardBackKey);
    await storage.saveValue(value: driverFrontPan.path, key: driverPanCardFrontKey);
    await storage.saveValue(value: driverBackPan.path, key: driverPanCardBackKey);
    await storage.saveValue(value: driverFrontLicence.path, key: driverLicenceFrontKey);
    await storage.saveValue(value: driverBackLicence.path, key: driverLicenceBackKey);
    await storage.saveValue(value: driverPhoto.path, key: driverPhotoKey);

    driverDetailsFilled = true;

    emit(DetailsUpdatedState('Driver Details Updated'));
  }

  Future<void> getDriverDetailsData() async {
    final frontAadhar = await storage.readValue(driverAadharCardFrontKey);
    final backAadhar = await storage.readValue(driverAadharCardBackKey);
    final frontPan = await storage.readValue(driverPanCardFrontKey);
    final backPan = await storage.readValue(driverPanCardBackKey);
    final frontLicence = await storage.readValue(driverLicenceFrontKey);
    final backLicence = await storage.readValue(driverLicenceBackKey);
    final photoPath = await storage.readValue(driverPhotoKey);

    driverName = await storage.readValue(driverNameKey);
    driverPhoneNumber = await storage.readValue(driverPhoneKey);
    driverLicenceNumber = await storage.readValue(driverLicenceKey);
    driverFrontAdhaar = frontAadhar != null ? File(frontAadhar) : null;
    driverBackAdhaar = backAadhar != null ? File(backAadhar) : null;
    driverFrontPan = frontPan != null ? File(frontPan) : null;
    driverBackPan = backPan != null ? File(backPan) : null;
    driverFrontLicence = frontLicence != null ? File(frontLicence) : null;
    driverBackLicence = backLicence != null ? File(backLicence) : null;
    driverPhoto = photoPath != null ? File(photoPath) : null;
    if (driverName != null && driverName != '') {
      driverDetailsFilled = true;
    }
    emit(DetailsUpdatedState('Owner Details Updated'));
  }

  Future<void> getAllData() async {
    emit(LoadAllDataLoadingState('loading'));

    // final ownerDetailsFilled = await storage.readValue(ownerDetailsFilledKey);
    // final vehiclDetailsFilled = await storage.readValue(vehicleDetailsFilledKey);

    // if (ownerDetailsFilled == '1' && vehiclDetailsFilled == '1') {
    //   ownerName = await storage.readValue(ownerNameKey);
    //   vehicleNo = await storage.readValue(vehicleNumberKey);
    //   if (ownerName == null || ownerName == '') {
    //     await getOwnerDetails();
    //   } else {
    //     await getOwnerDetailsData();
    //   }

    //   if (vehicleNo == null || vehicleNo == '') {
    //     await getVehicleDetails();
    //   } else {
    //     await getVehicleDetailsData();
    //   }
    // } else if (ownerDetailsFilled == '1') {
    //   ownerName = await storage.readValue(ownerNameKey);
    //   if (ownerName == null || ownerName == '') {
    //     await getOwnerDetails();
    //   } else {
    //     await getOwnerDetailsData();
    //   }
    // }
    await getOwnerDetailsData();
    await getVehicleDetailsData();
    await getDriverDetailsData();
    emit(LoadAllDataLoadedState(data: null));
  }

  Future<File> urlToFile(String imageUrl) async {
    final Directory tempDir = await getTemporaryDirectory();

    final String fileName = basename(imageUrl);
    final File file = File('${tempDir.path}/$fileName');

    final http.Response response = await http.get(Uri.parse(imageUrl));

    await file.writeAsBytes(response.bodyBytes);

    return file;
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

  Future<void> getOwnerDetails() async {
    try {
      emit(GetOwnerDetailsLoadingState('Loading vehicle types'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.getOwnerDetails(
        lang: lang ?? 'en',
        token: accessToken ?? '',
      );

      final data = response?.data;

      saveOwnerDetails(
        ownerName: data?.ownerName ?? '',
        ownerPhoneNumber: data?.ownerMobile ?? '',
        ownerFrontAdhaar: await urlToFile(data?.aadharCardUrl ?? ''),
        ownerBackAdhaar: await urlToFile(data?.aadharCardBackUrl ?? ''),
        ownerFrontPan: await urlToFile(data?.panCardUrl ?? ''),
        ownerBackPan: await urlToFile(data?.panCardBackUrl ?? ''),
        ownerPhoto: ownerPhoto ?? File(''),
      );

      emit(GetOwnerDetailsLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getVehicleDetails() async {
    try {
      emit(GetVehicleDetailsLoadingState('Loading vehicle types'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.getVehicleDetails(
        lang: lang ?? 'en',
        token: accessToken ?? '',
      );

      final data = response?.data;

      saveVehicleDetails(
        vehicleNo: data?.vehicleNo ?? '',
        vehicleRC: data?.vehicleRc ?? '',
        vehicleTypeId: data?.vehicleTypeId.toString() ?? '1',
        vehicleFrontRC: await urlToFile(data?.vehicleRcUrl ?? ''),
        vehicleBackRC: await urlToFile(data?.vehicleRcBackUrl ?? ''),
        vehiclePhoto: await urlToFile(data?.vehiclePhotoUrl ?? ''),
      );

      emit(GetVehicleDetailsLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getDriverDetails() async {
    try {
      emit(GetDriverDetailsLoadingState('Loading vehicle types'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.getDriverDetails(
        lang: lang ?? 'en',
        token: accessToken ?? '',
      );

      final data = response?.data;

      saveDriverDetails(
        driverName: data?.driverName ?? '',
        driverPhoneNumber: data?.driverMobile ?? '',
        driverLicenceNumber: data?.driverLicenseNumber ?? '',
        driverFrontAdhaar: await urlToFile(data?.driverAadharCardUrl ?? ''),
        driverBackAdhaar: await urlToFile(data?.driverAadharCardBackUrl ?? ''),
        driverFrontPan: await urlToFile(data?.driverPanCardUrl ?? ''),
        driverBackPan: await urlToFile(data?.driverPanCardBackUrl ?? ''),
        driverFrontLicence: await urlToFile(data?.driverLicenseUrl ?? ''),
        driverBackLicence: await urlToFile(data?.driverLicenseBackUrl ?? ''),
        driverPhoto: driverPhoto ?? File(''),
      );

      emit(GetDriverDetailsLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getVerificationStatus() async {
    try {
      emit(VerificationStatusLoadingState('Getting status'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.getVerificationStatus(
        lang: lang ?? 'en',
        token: accessToken ?? '',
      );

      customPrint("Response of status: ${response?.data.toString()}");

      emit(VerificationStatusLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> submitOwnerDetails() async {
    try {
      emit(SaveOwnerDetailsLoadingState('Submitting details'));
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
        await storage.saveValue(value: '1', key: ownerDetailsFilledKey);
        emit(SaveOwnerDetailsLoadedState(data: response));
      } else {
        emit(ErrorState('Details not submitted'));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> submitVehicleDetails() async {
    try {
      emit(SaveVehicleDetailsLoadingState('Submitting details'));
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
        await storage.saveValue(value: '1', key: vehicleDetailsFilledKey);
        emit(SaveVehicleDetailsLoadedState(data: response));
      } else {
        emit(ErrorState('Details not submitted'));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> submitDriverDetails() async {
    try {
      emit(SaveDriverDetailsLoadingState('Submitting details'));
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
        await storage.saveValue(value: '1', key: driverDetailsFilledKey);
        emit(SaveDriverDetailsLoadedState(data: response));
      } else {
        emit(ErrorState('Details not submitted'));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> reSubmitDocuments({
    required final File? driverFrontAdhaar,
    required final File? driverBackAdhaar,
    required final File? driverFrontPan,
    required final File? driverBackPan,
    required final File? driverFrontLicence,
    required final File? driverBackLicence,
    required final File? driverPhoto,
    required final File? vehicleFrontRC,
    required final File? vehicleBackRC,
    required final File? vehiclePhoto,
    required final File? ownerFrontAdhaar,
    required final File? ownerBackAdhaar,
    required final File? ownerFrontPan,
    required final File? ownerBackPan,
    required final File? ownerPhoto,
  }) async {
    try {
      emit(ReSubmitDocumentsLoadingState('Submitting details'));
      final accessToken = await storage.readValue(accessTokenKey);
      final lang = await storage.readValue(languageCodeKey);

      final response = await _driverRepository.reSubmitDocuments(
        token: accessToken ?? '',
        lang: lang ?? 'en',
        driverFrontAdhaar: driverFrontAdhaar,
        driverBackAdhaar: driverBackAdhaar,
        driverFrontPan: driverFrontPan,
        driverBackPan: driverBackPan,
        driverFrontLicence: driverFrontLicence,
        driverBackLicence: driverBackLicence,
        driverPhoto: driverPhoto,
        vehicleTypeId: '',
        vehicleFrontRC: vehicleFrontRC,
        vehicleBackRC: vehicleBackRC,
        vehiclePhoto: vehiclePhoto,
        ownerFrontAdhaar: ownerFrontAdhaar,
        ownerBackAdhaar: ownerBackAdhaar,
        ownerFrontPan: ownerFrontPan,
        ownerBackPan: ownerBackPan,
        ownerPhoto: ownerPhoto,
      );
      customPrint(response.toString());

      if (response?['status_code'] == 200) {
        await storage.saveValue(value: '1', key: driverDetailsFilledKey);
        emit(ReSubmitDocumentsLoadedState(data: response));
      } else {
        emit(ErrorState('Details not submitted'));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }
}
