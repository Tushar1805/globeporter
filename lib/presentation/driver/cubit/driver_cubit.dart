import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/presentation/driver/repository/driver_repository.dart';
import 'package:globeporter/presentation/driver/states/driver_booking_states.dart';
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

  Future<void> getCancellationReasons({required final String userType}) async {
    try {
      emit(RideCancellationReasonsLoadingState('Loading Cancellation Reasons'));
      final lang = await storage.readValue(languageCodeKey);
      final response = await _driverRepository.getRideCancellationReasons(
        lang: lang ?? 'en',
        userType: userType,
      );

      emit(RideCancellationReasonsLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> declineRideByDriver({
    required final int bookingId,
    required final int reasonId,
  }) async {
    try {
      emit(DeclineRideByDriverLoadingState('Cancelling Ride'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.declineRideByDriver(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        bookingId: bookingId,
        reasonId: reasonId,
      );

      emit(DeclineRideByDriverLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> cancelRideByDriver({
    required final int bookingId,
    required final int reasonId,
  }) async {
    try {
      emit(CancleRideByDriverLoadingState('Cancelling Ride'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.cancelRideByDriver(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        bookingId: bookingId,
        reasonId: reasonId,
      );

      emit(CancleRideByDriverLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> checkCancelRideByDriver({
    required final int bookingId,
    required final int reasonId,
  }) async {
    try {
      emit(CheckCancleRideByDriverLoadingState('Checking Ride Cancelling Reason'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.checkCancelRideByDriver(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        reasonId: reasonId,
      );

      emit(CheckCancleRideByDriverLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getDriverBookings() async {
    try {
      emit(DriverBookingsLoadingState('Loading driving bookings'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.getDriverBookings(
        lang: lang ?? 'en',
        token: accessToken ?? '',
      );

      emit(DriverBookingsLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  //* Get Pending Bookings

  Future<void> getPendingBookings() async {
    try {
      emit(PendingBookingsLoadingState('Loading pending bookings'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.getPendingBookings(
        lang: lang ?? 'en',
        token: accessToken ?? '',
      );

      emit(PendingBookingsLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  //* change ride status
  Future<void> changeRideStatus({
    required final int bookingId,
    required final String status,
  }) async {
    try {
      emit(ChangeRideStatusLoadingState('Changin ride status'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.changeRideStatus(
        lang: lang ?? 'en',
        token: accessToken ?? '',
        bookingId: bookingId,
        status: status,
      );

      customPrint(response.toString());

      emit(ChangeRideStatusLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  //* Accept  the ride

  Future<void> acceptRide({
    required final int bookingId,
    required final String status,
  }) async {
    try {
      emit(AcceptRideLoadingState('Loading'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.acceptOrRejectRide(
        lang: lang ?? 'en',
        token: accessToken ?? '',
        bookingId: bookingId,
        status: status,
      );
      customPrint('Accept Response: ${response.toString()}');

      emit(AcceptRideLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  //* Reject the ride

  Future<void> rejectRide({
    required final int bookingId,
    required final String status,
  }) async {
    try {
      emit(RejectRideLoadingState('Loading'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.acceptOrRejectRide(
        lang: lang ?? 'en',
        token: accessToken ?? '',
        bookingId: bookingId,
        status: status,
      );

      emit(RejectRideLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> generateOtp({
    required final int bookingId,
  }) async {
    try {
      emit(GenerateOTPLoadingState('Loading'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.generateOtp(
        lang: lang ?? 'en',
        token: accessToken ?? '',
        bookingId: bookingId,
      );

      emit(GenerateOTPLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> verifyRideOtpByDriver({
    required final int bookingId,
    required final String otp,
  }) async {
    try {
      emit(VerifyRideOTPLoadingState('Loading'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.verifyRideOtpByDriver(
        lang: lang ?? 'en',
        token: accessToken ?? '',
        bookingId: bookingId,
        otp: otp,
      );

      emit(VerifyRideOTPLoadedState(data: response));
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
      final response = await _driverRepository.verifyRideOtpByDriver(
        lang: lang ?? 'en',
        token: accessToken ?? '',
        bookingId: bookingId,
        otp: otp,
      );

      emit(VerifyEndRideOTPLoadedState(data: response));
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
      final response = await _driverRepository.endRideByDriver(
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
