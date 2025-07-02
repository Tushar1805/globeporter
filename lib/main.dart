import 'package:core/localization/language_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
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

class GlobePorter extends StatefulWidget {
  const GlobePorter({super.key});

  @override
  State<GlobePorter> createState() => _GlobePorterState();
}

class _GlobePorterState extends State<GlobePorter> {
  late final ThemeCubit themeCubit;
  late final LanguageCubit languageCubit;

  @override
  void initState() {
    super.initState();
    themeCubit = sl<ThemeCubit>();
    languageCubit = sl<LanguageCubit>();
    languageCubit.getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => sl<ThemeCubit>(),
        ),
        BlocProvider<LanguageCubit>(
          create: (_) => sl<LanguageCubit>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(440, 956),
        child: BlocBuilder<ThemeCubit, ThemeData>(
          bloc: themeCubit,
          builder: (final context, final themeState) {
            return BlocBuilder<LanguageCubit, Locale>(
              bloc: languageCubit,
              builder: (final context, final localeState) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: appNameString,
                  locale: localeState,
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: [Locale('en'), Locale('hi')],
                  theme: themeState,
                  themeMode: ThemeMode.light,
                  routerConfig: router,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(.85)),
                      child: child!,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
