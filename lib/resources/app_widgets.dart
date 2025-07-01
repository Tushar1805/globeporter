import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.text, this.fontSize});
  final String text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: fontSize ?? 18),
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
  const CustomTextField({super.key, required this.textEditingController, this.maxLines});
  final TextEditingController textEditingController;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor2),
        controller: textEditingController,
        keyboardType: TextInputType.name,
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
  const CustomStatusBarWidget({super.key, required this.title});
  final String? title;
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
          child: Text(
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 4)),
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
