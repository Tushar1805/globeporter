import 'package:core/di/service_locator.dart';
import 'package:core/utils/core_utils.dart';
import 'package:datasource/states/data_state.dart';
import 'package:globeporter/basecubit/base_cubit.dart';
import 'package:globeporter/presentation/customer/model/booking_details_response.dart';
import 'package:globeporter/presentation/customer/repository/customer_repository.dart';
import 'package:globeporter/presentation/customer/states/customer_states.dart';
import 'package:globeporter/presentation/customer/view/request_details_screen.dart';
import 'package:globeporter/resources/app_keys.dart';
import 'package:globeporter/resources/app_storage.dart';

class CustomerCubit extends BaseCubit {
  final CustomerRepository _customerRepository;
  CustomerCubit(this._customerRepository);
  final storage = sl<SecureStorage>();

  Future<void> getPackagingType() async {
    try {
      emit(PackagingTypeLoadingState('Loading vehicle types'));
      final lang = await storage.readValue(languageCodeKey);
      final response = await _customerRepository.getPackagingType(lang: lang ?? 'en');

      emit(PackagingTypeLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getQuantity() async {
    try {
      emit(QuantityLoadingState('Loading Quantities'));
      final lang = await storage.readValue(languageCodeKey);
      final response = await _customerRepository.getQuantity(lang: lang ?? 'en');

      emit(QuantityLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getVehicleType() async {
    try {
      emit(VehicleTypeLoadingState('Loading vehicle types'));
      final lang = await storage.readValue(languageCodeKey);
      final response = await _customerRepository.getVehicleType(lang: lang ?? 'en');

      emit(VehicleTypeLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> getCustomerRideBookings() async {
    try {
      emit(CustomerRideBookingsLoadingState('Loading customer ride bookings'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);

      final response = await _customerRepository.getCustomerRideBookings(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
      );

      emit(CustomerRideBookingsLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<BookingDetailsResponse?> getBookingDetails({
    required final String bookingId,
  }) async {
    try {
      emit(BookingDetailsLoadingState('Loading bookings details'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);

      final response = await _customerRepository.getBookingDetails(
          lang: lang ?? 'en', accessToken: accessToken ?? '', bookingId: bookingId);

      emit(BookingDetailsLoadedState(data: response));
      return response;
    } catch (e) {
      handleExceptions(e);
      return null;
    }
  }

  Future<void> findNearbyDrivers({
    required final int bookingId,
    required final String distance,
  }) async {
    try {
      emit(NearbyDriversLoadingState('Loading nearby drivers'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);

      final response = await _customerRepository.findNearbyDrivers(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        bookingId: bookingId,
        distance: distance,
      );

      emit(NearbyDriversLoadedState(data: response));
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> createRuralRequest({
    required final int vehicleTypeId,
    required final List<Map<String, dynamic>> packageData,
    required final String receiverName,
    required final String receiverContact,
    required final String pickupAddress,
    required final String dropAddress,
    required final String pickupLat,
    required final String pickupLng,
    required final String dropLat,
    required final String dropLng,
  }) async {
    try {
      emit(CustomerRequestLoadingState('Creating Rural Request'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);

      final response = await _customerRepository.createRuralRequest(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        packageData: packageData,
        vehicleTypeId: vehicleTypeId,
        receiverName: receiverName,
        receiverContact: receiverContact,
        pickupAddress: pickupAddress,
        dropAddress: dropAddress,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,
      );

      if (response['status_code'] == 200) {
        customPrint('REQUEST DATA: $response');
        emit(CustomerRequestLoadedState(data: response));
      } else {
        emit(ErrorState(response['message']));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }

  Future<void> createUrbanRequest({
    required final int vehicleTypeId,
    required final String receiverName,
    required final String receiverContact,
    required final String pickupAddress,
    required final String dropAddress,
    required final String pickupLat,
    required final String pickupLng,
    required final String dropLat,
    required final String dropLng,
    required final List<ItemEntry> itemEntries,
  }) async {
    try {
      emit(CustomerRequestLoadingState('Creating Rural Request'));
      final lang = await storage.readValue(languageCodeKey);
      final accessToken = await storage.readValue(accessTokenKey);

      final response = await _customerRepository.createUrbanRequest(
        lang: lang ?? 'en',
        accessToken: accessToken ?? '',
        vehicleTypeId: vehicleTypeId,
        receiverName: receiverName,
        receiverContact: receiverContact,
        pickupAddress: pickupAddress,
        dropAddress: dropAddress,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,
        itemEntries: itemEntries,
      );

      if (response['status_code'] == 200) {
        emit(CustomerRequestLoadedState(data: response));
      } else if (response['status_code'] == 500) {
        emit(ErrorState('Something went wrong'));
      }
    } catch (e) {
      handleExceptions(e);
    }
  }
}
