import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/customer/model/customer_ride_response.dart' as customer;
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_widgets.dart';

class MyRequestDetailsScreen extends StatelessWidget {
  const MyRequestDetailsScreen({
    super.key,
    required this.type,
    required this.requestData,
  });

  final String? type;
  final customer.Data? requestData;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.25),
        child: CustomStatusBarWidget(
          title: AppLocalizations.of(context)!.myRequestString,
          text: CustomRichText(
            title: '${AppLocalizations.of(context)!.myRequestString}: ',
            value: type == 'urban'
                ? AppLocalizations.of(context)!.urbanString
                : AppLocalizations.of(context)!.ruralString,
            titleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 20,
                  color: whiteColor,
                ),
            valueStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 22,
                  color: whiteColor,
                ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CustomText(text: AppLocalizations.of(context)!.pickupLocationString),
            const SizedBox(height: 8),
            ShowLocationWidget(address: requestData?.pickupAddress),
            const CustomDivider(),
            CustomText(text: AppLocalizations.of(context)!.destinationLocationString),
            const SizedBox(height: 8),
            ShowLocationWidget(address: requestData?.dropAddress),
            const CustomDivider(),
            CustomText(text: AppLocalizations.of(context)!.receiverNameString),
            const SizedBox(height: 8),
            CustomTextMedium(text: requestData?.receiverName ?? ''),
            const CustomDivider(),
            CustomText(text: AppLocalizations.of(context)!.contactNoString),
            const SizedBox(height: 8),
            CustomTextMedium(text: requestData?.receiverContactNo ?? ''),
            const CustomDivider(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomRichText(
                title: '${AppLocalizations.of(context)!.statusString}: ',
                value: requestData?.status == 1
                    ? AppLocalizations.of(context)!.confirmString
                    : AppLocalizations.of(context)!.pendingString,
                titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                valueStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            if (type == 'urban') UrbanItemsSection(requestData: requestData, size: size),
            if (type == 'rural') RuralDetailsSection(requestData: requestData, size: size),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class UrbanItemsSection extends StatelessWidget {
  const UrbanItemsSection({super.key, required this.requestData, required this.size});

  final customer.Data? requestData;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final items = requestData?.bookingRideItem ?? [];

    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: List.generate(
        items.length,
        (index) {
          final bookingItem = items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: '${AppLocalizations.of(context)!.itemDetailsString}: ${index + 1}',
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: size.width * 0.1),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: bookingItem.itemImageUrl?.isNotEmpty == true
                        ? Image.network(
                            bookingItem.itemImageUrl!,
                            height: size.width * 0.25,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                          )
                        : const Icon(Icons.image_not_supported),
                  ),
                ),
                const SizedBox(height: 20),
                CustomText(text: AppLocalizations.of(context)!.descriptionString),
                const SizedBox(height: 8),
                CustomTextMedium(text: bookingItem.description ?? '-'),
                const CustomDivider(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RuralDetailsSection extends StatelessWidget {
  const RuralDetailsSection({super.key, required this.requestData, required this.size});

  final customer.Data? requestData;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Divider(color: primaryColor),
        ),
        CustomText(text: AppLocalizations.of(context)!.productTypeString),
        const SizedBox(height: 8),
        CustomTextMedium(text: requestData?.packageTypeData?.nameEn ?? ''),
        const CustomDivider(),
        CustomText(text: AppLocalizations.of(context)!.packagingTypeString),
        const SizedBox(height: 8),
        CustomTextMedium(text: requestData?.packageTypeData?.nameEn ?? ''),
        const CustomDivider(),
        CustomText(text: AppLocalizations.of(context)!.quantityString),
        const SizedBox(height: 8),
        CustomTextMedium(text: requestData?.qty ?? ''),
        const CustomDivider(),
      ],
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        color: primaryColor,
      ),
    );
  }
}
