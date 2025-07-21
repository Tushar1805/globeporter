// ignore_for_file: use_build_context_synchronously

import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.role});
  final String? role;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final authCubit = sl<AuthCubit>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.35),
        child: Stack(
          children: [
            Container(
              height: size.width * 0.35,
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
              top: size.height * 0.05,
              left: size.width * 0.05,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: size.width * 0.08,
                        child: CircleAvatar(
                          radius: size.width * 0.076,
                          backgroundImage: NetworkImage(
                            authCubit.userDetails?.data?.profilePhotoUrl ?? sampleNetworkImage,
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        left: size.width * 0.1,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            if (widget.role == 'customer') {
                              context.pushNamed(customerProfileScreen);
                            } else {
                              context.pushNamed(driverProfileScreen);
                            }
                          },
                          child: CircleAvatar(
                            radius: size.width * 0.029,
                            backgroundColor: primaryColor,
                            child: CircleAvatar(
                              backgroundColor: whiteColor,
                              radius: size.width * 0.027,
                              child: Image.asset(
                                editIcon,
                                width: 12,
                                height: 12,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 15),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authCubit.userDetails?.data?.name ?? 'User Name',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                        ),
                        Text(
                          authCubit.userDetails?.data?.email ?? 'email@test.com',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            CustomText(
              text: AppLocalizations.of(context)!.benefitString,
              fontSize: 16,
            ),
            const SizedBox(
              height: 10,
            ),
            SettingsCard(
              listContent: [
                SettingCardContent(
                  title: AppLocalizations.of(context)!.recentPickupString,
                  prefixIcon: likeIcon,
                  onTap: () {},
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomText(
              text: AppLocalizations.of(context)!.benefitString,
              fontSize: 16,
            ),
            const SizedBox(
              height: 10,
            ),
            SettingsCard(
              listContent: [
                SettingCardContent(
                  title: AppLocalizations.of(context)!.referFreindString,
                  prefixIcon: giftIcon,
                  onTap: () {
                    context.pushNamed(referAndEarnScreen);
                  },
                  suffixIcon: Container(
                    padding: EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color(0xFFE0FFDE),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          shareIcon,
                          width: 17,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          AppLocalizations.of(context)!.inviteString,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomText(
              text: AppLocalizations.of(context)!.supportLegalString,
              fontSize: 16,
            ),
            const SizedBox(
              height: 10,
            ),
            SettingsCard(
              listContent: [
                SettingCardContent(
                  title: AppLocalizations.of(context)!.helpSupportString,
                  prefixIcon: helpIcon,
                  bottomPadding: 10,
                  onTap: () {},
                ),
                SettingCardContent(
                  title: AppLocalizations.of(context)!.termsConditionString,
                  prefixIcon: termsConditionIcon,
                  onTap: () {},
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomText(
              text: AppLocalizations.of(context)!.settingString,
              fontSize: 16,
            ),
            const SizedBox(
              height: 10,
            ),
            SettingsCard(
              listContent: [
                SettingCardContent(
                  title: AppLocalizations.of(context)!.chooseLanguageString,
                  prefixIcon: termsConditionIcon,
                  bottomPadding: 10,
                  onTap: () {
                    context.pushNamed(
                      setLanguageScreen,
                      extra: {
                        'onPop': true,
                      },
                    );
                  },
                ),
                SettingCardContent(
                  title: AppLocalizations.of(context)!.logoutString,
                  prefixIcon: logoutIcon,
                  onTap: () async {
                    await authCubit.logout();
                    context.pushNamed(loginScreen);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
