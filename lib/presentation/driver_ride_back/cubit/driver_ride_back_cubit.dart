import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/presentation/driver_ride_back/repo/driver_ride_back_repo.dart';
import 'package:globeporter/presentation/driver_ride_back/states/driver_ride_back_state.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';

class DriverRideBackCubit extends BaseCubit {
  final DriverRideBackRepository _driverRideBackRepository;
  DriverRideBackCubit(this._driverRideBackRepository);
  final storage = sl<SecureStorage>();

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

  Future<void> getCustomerPostedRides() async {
    try {
      emit(CustomerPostedRidesLoadingState('Loading posted rides list for customer...'));
      final lang = await storage.readValue(languageCodeKey);
      final token = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.getCustomerPostedRides(
        lang: lang ?? 'en',
        token: token ?? '',
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
}
