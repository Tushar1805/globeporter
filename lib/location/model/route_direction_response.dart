class RouteDirectionsResponse {
  final List<GeocodedWaypoints>? geocodedWaypoints;
  final List<Routes>? routes;
  final String? status;

  RouteDirectionsResponse({
    this.geocodedWaypoints,
    this.routes,
    this.status,
  });

  RouteDirectionsResponse.fromJson(final Map<String, dynamic>? json)
      : geocodedWaypoints = (json?['geocoded_waypoints'] as List?)
            ?.map((dynamic e) => GeocodedWaypoints.fromJson(e as Map<String, dynamic>))
            .toList(),
        routes = (json?['routes'] as List?)
            ?.map((dynamic e) => Routes.fromJson(e as Map<String, dynamic>))
            .toList(),
        status = json?['status'] as String?;

  Map<String, dynamic> toJson() => {
        'geocoded_waypoints': geocodedWaypoints?.map((e) => e.toJson()).toList(),
        'routes': routes?.map((e) => e.toJson()).toList(),
        'status': status
      };
}

class GeocodedWaypoints {
  final String? geocoderStatus;
  final String? placeId;
  final List<String>? types;

  GeocodedWaypoints({
    this.geocoderStatus,
    this.placeId,
    this.types,
  });

  GeocodedWaypoints.fromJson(final Map<String, dynamic>? json)
      : geocoderStatus = json?['geocoder_status'] as String?,
        placeId = json?['place_id'] as String?,
        types = (json?['types'] as List?)?.map((dynamic e) => e as String).toList();

  Map<String, dynamic> toJson() =>
      {'geocoder_status': geocoderStatus, 'place_id': placeId, 'types': types};
}

class Routes {
  final Bounds? bounds;
  final String? copyrights;
  final List<Legs>? legs;
  final OverviewPolyline? overviewPolyline;
  final String? summary;
  final List<dynamic>? warnings;
  final List<dynamic>? waypointOrder;

  Routes({
    this.bounds,
    this.copyrights,
    this.legs,
    this.overviewPolyline,
    this.summary,
    this.warnings,
    this.waypointOrder,
  });

  Routes.fromJson(final Map<String, dynamic>? json)
      : bounds = (json?['bounds'] as Map<String, dynamic>?) != null
            ? Bounds.fromJson(json?['bounds'] as Map<String, dynamic>)
            : null,
        copyrights = json?['copyrights'] as String?,
        legs = (json?['legs'] as List?)
            ?.map((dynamic e) => Legs.fromJson(e as Map<String, dynamic>))
            .toList(),
        overviewPolyline = (json?['overview_polyline'] as Map<String, dynamic>?) != null
            ? OverviewPolyline.fromJson(json?['overview_polyline'] as Map<String, dynamic>)
            : null,
        summary = json?['summary'] as String?,
        warnings = json?['warnings'] as List?,
        waypointOrder = json?['waypoint_order'] as List?;

  Map<String, dynamic> toJson() => {
        'bounds': bounds?.toJson(),
        'copyrights': copyrights,
        'legs': legs?.map((e) => e.toJson()).toList(),
        'overview_polyline': overviewPolyline?.toJson(),
        'summary': summary,
        'warnings': warnings,
        'waypoint_order': waypointOrder
      };
}

class Bounds {
  final Northeast? northeast;
  final Southwest? southwest;

  Bounds({
    this.northeast,
    this.southwest,
  });

  Bounds.fromJson(final Map<String, dynamic>? json)
      : northeast = (json?['northeast'] as Map<String, dynamic>?) != null
            ? Northeast.fromJson(json?['northeast'] as Map<String, dynamic>)
            : null,
        southwest = (json?['southwest'] as Map<String, dynamic>?) != null
            ? Southwest.fromJson(json?['southwest'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'northeast': northeast?.toJson(), 'southwest': southwest?.toJson()};
}

class Northeast {
  final double? lat;
  final double? lng;

  Northeast({
    this.lat,
    this.lng,
  });

  Northeast.fromJson(final Map<String, dynamic>? json)
      : lat = json?['lat'] as double?,
        lng = json?['lng'] as double?;

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

class Southwest {
  final double? lat;
  final double? lng;

  Southwest({
    this.lat,
    this.lng,
  });

  Southwest.fromJson(final Map<String, dynamic>? json)
      : lat = json?['lat'] as double?,
        lng = json?['lng'] as double?;

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

class Legs {
  final Distance? distance;
  final Duration? duration;
  final String? endAddress;
  final EndLocation? endLocation;
  final String? startAddress;
  final StartLocation? startLocation;
  final List<Steps>? steps;
  final List<dynamic>? trafficSpeedEntry;
  final List<dynamic>? viaWaypoint;

  Legs({
    this.distance,
    this.duration,
    this.endAddress,
    this.endLocation,
    this.startAddress,
    this.startLocation,
    this.steps,
    this.trafficSpeedEntry,
    this.viaWaypoint,
  });

