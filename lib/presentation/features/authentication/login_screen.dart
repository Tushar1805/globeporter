import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/colors.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Curved Green Header with Logo
            Stack(
              children: [
                Container(
                  height: 180 + statusBarHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(124), bottomRight: Radius.circular(124)),
                  ),
                ),
                Positioned(
                  top: statusBarHeight + 60,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset('assets/svg/logo_small.svg', width: MediaQuery.sizeOf(context).width * .4),
                ),
              ],
            ),

            const SizedBox(height: 45),

            // Truck Image (replace with your actual image path)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [SvgPicture.asset('assets/svg/driver_with_van.svg', height: 160)]),

            const SizedBox(height: 65),

            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: CustomColors.primaryColor),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
                    child: Text(
                      'Enter a valid mobile number to continue\nusing delivery and other features',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: CustomColors.blackColor),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Phone Input Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  // Country Code Dropdown (non-functional placeholder)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        // Image(image: AssetImage('assets/images/flag_india.png'), height: 20),
                        SizedBox(width: 6),
                        Text('+91'),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Mobile Number Input
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Enter your mobile number',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Continue Button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: const CircleBorder(), padding: const EdgeInsets.all(14)),
                  onPressed: () {
                    // Handle login logic
                  },
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
