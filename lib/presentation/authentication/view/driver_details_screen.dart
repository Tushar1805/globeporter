import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/widgets/status_bar_widget.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
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
                SvgPicture.asset(driverWithVanSvg, width: size.width * .7),
              ],
            ),

            const SizedBox(height: 35),

            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.updatePersonalDetailsString,
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                AppLocalizations.of(context)!.vehicleIdString,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            CustomTextField(textEditingController: vehicleIdController),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                AppLocalizations.of(context)!.driverLicenceString,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            CustomTextField(textEditingController: driverLicenceController),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                AppLocalizations.of(context)!.vehicleNo,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            CustomTextField(
              textEditingController: vehicleNoController,
              inputType: TextInputType.number,
            ),

            const SizedBox(height: 30),

            CustomElevatedButton(
              name: AppLocalizations.of(context)!.submitString,
              borderRadius: 25,
              alignment: Alignment.bottomCenter,
              onPressed: () {
                context.push(driverDashboard);
              },
              textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              nameSize: 22,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
