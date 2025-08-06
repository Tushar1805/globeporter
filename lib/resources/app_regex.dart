final emailRegex = RegExp(
  r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})?$',
);
final panCardRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
final nameRegex = RegExp(r'[a-zA-Z ]');
final phoneNumberRegex = RegExp('[0-9]');
final vehicleNumberRegex = RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{3,4}$');
final vehicleRCRegex = RegExp(r'^[A-Z0-9]{13,17}$');
final licenseRegex = RegExp(r'^[A-Z]{2}\d{13,14}$');
