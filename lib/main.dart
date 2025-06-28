import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'core/index.dart';
import 'cubits/index.dart';
import 'data/repositories/auth_repo.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  // await Hive.initFlutter();
  // await Firebase.initializeApp();
  // Hive.registerAdapter(HiveUserModelAdapter());
  // Box<HiveUserModel> session = await Hive.openBox('session');
  final ApiService apiService = ApiService();
  // FlutterNativeSplash.remove();
  runApp(GlobePorter(authRepository: AuthRepository(apiService)));
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: CustomColors.primaryColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.dark),
  );
}

class GlobePorter extends StatelessWidget {
  final AuthRepository authRepository;
  const GlobePorter({super.key, required this.authRepository});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthCubit(authRepository))],
      child: ScreenUtilInit(
        designSize: const Size(440, 956),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GlobePorter',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          onGenerateRoute: Routes.generateRoute,
          onUnknownRoute: Routes.errorRoute,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
