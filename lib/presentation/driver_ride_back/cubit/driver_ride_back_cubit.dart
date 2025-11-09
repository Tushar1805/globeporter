import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/presentation/driver_ride_back/repo/driver_ride_back_repo.dart';
import 'package:globeporter/presentation/driver_ride_back/states/driver_ride_back_state.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';

class DriverRideBackCubit extends BaseCubit {
  final DriverRideBackRepository _driverRideBackRepository;
  DriverRideBackCubit(this._driverRideBackRepository);
  final storage = sl<SecureStorage>();

  Future<void> placeDriverBookingRide({
    required final int vehicleTypeId,
    required final String pickupAddress,
    required final String dropAddress,
    required final String pickupLat,
    required final String pickupLng,
    required final String dropLat,
    required final String dropLng,
    required final String price,
    required final String moveDate, // "2025-10-04"
    required final String moveTime, // "10:00:00"
  }) async {
    try {
      emit(PlaceDriverRideLoadingState('Placing Request...'));
      final lang = await storage.readValue(languageCodeKey);
      final token = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.placeDriverBookingRide(
        lang: lang ?? 'en',
        token: token ?? '',
        vehicleTypeId: vehicleTypeId,
        pickupAddress: pickupAddress,
        dropAddress: dropAddress,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,
        price: price,
        moveDate: moveDate,
        moveTime: moveTime,
      );

      customPrint('Data: ${response.toString()}');
      if (response['status_code'] == 200) {
        getDriverPostedRides();
        findCustomer(bookingId: response['booking_id'].toString(), distance: "10");
      }

      emit(PlaceDriverRideLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getVehicleTypes() async {
    try {
      emit(VehicleTypesLoadingState('Loading Vehicle types'));
      final lang = await storage.readValue(languageCodeKey);
      final response = await _driverRideBackRepository.getVehicleType(lang: lang ?? 'en');

      emit(VehicleTypesLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getDriverPostedRides() async {
    try {
      emit(MyPostedRidesLoadingState('Loading Posted Rides...'));
      final lang = await storage.readValue(languageCodeKey);
      final token = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.getDriverPostedRides(
        lang: lang ?? 'en',
        token: token ?? '',
      );

      emit(MyPostedRidesLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getCustomerPostedRides({
    required final String currentLat,
    required final String currentLng,
    required final String radius,
    final String? dropLat,
    final String? dropLng,
    final String? price,
    final String? orderByColumn,
    final String? orderByType,
  }) async {
    try {
      emit(CustomerPostedRidesLoadingState('Loading posted rides list for customer...'));
      final lang = await storage.readValue(languageCodeKey);
      final token = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.getCustomerPostedRides(
        lang: lang ?? 'en',
        token: token ?? '',
        radius: radius,
        currentLat: currentLat,
        currentLng: currentLng,
        dropLat: dropLat,
        dropLng: dropLng,
        price: price,
        orderByColumn: orderByColumn,
        orderByType: orderByType,
      );

      emit(CustomerPostedRidesLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> customerAcceptRejectRide({
    required final String bookingId,
    required final String status, // Accept or Reject
  }) async {
    try {
      emit(CustomerAcceptRejectLoadingState('Loading Posted Rides...'));
      final lang = await storage.readValue(languageCodeKey);
      final token = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.customerAccepRejectRide(
        lang: lang ?? 'en',
        token: token ?? '',
        bookingId: bookingId,
        status: status,
      );

      emit(CustomerAcceptRejectLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> customerCancelRide({
    required final String bookingId,
    required final String bookingCancellationId,
  }) async {
    try {
      emit(CustomerCancelRideLoadingState('Loading Posted Rides...'));
      final lang = await storage.readValue(languageCodeKey);
      final token = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.customerCancelRide(
        lang: lang ?? 'en',
        token: token ?? '',
        bookingId: bookingId,
        bookingCancellationId: bookingCancellationId,
      );

      emit(CustomerCancelRideLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> driverCancelRide({
    required final String bookingId,
    required final String bookingCancellationId,
  }) async {
    try {
      emit(DriverCancelRideLoadingState('Loading Posted Rides...'));
      final lang = await storage.readValue(languageCodeKey);
      final token = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.driverCancelRide(
        lang: lang ?? 'en',
        token: token ?? '',
        bookingId: bookingId,
        bookingCancellationId: bookingCancellationId,
      );

      emit(DriverCancelRideLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getCancellationReasons({required final String userType}) async {
    try {
      emit(RideCancellationReasonsLoadingState('Loading Cancellation Reasons'));
      final lang = await storage.readValue(languageCodeKey);
      final response = await _driverRideBackRepository.getRideCancellationReasons(
        lang: lang ?? 'en',
        userType: userType,
      );

      emit(RideCancellationReasonsLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> driverAcceptRejectRide({
    required final String bookingId,
    required final String userId,
    required final String status, // Accept or Reject
  }) async {
    try {
      emit(DriverAcceptRejectLoadingState('Loading Posted Rides...'));
      final lang = await storage.readValue(languageCodeKey);
      final token = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.driverAccepRejectRide(
        lang: lang ?? 'en',
        token: token ?? '',
        bookingId: bookingId,
        userId: userId,
        status: status,
      );
      customPrint("Response: ${response.toString()}");

      emit(DriverAcceptRejectLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> findCustomer(
      {required final String bookingId, required final String distance}) async {
    try {
      emit(FindingCustomerLoadingState('Finding customers for Posted Rides...'));
      final lang = await storage.readValue(languageCodeKey);
      final token = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.findCustomer(
        lang: lang ?? 'en',
        token: token ?? '',
        bookingId: bookingId,
        distance: distance,
      );

      emit(FindingCustomerLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> generatePostedRideOtp({
    required final int bookingId,
  }) async {
    try {
      emit(GenerateOTPLoadingState('Loading'));
      final dbRef = FirebaseDatabase.instance.ref("ride_otp/$bookingId");
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.generatePostedRideOtp(
        lang: lang ?? 'en',
        token: accessToken ?? '',
        bookingId: bookingId,
      );

      if (response['status_code'] == 200) {
        await dbRef.update({
          "otp": response['otp'],
        });
      }

      emit(GenerateOTPLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> verifyStartRideOtpByDriver({
    required final int bookingId,
    required final String otp,
  }) async {
    try {
      emit(VerifyStartRideOTPLoadingState('Loading'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.verifyOtpPostedRideByDriver(
        lang: lang ?? 'en',
        token: accessToken ?? '',
        bookingId: bookingId,
        otp: otp,
      );

      if (response['status_code'] == 200) {
        emit(VerifyStartRideOTPLoadedState(data: response));
      } else {
        emit(RideOTPNotMatchState('OTP not match'));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> verifyEndRideOtpByDriver({
    required final int bookingId,
    required final String otp,
  }) async {
    try {
      emit(VerifyEndRideOTPLoadingState('Loading'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.verifyOtpPostedRideByDriver(
        lang: lang ?? 'en',
        token: accessToken ?? '',
        bookingId: bookingId,
        otp: otp,
      );

      customPrint("End ride verify otp: ${response.toString()}");

      if (response['status_code'] == 200) {
        emit(VerifyEndRideOTPLoadedState(data: response));
      } else {
        emit(RideOTPNotMatchState('OTP not match'));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> endRideByDriver({
    required final int bookingId,
  }) async {
    try {
      emit(EndRideLoadingState('Loading'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.endRideByDriver(
        lang: lang ?? 'en',
        token: accessToken ?? '',
        bookingId: bookingId,
      );

      emit(EndRideLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }
}
