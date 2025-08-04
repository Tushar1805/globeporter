import 'package:core/di/service_locator.dart';
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

  Future<void> getCancellationReasons() async {
    try {
      emit(RideCancellationReasonsLoadingState('Loading Cancellation Reasons'));
      final lang = await storage.readValue(languageCodeKey);
      final response = await _driverRepository.getRideCancellationReasons(
        lang: lang ?? 'en',
        userType: '2',
      );

      emit(RideCancellationReasonsLoadedState(data: response));
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

  //* Get Pending Bookings

  Future<void> getPendingBookings() async {
    try {
      emit(PendingBookingsLoadingState('Loading vehicle types'));
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

  //* Accept or reject the ride

  Future<void> acceptOrRejectRide({
    required final int bookingId,
    required final String status,
  }) async {
    try {
      emit(AcceptOrRejectLoadingState('Loading vehicle types'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);
      final response = await _driverRepository.acceptOrRejectRide(
        lang: lang ?? 'en',
        token: accessToken ?? '',
        bookingId: bookingId,
        status: status,
      );

      emit(AcceptOrRejectLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }
}
