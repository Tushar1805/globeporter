import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/driver/model/ride_cancellation_reason_response.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:globeporter/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

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
  const CustomLocationBox({
    super.key,
    required this.currentLocationController,
    this.readOnly,
  });
  final TextEditingController currentLocationController;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor2),
        readOnly: readOnly ?? true,
        controller: currentLocationController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.width * 0.0626,
            minWidth: MediaQuery.of(context).size.width * 0.0469,
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(4),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.023,
            horizontal: 12,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Image.asset(
              locationPinImage,
              width: MediaQuery.of(context).size.width * 0.0469,
              height: MediaQuery.of(context).size.width * 0.0626,
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
    this.borderRadius,
    this.textStyle,
    this.cursorColor,
    this.readOnly,
    this.onChanged,
    this.inputFormatters,
    this.hint,
    this.textCapitalization,
    this.suffixIcon,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onTap,
  });
  final TextEditingController textEditingController;
  final int? maxLines;
  final TextInputType? inputType;
  final double? borderRadius;
  final TextStyle? textStyle;
  final Color? cursorColor;
  final bool? readOnly;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? hint;
  final TextCapitalization? textCapitalization;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        onTap: onTap,
        focusNode: focusNode,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        style: textStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(color: greyTextColor2),
        inputFormatters: inputFormatters,
        controller: textEditingController,
        keyboardType: inputType ?? TextInputType.name,
        cursorColor: cursorColor ?? primaryColor,
        maxLines: maxLines ?? 1,
        readOnly: readOnly ?? false,
        onChanged: onChanged ?? (val) {},
        textInputAction: textInputAction,
        onSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIconConstraints: BoxConstraints(minHeight: 32, minWidth: 24),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(borderRadius ?? 4),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(borderRadius ?? 4),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            hint: Text(
              hint ?? '',
              style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 14),
            )),
      ),
    );
  }
}

class CustomStatusBarWidget extends StatelessWidget {
  const CustomStatusBarWidget({
    super.key,
    required this.title,
    this.text,
    this.height,
    this.titlePositionTop,
    this.fontSize,
  });
  final String? title;
  final Widget? text;
  final double? height;
  final double? titlePositionTop;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: height ?? size.width * 0.25,
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
          top: titlePositionTop ?? size.height * 0.055,
          left: size.width * 0.043,
          child: text ??
              Text(
                title ?? '',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: whiteColor,
                      fontSize: fontSize ?? 24,
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
    this.textWidget,
  });
  final String? name;
  final double? borderRadius;
  final Color? backgroundColor;
  final Alignment? alignment;
  final EdgeInsetsGeometry? textPadding;
  final VoidCallback onPressed;
  final Color? nameColor;
  final double? nameSize;
  final Widget? textWidget;
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
          child: textWidget ??
              Text(
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
    required this.title,
    super.key,
  });

  final String icon;
  final VoidCallback onTap;
  final int pageIndex;
  final int itemIndex;
  final String title;

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
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: primaryColor),
                ),
              ],
            )
          : Opacity(
              opacity: 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    icon,
                    height: size.width * 0.0587,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: primaryColor),
                  ),
                ],
              ),
            ),
    );
  }
}

