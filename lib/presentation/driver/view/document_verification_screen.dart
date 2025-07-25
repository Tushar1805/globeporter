import 'package:core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/authentication/cubit/auth_cubit.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class DocumentVerificationScreen extends StatelessWidget {
  DocumentVerificationScreen({super.key});

  final isVerified = false;
  final authCubit = sl<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    final steps = [
      _StepData(
        title: AppLocalizations.of(context)!.uploadDocumentString,
        subtitle:
            '${AppLocalizations.of(context)!.driverLicenceString}, ${AppLocalizations.of(context)!.adhaarCardString}, ${AppLocalizations.of(context)!.etcString}',
        isCompleted: true,
      ),
      _StepData(
        title: AppLocalizations.of(context)!.verificationString,
        subtitle: AppLocalizations.of(context)!.verificationInProcessString,
        isCompleted: false,
        isCurrent: true,
      ),
      // _StepData(
      //   title: AppLocalizations.of(context)!.goString,
      //   subtitle: '',
      //   isCompleted: false,
      //   isCurrent: true,
      // ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${AppLocalizations.of(context)!.hiString} ${authCubit.userDetails?.data?.name}, ${AppLocalizations.of(context)!.welecomeToString} GlobePorter',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.fewStepsAwayString,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ...List.generate(steps.length, (index) {
              final step = steps[index];
              return _StepItem(step: step, index: index + 1);
            }),
            const SizedBox(height: 24),
            if (steps.last.isCurrent)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   'Get your first trip',
                    //   style:
                    //       TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 4),
                    // const Text(
                    //   'Voila! You are ready to do your first trip',
                    //   style: TextStyle(color: Colors.white70, fontSize: 14),
                    // ),
                    // const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (isVerified) {
                            context.go(driverDashboard);
                          }
                        },
                        icon: const Icon(Icons.arrow_forward, color: whiteColor),
                        label: Text(
                          AppLocalizations.of(context)!.goString,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: whiteColor, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade500,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Helper Widgets ----------------

class _StepData {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;

  _StepData({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.isCurrent = false,
  });
}

class _StepItem extends StatelessWidget {
  final _StepData step;
  final int index;

  const _StepItem({required this.step, required this.index});

  @override
  Widget build(BuildContext context) {
    final icon = step.isCompleted
        ? const Icon(Icons.check_circle, color: primaryColor)
        : step.isCurrent
            ? CircleAvatar(
                radius: 12,
                backgroundColor: Colors.blue,
                child: Text(
                  '$index',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            : CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.shade300,
                child: Text(
                  '$index',
                  style: const TextStyle(color: Colors.black),
                ),
              );

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(step.subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey, fontSize: 14)),
                  step.isCompleted
                      ? Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(AppLocalizations.of(context)!.uploadedString,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: primaryColor, fontSize: 16)),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(AppLocalizations.of(context)!.pendingString,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.amber, fontSize: 16)),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
