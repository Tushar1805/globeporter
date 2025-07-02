import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.text, this.fontSize, this.style});
  final String text;
  final double? fontSize;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: style ?? Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: fontSize ?? 18),
      ),
    );
  }
}

class CustomTextMedium extends StatelessWidget {
  const CustomTextMedium({super.key, required this.text, this.fontSize, this.style});
  final String text;
  final double? fontSize;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: style ?? Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontSize ?? 16),
      ),
    );
  }
}

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    required this.title,
    required this.value,
    this.titleStyle,
    this.valueStyle,
  });

  final String? title;
  final String? value;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: title,
        style: titleStyle ??
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
        children: [
          TextSpan(
            text: value,
            style: valueStyle ??
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
          ),
        ],
      ),
    );
  }
}

class CustomLocationBox extends StatelessWidget {
  const CustomLocationBox({super.key, required this.currentLocationController});
  final TextEditingController currentLocationController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor2),
        readOnly: true,
        controller: currentLocationController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(minHeight: 32, minWidth: 24),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(4),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Image.asset(
              locationPinImage,
              width: 24,
              height: 32,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.textEditingController,
    this.maxLines,
    this.inputType,
  });
  final TextEditingController textEditingController;
  final int? maxLines;
  final TextInputType? inputType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor2),
        controller: textEditingController,
        keyboardType: inputType ?? TextInputType.name,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(minHeight: 32, minWidth: 24),
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
    );
  }
}

class CustomStatusBarWidget extends StatelessWidget {
  const CustomStatusBarWidget({super.key, required this.title, this.text});
  final String? title;
  final Widget? text;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.width * 0.25,
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
          top: size.height * 0.055,
          right: 15,
          child: Center(
            child: SvgPicture.asset(
              appLogoSmall,
              width: MediaQuery.sizeOf(context).width * .25,
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.055,
          left: size.width * 0.043,
          child: text ??
              Text(
                title ?? '',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: whiteColor,
                      fontSize: 24,
                    ),
              ),
        ),
      ],
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.name,
    required this.borderRadius,
    required this.alignment,
    required this.onPressed,
    this.textPadding,
    this.backgroundColor,
    this.nameColor,
    this.nameSize,
  });
  final String? name;
  final double? borderRadius;
  final Color? backgroundColor;
  final Alignment? alignment;
  final EdgeInsetsGeometry? textPadding;
  final VoidCallback onPressed;
  final Color? nameColor;
  final double? nameSize;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.centerRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: textPadding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            name ?? "",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: nameColor ?? whiteColor,
                  fontSize: nameSize ?? 16,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}

class BottomNavBarIcon extends StatelessWidget {
  const BottomNavBarIcon({
    required this.icon,
    required this.onTap,
    required this.pageIndex,
    required this.itemIndex,
    super.key,
  });

  final String icon;
  final VoidCallback onTap;
  final int pageIndex;
  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return IconButton(
      highlightColor: Colors.transparent,
      enableFeedback: false,
      onPressed: onTap.call,
      icon: pageIndex == itemIndex
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  icon,
                  height: size.width * 0.0587,
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    icon,
                    height: size.width * 0.0587,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
    );
  }
}

void showReasonDialog({
  required final BuildContext context,
  required final VoidCallback onTap,
}) {
  String? selectedReason;
  final List<String> reasons = [
    'Reason 1',
    'Reason 2',
    'Reason 3',
  ];

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: primaryColor),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedReason,
                      hint: Text(
                        AppLocalizations.of(context)!.selectReasonString,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 28,
                              color: whiteColor,
                            ),
                      ),
                      dropdownColor: Colors.green.shade700,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      items: reasons.map((reason) {
                        return DropdownMenuItem(
                          value: reason,
                          child: Text(
                            reason,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(color: whiteColor),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    name: AppLocalizations.of(context)!.submitString,
                    borderRadius: 25,
                    alignment: Alignment.center,
                    onPressed: onTap,
                    backgroundColor: whiteColor,
                    nameColor: primaryColor,
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

void showCustomDialog({
  required final BuildContext context,
  required final double? borderRadius,
  required final String? title,
  required final VoidCallback onTapYes,
  required final VoidCallback onTapNo,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          side: BorderSide(color: primaryColor),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 24,
                      color: whiteColor,
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomElevatedButton(
                    name: AppLocalizations.of(context)!.yesString,
                    borderRadius: 28,
                    alignment: Alignment.center,
                    onPressed: onTapYes,
                    backgroundColor: whiteColor,
                    nameColor: primaryColor,
                    nameSize: 24,
                  ),
                  CustomElevatedButton(
                    name: AppLocalizations.of(context)!.noString,
                    borderRadius: 28,
                    alignment: Alignment.center,
                    onPressed: onTapNo,
                    backgroundColor: Colors.red,
                    nameColor: whiteColor,
                    nameSize: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class ShowLocationWidget extends StatelessWidget {
  const ShowLocationWidget({super.key, required this.address, this.fontSize});
  final String? address;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Image.asset(
            locationPinImage,
            width: 24,
            height: 32,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              address ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
