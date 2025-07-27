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
// const String submitOwnerVehicleDriverDetailsUrl = '$_baseUrl/update_user_vehicle_details';
const String submitOwnerDetailsUrl = '$_baseUrl/update_user_owner_vehicle_details';
const String submitDriverDetailsUrl = '$_baseUrl/update_user_driver_vehicle_details';
const String submitVehicleDetailsUrl = '$_baseUrl/update_user_vehicle_details';
const String getVerificationStatusUrl = '$_baseUrl/get_verification_status';

//* Driver

const String getOwnerDetailsUrl = '$_baseUrl/get_owner_details';
const String getVehicleDetailsUrl = '$_baseUrl/get_vehicle_details';
const String getDriverDetailsUrl = '$_baseUrl/get_driver_details';
const String reSubmitDocumetsUser = '$_baseUrl/common_update_user_vehicle_details';
