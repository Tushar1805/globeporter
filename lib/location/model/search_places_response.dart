class SearchPlacesResponse {
  final List<Predictions>? predictions;

  SearchPlacesResponse({
    this.predictions,
  });

  SearchPlacesResponse.fromJson(Map<String, dynamic>? json)
      : predictions = (json?['predictions'] as List?)
            ?.map((dynamic e) => Predictions.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {'predictions': predictions?.map((e) => e.toJson()).toList()};
}

class Predictions {
  final String? description;
  final List<MatchedSubstrings>? matchedSubstrings;
  final String? placeId;
  final String? reference;
  final StructuredFormatting? structuredFormatting;
  final List<Terms>? terms;
  final List<String>? types;

  Predictions({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.terms,
    this.types,
  });

  Predictions.fromJson(Map<String, dynamic>? json)
      : description = json?['description'] as String?,
        matchedSubstrings = (json?['matched_substrings'] as List?)
            ?.map((dynamic e) => MatchedSubstrings.fromJson(e as Map<String, dynamic>))
            .toList(),
        placeId = json?['place_id'] as String?,
        reference = json?['reference'] as String?,
        structuredFormatting = (json?['structured_formatting'] as Map<String, dynamic>?) != null
            ? StructuredFormatting.fromJson(json?['structured_formatting'] as Map<String, dynamic>)
            : null,
        terms = (json?['terms'] as List?)
            ?.map((dynamic e) => Terms.fromJson(e as Map<String, dynamic>))
            .toList(),
        types = (json?['types'] as List?)?.map((dynamic e) => e as String).toList();

  Map<String, dynamic> toJson() => {
        'description': description,
        'matched_substrings': matchedSubstrings?.map((e) => e.toJson()).toList(),
        'place_id': placeId,
        'reference': reference,
        'structured_formatting': structuredFormatting?.toJson(),
        'terms': terms?.map((e) => e.toJson()).toList(),
        'types': types
      };
}

class MatchedSubstrings {
  final int? length;
  final int? offset;

  MatchedSubstrings({
    this.length,
    this.offset,
  });

  MatchedSubstrings.fromJson(Map<String, dynamic>? json)
      : length = json?['length'] as int?,
        offset = json?['offset'] as int?;

  Map<String, dynamic> toJson() => {'length': length, 'offset': offset};
}

class StructuredFormatting {
  final String? mainText;
  final List<MainTextMatchedSubstrings>? mainTextMatchedSubstrings;

  StructuredFormatting({
    this.mainText,
    this.mainTextMatchedSubstrings,
  });

  StructuredFormatting.fromJson(Map<String, dynamic>? json)
      : mainText = json?['main_text'] as String?,
        mainTextMatchedSubstrings = (json?['main_text_matched_substrings'] as List?)
            ?.map((dynamic e) => MainTextMatchedSubstrings.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'main_text': mainText,
        'main_text_matched_substrings': mainTextMatchedSubstrings?.map((e) => e.toJson()).toList()
      };
}

class MainTextMatchedSubstrings {
  final int? length;
  final int? offset;

  MainTextMatchedSubstrings({
    this.length,
    this.offset,
  });

  MainTextMatchedSubstrings.fromJson(Map<String, dynamic>? json)
      : length = json?['length'] as int?,
        offset = json?['offset'] as int?;

  Map<String, dynamic> toJson() => {'length': length, 'offset': offset};
}

class Terms {
  final int? offset;
  final String? value;

  Terms({
    this.offset,
    this.value,
  });

  Terms.fromJson(Map<String, dynamic>? json)
      : offset = json?['offset'] as int?,
        value = json?['value'] as String?;

  Map<String, dynamic> toJson() => {'offset': offset, 'value': value};
}
