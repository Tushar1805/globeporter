import 'dart:io';
import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:go_router/go_router.dart';

class ImageReviewScreen extends StatelessWidget {
  final File imageFile;
  final bool isFront;
  final String title;
  final Function(File? file, bool? isFront) onSubmit;

  const ImageReviewScreen({
    super.key,
    required this.imageFile,
    required this.isFront,
    required this.onSubmit,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: whiteColor),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.file(imageFile),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              color: whiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomElevatedButton(
                    name: AppLocalizations.of(context)!.retakeString,
                    borderRadius: 25,
                    alignment: Alignment.bottomCenter,
                    onPressed: context.pop,
                  ),
                  CustomElevatedButton(
                    name: AppLocalizations.of(context)!.submitString,
                    borderRadius: 25,
                    alignment: Alignment.bottomCenter,
                    onPressed: () {
                      onSubmit(imageFile, isFront);
                      context.pop({
                        'file': imageFile,
                        'isFront': isFront,
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
