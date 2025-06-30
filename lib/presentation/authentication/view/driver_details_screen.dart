import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/presentation/widgets/status_bar_widget.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class DriverDetailsScreen extends StatefulWidget {
  const DriverDetailsScreen({super.key});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  final TextEditingController vehicleIdController = TextEditingController();
  final TextEditingController driverLicenceController = TextEditingController();
  final TextEditingController vehicleNoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Curved Green Header with Logo
            StatusBarWidget(),

            const SizedBox(height: 45),

            // Truck Image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(driverWithVan, width: size.width * .7),
              ],
            ),

            const SizedBox(height: 35),

            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Personal Details',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: primaryColor, fontSize: 28),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehicle ID',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: vehicleIdController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      // hintText: enterMobileText,
                      // hintStyle:
                      //     Theme.of(context).textTheme.bodySmall?.copyWith(color: greyTextColor),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Driver Licence',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: driverLicenceController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      // hintText: enterMobileText,
                      // hintStyle:
                      //     Theme.of(context).textTheme.bodySmall?.copyWith(color: greyTextColor),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehicle No.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: vehicleNoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      // hintText: enterMobileText,
                      // hintStyle:
                      //     Theme.of(context).textTheme.bodySmall?.copyWith(color: greyTextColor),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, OnboardingScreen.route);
                  context.push(customerDashboard);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Submit',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: whiteColor, fontSize: 22, fontWeight: FontWeight.w700),
                  ),
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
