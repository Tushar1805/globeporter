import 'package:flutter/material.dart';
import 'package:globeporter/resources/app_images.dart';

class AddressRowWidget extends StatelessWidget {
  const AddressRowWidget({required this.address, super.key});
  final String? address;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
