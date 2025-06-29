import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_strings.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/theme/theme_cubit.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(
    DevicePreview(
      enabled: true,
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) => const GlobePorter(),
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
}

class GlobePorter extends StatelessWidget {
  const GlobePorter({super.key});
  @override
  Widget build(BuildContext context) {
    final themeCubit = sl<ThemeCubit>();
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        bloc: themeCubit,
        builder: (final context, final state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: appNameString,
            theme: state,
            themeMode: ThemeMode.light,
            routerConfig: router,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(.8)),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
