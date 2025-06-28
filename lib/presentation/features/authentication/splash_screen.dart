import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/index.dart';
import 'select_lang_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String route = '/';
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    Navigator.pushReplacementNamed(context, SelectLangScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CustomColors.primaryColor,
        child: Center(
          child: SvgPicture.asset('assets/svg/logo_large.svg', fit: BoxFit.contain, width: MediaQuery.of(context).size.width * .6),
        ),
      ),
    );
  }
}
