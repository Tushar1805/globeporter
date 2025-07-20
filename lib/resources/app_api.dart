const String _baseUrl = 'https://globeporter.com/public/api/user';
const String _placesBaseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
const String _directionsbaseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

//* Places API's

const String searchPlacesUrl = '$_placesBaseUrl?input=';
const String routeDirectionUrl = '$_directionsbaseUrl?origin=';

//* Authentication

const String loginUrl = '$_baseUrl/login';
const String registerUrl = '$_baseUrl/register';
const String otpVerificationUrl = '$_baseUrl/otp_verify';
const String deleteUserUrl = '$_baseUrl/delete_user_account';
const String getUserUrl = '$_baseUrl/get_user';
const String logoutUrl = '$_baseUrl/logout';
const String updateUserTypeUrl = '$_baseUrl/user_type_update';
