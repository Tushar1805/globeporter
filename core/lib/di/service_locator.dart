import 'package:core/localization/language_cubit.dart';
import 'package:core/theme/theme_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:globeporter/location/cubit/location_cubit.dart';
import 'package:globeporter/location/repository/location_repository.dart';
import 'package:globeporter/presentation/customer/cubit/customer_cubit.dart';
import 'package:globeporter/presentation/customer/repository/customer_repository.dart';
import 'package:globeporter/presentation/chats/repo/chat_repository.dart';
import 'package:globeporter/presentation/driver/cubit/driver_details_cubit.dart';
import 'package:globeporter/presentation/chats/cubit/chat_cubit.dart';
import 'package:globeporter/presentation/driver/cubit/driver_cubit.dart';
import 'package:globeporter/presentation/driver/repository/driver_repository.dart';
import 'package:globeporter/presentation/driver_ride_back/cubit/driver_ride_back_cubit.dart';
import 'package:globeporter/presentation/driver_ride_back/repo/driver_ride_back_repo.dart';
import 'package:globeporter/presentation/notification/cubit/notification_cubit.dart';
import 'package:globeporter/presentation/notification/repository/notification_repository.dart';
import 'package:globeporter/presentation/settings/cubit/settings_cubit.dart';
import 'package:globeporter/presentation/settings/cubit/wallet_cubit.dart';
import 'package:globeporter/presentation/settings/repository/settings_repository.dart';
import 'package:globeporter/presentation/settings/repository/wallet_repository.dart';
import 'package:globeporter/resources/app_storage.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/authentication/repository/auth_repo.dart';

final sl = GetIt.I;

void setupServiceLocator() async {
  //* Repositories
  sl.registerFactory<SecureStorage>(SecureStorage.new);
  sl.registerFactory<AuthRepository>(AuthRepository.new);
  sl.registerFactory<CustomerRepository>(CustomerRepository.new);
  sl.registerFactory<DriverRepository>(DriverRepository.new);
  sl.registerFactory<LocationRepository>(LocationRepository.new);
  sl.registerFactory<SettingsRepository>(SettingsRepository.new);
  sl.registerFactory<ChatRepository>(ChatRepository.new);
  sl.registerFactory<WalletRepository>(WalletRepository.new);
  sl.registerFactory<NotificationRepository>(NotificationRepository.new);
  sl.registerFactory<DriverRideBackRepository>(DriverRideBackRepository.new);

  //* Cubits
  sl.registerLazySingleton<ThemeCubit>(
    ThemeCubit.new,
  );
  sl.registerLazySingleton<LanguageCubit>(
    LanguageCubit.new,
  );
  sl.registerSingleton<AuthCubit>(
    AuthCubit(sl<AuthRepository>()),
  );
  sl.registerSingleton<CustomerCubit>(
    CustomerCubit(sl<CustomerRepository>()),
  );
  sl.registerSingleton<DriverDetailsCubit>(
    DriverDetailsCubit(sl<DriverRepository>()),
  );
  sl.registerSingleton<DriverCubit>(
    DriverCubit(sl<DriverRepository>()),
  );
  sl.registerSingleton<LocationCubit>(
    LocationCubit(sl<LocationRepository>()),
  );
  sl.registerSingleton<SettingsCubit>(
    SettingsCubit(sl<SettingsRepository>()),
  );
  sl.registerSingleton<ChatCubit>(
    ChatCubit(sl<ChatRepository>()),
  );
  sl.registerSingleton<WalletCubit>(
    WalletCubit(sl<WalletRepository>()),
  );

  sl.registerSingleton<NotificationCubit>(
    NotificationCubit(sl<NotificationRepository>()),
  );
  sl.registerSingleton<DriverRideBackCubit>(
    DriverRideBackCubit(sl<DriverRideBackRepository>()),
  );
}
