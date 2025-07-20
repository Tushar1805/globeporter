

import 'package:globeporter/resources/app_regex.dart';

extension StringExtension on String {
  bool isValidPhoneNumber() => phoneNumberRegex.hasMatch(this);

  bool isValidEmail() => emailRegex.hasMatch(this);

  bool isValidPanCard() => panCardRegex.hasMatch(this);

  bool isValidPassword() => passwordRegex.hasMatch(this);
}
