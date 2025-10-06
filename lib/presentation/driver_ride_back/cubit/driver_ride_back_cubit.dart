import 'package:core/di/service_locator.dart';
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

  Future<void> getMyPostedRides() async {
    try {
      emit(MyPostedRidesLoadingState('Loading Posted Rides...'));
      final lang = await storage.readValue(languageCodeKey);
      final token = await storage.readValue(accessTokenKey);
      final response = await _driverRideBackRepository.getMyPostedRides(
        lang: lang ?? 'en',
        token: token ?? '',
      );

      emit(MyPostedRidesLoadedState(data: response));
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

      emit(PlaceDriverRideLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }
}
