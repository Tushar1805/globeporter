import 'package:flutter/material.dart';
import 'package:globeporter/resources/app_colors.dart';
// import 'package:flutter_svg/svg.dart';

class StatusBarWidget extends StatelessWidget {
  const StatusBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height * 0.135,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(65),
              bottomRight: Radius.circular(65),
            ),
          ),
        ),
        // Positioned(
        //   top: statusBarHeight + 60,
        //   left: 0,
        //   right: 0,
        //   child: SvgPicture.asset(
        //     'assets/svg/logo_small.svg',
        //     width: MediaQuery.sizeOf(context).width * .4,
        //   ),
        // ),
      ],
    );
  }
}
