final phoneNumberRegex = RegExp(r'^(\+\d{1,3}[- ]?)?\d{10}$');
final emailRegex = RegExp(
  r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})?$',
);
final panCardRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
