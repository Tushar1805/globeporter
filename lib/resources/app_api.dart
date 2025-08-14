const String _baseUrl = 'https://globeporter.com/public/api/user';
const String _placesBaseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
const String _directionsbaseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

//* Places API's

const String searchPlacesUrl = '$_placesBaseUrl?input=';
const String routeDirectionUrl = '$_directionsbaseUrl?origin=';

//* Authentication

const String loginUrl = '$_baseUrl/login';
const String googleLoginUrl = '$_baseUrl/google_login_register';
const String registerUrl = '$_baseUrl/register';
const String otpVerificationUrl = '$_baseUrl/otp_verify';
const String deleteUserUrl = '$_baseUrl/delete_user_account';
const String getUserUrl = '$_baseUrl/get_user';
const String logoutUrl = '$_baseUrl/logout';
const String updateUserTypeUrl = '$_baseUrl/user_type_update';
const String getVehicleTypeUrl = '$_baseUrl/get_vehicle_type';
const String submitOwnerDetailsUrl = '$_baseUrl/update_user_owner_vehicle_details';
const String submitDriverDetailsUrl = '$_baseUrl/update_user_driver_vehicle_details';
const String submitVehicleDetailsUrl = '$_baseUrl/update_user_vehicle_details';
const String getVerificationStatusUrl = '$_baseUrl/get_verification_status';
const String fcmTokenUpdateUrl = '$_baseUrl/user_token_update';
const String updateUserLocationUrl = '$_baseUrl/update_lat_lng';

//* Driver

const String getOwnerDetailsUrl = '$_baseUrl/get_owner_details';
const String getVehicleDetailsUrl = '$_baseUrl/get_vehicle_details';
const String getDriverDetailsUrl = '$_baseUrl/get_driver_details';
const String reSubmitDocumetsUser = '$_baseUrl/common_update_user_vehicle_details';
const String getDriverBookingsUrl = '$_baseUrl/get_driver_bookings';
const String getPendingBookingsUrl = '$_baseUrl/get_pending_bookings';
const String acceptRejectRideUrl = '$_baseUrl/accept_reject_ride_status';
const String cancelRideDriverUrl = '$_baseUrl/cancel_ride_by_driver';
const String checkCancelRideDriverUrl = '$_baseUrl/check_cancellation_reason_on_driver';
const String getRideCancellationReasonsUrl = '$_baseUrl/get_cancellation_reason';
const String declineRideByDriverUrl = '$_baseUrl/decline_ride_by_driver';
const String changeRideStatusUrl = '$_baseUrl/ride_status_changed';
const String generateOtpUrl = '$_baseUrl/generate_otp';
const String otpVerifyDriverUrl = '$_baseUrl/otp_verify_ride_by_driver';
const String endRideDriverUrl = '$_baseUrl/end_ride_by_driver';
const String findNearbyDriverUrl = '$_baseUrl/find_driver';

//* Customer
const String createUrbanRequestUrl = '$_baseUrl/add_urban_booking';
const String createRuralRequestUrl = '$_baseUrl/add_rural_booking';
const String getCustomerBookingsUrl = '$_baseUrl/get_customer_bookings';
const String getPackagingTypeUrl = '$_baseUrl/get_package_type';
const String getQuantityUrl = '$_baseUrl/get_qty_master';

//* Settings

const String updateProfileUrl = '$_baseUrl/update_profile_data';
const String commonSendNotificationUrl = '$_baseUrl/common_send_notification';
