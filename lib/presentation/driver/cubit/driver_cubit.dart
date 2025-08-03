import 'package:core/di/service_locator.dart';
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
}