void showReasonDialog({
  required final BuildContext context,
  required final Future Function(String id) onTap,
  required final RideCancellationReasonResponse? reasons,
  required final ValueNotifier<bool> loadingNotifier,
}) {
  String? selectedReason;

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: primaryColor),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8, // Prevents overflow
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: SingleChildScrollView(
            child: Container(
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
                          isExpanded: true, // Forces items to wrap within dialog width
                          value: selectedReason,
                          hint: Text(
                            AppLocalizations.of(context)!.selectReasonString,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 22,
                                  color: whiteColor,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          dropdownColor: Colors.green.shade700,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          items: reasons?.data?.map((reason) {
                            return DropdownMenuItem(
                              value: reason.id.toString(),
                              child: Text(
                                reason.reason ?? '',
                                softWrap: true,
                                overflow: TextOverflow.visible, // Wrap text instead of cutting
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: whiteColor),
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
                      ValueListenableBuilder<bool>(
                        valueListenable: loadingNotifier,
                        builder: (context, isLoading, _) {
                          return isLoading
                              ? CircularProgressIndicator(color: whiteColor)
                              : CustomElevatedButton(
                                  name: AppLocalizations.of(context)!.submitString,
                                  borderRadius: 25,
                                  alignment: Alignment.center,
                                  onPressed: () async => await onTap(selectedReason ?? ''),
                                  backgroundColor: whiteColor,
                                  nameColor: primaryColor,
                                );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
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
  final Padding? description,
  final bool? loading,
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
              description ?? SizedBox.shrink(),
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

void showCustomDialogOneButton({
  required final BuildContext context,
  required final double? borderRadius,
  required final String? title,
  required final VoidCallback onTap,
  required final String? buttonTitle,
  final Widget? text,
  final bool? barrierDismissible,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? true,
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
              text ??
                  Text(
                    title ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 24,
                          color: whiteColor,
                        ),
                  ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                name: buttonTitle ?? AppLocalizations.of(context)!.yesString,
                borderRadius: 28,
                alignment: Alignment.center,
                onPressed: onTap,
                backgroundColor: whiteColor,
                nameColor: primaryColor,
                nameSize: 24,
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showOtpDialog({
  required BuildContext context,
  required double? borderRadius,
  required String? title,
  required Function(String otp) onOtpSubmit,
  String? buttonTitle,
  bool? barrierDismissible,
}) {
  final TextEditingController otpController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          side: BorderSide(color: primaryColor),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'Enter OTP',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 24,
                      color: whiteColor,
                    ),
              ),
              const SizedBox(height: 20),

              // OTP TextField

              TextField(
                controller: otpController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 4,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black, letterSpacing: 8),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.6),
                  hintText: AppLocalizations.of(context)!.enterOtpString,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Submit button
              CustomElevatedButton(
                name: buttonTitle ?? AppLocalizations.of(context)!.submitString,
                borderRadius: 28,
                alignment: Alignment.center,
                onPressed: () {
                  final otp = otpController.text.trim();
                  if (otp.isEmpty || otp.length < 4) {
                    Fluttertoast.showToast(
                        msg:
                            "${AppLocalizations.of(context)!.pleaseEnterString} ${AppLocalizations.of(context)!.validString.toLowerCase()}  ${AppLocalizations.of(context)!.otpString.toUpperCase()}");
                    return;
                  }
                  // context.pop(); // Close dialog
                  onOtpSubmit(otp);
                },
                backgroundColor: whiteColor,
                nameColor: primaryColor,
                nameSize: 24,
              ),
            ],
          ),
        ),
      );
    },
  );
}

class PackageDetail {
  TextEditingController productNameController;
  TextEditingController packagingTypeController;
  TextEditingController quantiyTypeController;

  PackageDetail({
    required this.productNameController,
    required this.packagingTypeController,
    required this.quantiyTypeController,
  });
}

class DynamicItemDialog extends StatefulWidget {
  const DynamicItemDialog({super.key, required this.type});
  final String? type;

  @override
  State<DynamicItemDialog> createState() => _DynamicItemDialogState();
}

class _DynamicItemDialogState extends State<DynamicItemDialog> {
  List<PackageDetail> items = [];

  @override
  void initState() {
    super.initState();
    _addNewItem();
  }

  void _addNewItem() {
    setState(() {
      items.add(PackageDetail(
        packagingTypeController: TextEditingController(),
        productNameController: TextEditingController(),
        quantiyTypeController: TextEditingController(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.itemDetailsString,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      color: primaryColor,
                    ),
              ),
              const SizedBox(height: 10),
              ...items.asMap().entries.map((entry) {
                // final index = entry.key;
                final item = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            AppLocalizations.of(context)!.productNameString,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: primaryColor, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          textEditingController: item.productNameController,
                          borderRadius: 10,
                          textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 20,
                                color: primaryColor,
                              ),
                          cursorColor: primaryColor,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            AppLocalizations.of(context)!.packagingTypeString,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: primaryColor, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          textEditingController: item.packagingTypeController,
                          borderRadius: 10,
                          textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 20,
                                color: primaryColor,
                              ),
                          cursorColor: primaryColor,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            AppLocalizations.of(context)!.quantityString,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: primaryColor, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          textEditingController: item.quantiyTypeController,
                          borderRadius: 10,
                          textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 20,
                                color: primaryColor,
                              ),
                          cursorColor: primaryColor,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              }),
              CustomElevatedButton(
                name: '+ ${AppLocalizations.of(context)!.addMoreItemsString}',
                borderRadius: 4,
                alignment: Alignment.centerRight,
                onPressed: _addNewItem,
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                name: AppLocalizations.of(context)!.submitString,
                borderRadius: 25,
                alignment: Alignment.bottomCenter,
                onPressed: () {
                  for (var item in items) {
                    debugPrint('Product: ${item.productNameController.text}, '
                        'Packaging: ${item.packagingTypeController.text}, '
                        'Qty: ${item.quantiyTypeController.text}');
                  }
                  context.pop();
                  context.pushNamed(startTripScreen, extra: {'type': widget.type});
                },
                textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                nameSize: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showDynamicItemDialog({required final BuildContext context, required final String? type}) {
  showDialog(
    context: context,
    builder: (_) => DynamicItemDialog(type: type),
  );
}

class ProfileEditCard extends StatelessWidget {
  const ProfileEditCard(
      {super.key,
      required this.label,
      required this.value,
      required this.onTap,
      this.icon,
      this.isEditing = false,
      this.widget});
  final String label;
  final String value;
  final VoidCallback onTap;
  final String? icon;
  final Widget? widget;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    widget ??
                        Text(
                          value,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                              ),
                        ),
                  ],
                ),
              ),
              isEditing
                  ? IconButton(
                      onPressed: onTap,
                      icon: Icon(
                        Icons.close,
                        size: 24,
                      ),
                    )
                  : IconButton(
                      onPressed: onTap,
                      icon: Image.asset(
                        icon ?? editIcon,
                        height: 24,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingCardContent extends StatelessWidget {
  const SettingCardContent({
    super.key,
    required this.title,
    required this.prefixIcon,
    required this.onTap,
    this.suffixIcon,
    this.bottomPadding,
  });
  final String prefixIcon;
  final String title;
  final Widget? suffixIcon;
  final double? bottomPadding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ?? 0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Color(0xFFE0FFDE),
              ),
              child: Image.asset(
                prefixIcon,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: suffixIcon ??
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: primaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.listContent});
  final List<SettingCardContent> listContent;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 10,
        color: const Color(0xFFFAFFFA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: listContent,
          ),
        ),
      ),
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String? value;
  final List<String> options;
  final void Function(String?) onChanged;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButtonFormField2<String>(
        value: value,
        isExpanded: true,
        iconStyleData: IconStyleData(icon: const Icon(Icons.keyboard_arrow_down)),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          maxHeight: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: secondaryColor,
          ),
          offset: const Offset(0, -4),
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(
              primaryColor,
            ),
            radius: Radius.circular(4),
          ),
        ),
        items: options.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(
              type,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
