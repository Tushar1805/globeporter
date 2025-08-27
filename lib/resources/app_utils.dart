import 'dart:ui' as ui;
import 'dart:convert';

import 'package:core/utils/core_utils.dart';
import 'package:country_phone_validator/country_phone_validator.dart';
import 'package:flutter/services.dart';
import 'package:globeporter/resources/app_api_keys.dart';
import 'package:globeporter/resources/app_images.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

Future<Uint8List> getBytesFromAssets({required final String path, required final int width}) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
  ui.FrameInfo fi = await codec.getNextFrame();

  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
}

List<LatLng> decodePolyline(String encoded) {
  List<LatLng> points = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dLat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
    lat += dLat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dLng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
    lng += dLng;

    points.add(LatLng(lat / 1e5, lng / 1e5));
  }

  return points;
}

bool isPhoneValid({
  required final String phone,
  required final String dialCode,
}) {
  customPrint("Entered to validate phone number");
  final isValid = CountryUtils.validatePhoneNumber(phone, dialCode);

  customPrint("$dialCode $phone : isValid: $isValid");
  return isValid;
}

String formatDate({required final String date}) {
  return DateFormat('dd MMMM').format(
    DateTime.parse(
      date,
    ),
  );
}

Future<Marker> getMarker(
    {required final String vehicleType,
    required final MarkerId markerId,
    required final LatLng position,
    required final String info}) async {
  final truck = await getBytesFromAssets(path: truckIcon, width: 50);
  final auto = await getBytesFromAssets(path: autoIcon, width: 50);
  if (vehicleType.toLowerCase().contains('auto')) {
    return Marker(
      markerId: markerId,
      position: position,
      icon: BitmapDescriptor.bytes(auto),
      infoWindow: InfoWindow(title: info),
    );
  } else {
    return Marker(
      markerId: markerId,
      position: position,
      icon: BitmapDescriptor.bytes(truck),
      infoWindow: InfoWindow(title: info),
    );
  }
}

class UrbanityChecker {
  static const String _apiKey = googleMapAPIKey;
  static const String _baseUrl = "https://areainsights.googleapis.com/v1:computeInsights";

  /// Get aggregate count of POIs for selected types within radius
  static Future<String> getPlaceDensity(double lat, double lng, {int radius = 500}) async {
    final body = {
      "insights": ["INSIGHT_COUNT"],
      "filter": {
        "locationFilter": {
          "circle": {
            "latLng": {"latitude": lat, "longitude": lng},
            "radius": radius
          }
        },
        "typeFilter": {
          "includedTypes": ["restaurant", "cafe"]
        }
      }
    };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": _apiKey,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch aggregate: ${response.body}");
    }

    final data = json.decode(response.body);
    customPrint("Aggregate Data: $data ");
    final count = data["count"] ?? "0";
    return count;
  }

  /// Infer urbanity based on POI density
  static Future<String> inferUrbanity(double lat, double lng, {int radius = 3000}) async {
    final density = await getPlaceDensity(lat, lng, radius: radius);

    int count = (int.tryParse(density) ?? 0);

    if (count > 50) {
      return "Urban (POIs found in distance $radius: $count)";
    }
    //  else if (count > 15) {
    //   return "Semi-urban (POIs found: $count)";
    // }
    else {
      return "Rural (POIs found in distance $radius: $count)";
    }
  }
}
