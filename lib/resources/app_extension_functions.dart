import 'package:globeporter/resources/app_regex.dart';

extension StringExtension on String {
  bool isValidEmail() => emailRegex.hasMatch(this);

  bool isValidPanCard() => panCardRegex.hasMatch(this);

  bool isValidPassword() => passwordRegex.hasMatch(this);

  bool isValidVehicleNumber() => vehicleNumberRegex.hasMatch(this);

  bool isValidRCNumber() => vehicleRCRegex.hasMatch(this);
}
