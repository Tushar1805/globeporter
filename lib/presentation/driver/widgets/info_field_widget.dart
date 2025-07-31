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
    this.hint,
    this.textCapitalization,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });
  final String title;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? inputType;
  final String? hint;
  final TextCapitalization? textCapitalization;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;

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
          focusNode: focusNode,
          textEditingController: controller,
          inputFormatters: inputFormatter,
          inputType: inputType,
          hint: hint,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
