import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globeporter/resources/app_widgets.dart';

class InfoFieldWidget extends StatelessWidget {
  const InfoFieldWidget({
    super.key,
    required this.title,
    required this.controller,
    this.inputFormatter,
    this.inputType,
  });
  final String title;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: CustomRichText(
            title: title,
            value: ' *',
            titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
            valueStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.red,
                ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomTextField(
          textEditingController: controller,
          inputFormatters: inputFormatter,
          inputType: inputType,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