  Legs.fromJson(final Map<String, dynamic>? json)
      : distance = (json?['distance'] as Map<String, dynamic>?) != null
            ? Distance.fromJson(json?['distance'] as Map<String, dynamic>)
            : null,
        duration = (json?['duration'] as Map<String, dynamic>?) != null
            ? Duration.fromJson(json?['duration'] as Map<String, dynamic>)
            : null,
        endAddress = json?['end_address'] as String?,
        endLocation = (json?['end_location'] as Map<String, dynamic>?) != null
            ? EndLocation.fromJson(json?['end_location'] as Map<String, dynamic>)
            : null,
        startAddress = json?['start_address'] as String?,
        startLocation = (json?['start_location'] as Map<String, dynamic>?) != null
            ? StartLocation.fromJson(json?['start_location'] as Map<String, dynamic>)
            : null,
        steps = (json?['steps'] as List?)
            ?.map((dynamic e) => Steps.fromJson(e as Map<String, dynamic>))
            .toList(),
        trafficSpeedEntry = json?['traffic_speed_entry'] as List?,
        viaWaypoint = json?['via_waypoint'] as List?;

  Map<String, dynamic> toJson() => {
        'distance': distance?.toJson(),
        'duration': duration?.toJson(),
        'end_address': endAddress,
        'end_location': endLocation?.toJson(),
        'start_address': startAddress,
        'start_location': startLocation?.toJson(),
        'steps': steps?.map((e) => e.toJson()).toList(),
        'traffic_speed_entry': trafficSpeedEntry,
        'via_waypoint': viaWaypoint
      };
}

class Distance {
  final String? text;
  final int? value;

  Distance({
    this.text,
    this.value,
  });

  Distance.fromJson(final Map<String, dynamic>? json)
      : text = json?['text'] as String?,
        value = json?['value'] as int?;

  Map<String, dynamic> toJson() => {'text': text, 'value': value};
}

class Duration {
  final String? text;
  final int? value;

  Duration({
    this.text,
    this.value,
  });

  Duration.fromJson(final Map<String, dynamic>? json)
      : text = json?['text'] as String?,
        value = json?['value'] as int?;

  Map<String, dynamic> toJson() => {'text': text, 'value': value};
}

class EndLocation {
  final double? lat;
  final double? lng;

  EndLocation({
    this.lat,
    this.lng,
  });

  EndLocation.fromJson(final Map<String, dynamic>? json)
      : lat = json?['lat'] as double?,
        lng = json?['lng'] as double?;

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

class StartLocation {
  final double? lat;
  final double? lng;

  StartLocation({
    this.lat,
    this.lng,
  });

  StartLocation.fromJson(final Map<String, dynamic>? json)
      : lat = json?['lat'] as double?,
        lng = json?['lng'] as double?;

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

class Steps {
  final Distance? distance;
  final Duration? duration;
  final EndLocation? endLocation;
  final String? htmlInstructions;
  final Polyline? polyline;
  final StartLocation? startLocation;
  final String? travelMode;

  Steps({
    this.distance,
    this.duration,
    this.endLocation,
    this.htmlInstructions,
    this.polyline,
    this.startLocation,
    this.travelMode,
  });

  Steps.fromJson(final Map<String, dynamic>? json)
      : distance = (json?['distance'] as Map<String, dynamic>?) != null
            ? Distance.fromJson(json?['distance'] as Map<String, dynamic>)
            : null,
        duration = (json?['duration'] as Map<String, dynamic>?) != null
            ? Duration.fromJson(json?['duration'] as Map<String, dynamic>)
            : null,
        endLocation = (json?['end_location'] as Map<String, dynamic>?) != null
            ? EndLocation.fromJson(json?['end_location'] as Map<String, dynamic>)
            : null,
        htmlInstructions = json?['html_instructions'] as String?,
        polyline = (json?['polyline'] as Map<String, dynamic>?) != null
            ? Polyline.fromJson(json?['polyline'] as Map<String, dynamic>)
            : null,
        startLocation = (json?['start_location'] as Map<String, dynamic>?) != null
            ? StartLocation.fromJson(json?['start_location'] as Map<String, dynamic>)
            : null,
        travelMode = json?['travel_mode'] as String?;

  Map<String, dynamic> toJson() => {
        'distance': distance?.toJson(),
        'duration': duration?.toJson(),
        'end_location': endLocation?.toJson(),
        'html_instructions': htmlInstructions,
        'polyline': polyline?.toJson(),
        'start_location': startLocation?.toJson(),
        'travel_mode': travelMode
      };
}

class Polyline {
  final String? points;

  Polyline({
    this.points,
  });

  Polyline.fromJson(final Map<String, dynamic>? json) : points = json?['points'] as String?;

  Map<String, dynamic> toJson() => {'points': points};
}

class OverviewPolyline {
  final String? points;

  OverviewPolyline({
    this.points,
  });

  OverviewPolyline.fromJson(final Map<String, dynamic>? json) : points = json?['points'] as String?;

  Map<String, dynamic> toJson() => {'points': points};
}
