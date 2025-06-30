import 'package:core/localization/language_cubit.dart';
import 'package:core/theme/theme_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:globeporter/presentation/customer/cubit/customer_cubit.dart';
import 'package:globeporter/presentation/customer/repository/customer_repository.dart';
import 'package:globeporter/resources/app_storage.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/presentation/authentication/repository/auth_repo.dart';

final sl = GetIt.I;

void setupServiceLocator() async {
  //* Repositories
  sl.registerFactory<SecureStorage>(SecureStorage.new);
  sl.registerFactory<AuthRepository>(AuthRepository.new);
  sl.registerFactory<CustomerRepository>(CustomerRepository.new);

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
}
