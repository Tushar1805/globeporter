import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

class StatusBarWidget extends StatelessWidget {
  const StatusBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        Container(
          height: 180 + statusBarHeight,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(124),
              bottomRight: Radius.circular(124),
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
