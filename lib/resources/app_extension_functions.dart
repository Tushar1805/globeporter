import 'package:globeporter/resources/app_regex.dart';

extension StringExtension on String {
  bool isValidEmail() => emailRegex.hasMatch(this);

  bool isValidPanCard() => panCardRegex.hasMatch(this);

  bool isValidPassword() => passwordRegex.hasMatch(this);

  bool isValidVehicleNumber() => vehicleNumberRegex.hasMatch(this);

  bool isValidRCNumber() => vehicleRCRegex.hasMatch(this);

  bool isValidLicenceNumber() => licenseRegex.hasMatch(this);
}

enum RideStatus {
  accepted,
  onTheWay,
  arrivedAtPickup,
  rideStarted,
  arrivedAtDestination,
  driverNotFound,
  rideClosed,
}

extension RideStatusExtension on RideStatus {
  String get value {
    switch (this) {
      case RideStatus.accepted:
        return 'Accepted';
      case RideStatus.onTheWay:
        return 'On The Way';
      case RideStatus.arrivedAtPickup:
        return 'Arrived At Pickup Point';
      case RideStatus.rideStarted:
        return 'Ride Started';
      case RideStatus.arrivedAtDestination:
        return 'Arrived At Destination';
      case RideStatus.driverNotFound:
        return 'Driver Not Found';
      case RideStatus.rideClosed:
        return 'Ride Closed';
    }
  }
}
