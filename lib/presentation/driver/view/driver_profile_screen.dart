import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.width * 0.45,
              child: Stack(
                children: [
                  Container(
                    height: size.width * 0.3326,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(size.width * 0.127),
                        bottomRight: Radius.circular(size.width * 0.127),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.width * 0.2,
                    left: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: size.width * 0.12,
                      child: CircleAvatar(
                        radius: size.width * 0.116,
                        backgroundImage: AssetImage(
                          profileImage,
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.only(left: size.width * 0.18),
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: primaryColor,
                        child: CircleAvatar(
                          backgroundColor: whiteColor,
                          radius: 12,
                          child: Image.asset(
                            editIcon,
                            width: 15,
                            height: 15,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ProfileEditCard(
              label: AppLocalizations.of(context)!.nameString,
              value: 'Ravi Gupta',
              onTap: () {},
            ),
            const SizedBox(
              height: 20,
            ),
            ProfileEditCard(
              label: AppLocalizations.of(context)!.emailString,
              value: 'ravigupta214@gmail.com',
              onTap: () {},
            ),
            const SizedBox(
              height: 20,
            ),
            ProfileEditCard(
              label: AppLocalizations.of(context)!.vehicleIdString,
              value: 'ravigupta214@gmail.com',
              onTap: () {},
            ),
            const SizedBox(
              height: 20,
            ),
            ProfileEditCard(
              label: AppLocalizations.of(context)!.uploadDocumentString,
              value: 'ravigupta214@gmail.com',
              onTap: () {},
              icon: uploadIcon,
              widget: Row(
                children: [
                  Image.asset(
                    imageIcon,
                    height: 24,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Image',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ProfileEditCard(
              label: AppLocalizations.of(context)!.vehicleNo,
              value: 'ravigupta214@gmail.com',
              onTap: () {},
            ),
            SizedBox(
              height: size.width * 0.1,
            ),
            CustomElevatedButton(
              name: AppLocalizations.of(context)!.updateString,
              borderRadius: 25,
              alignment: Alignment.bottomCenter,
              onPressed: () {},
              textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              nameSize: 20,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
