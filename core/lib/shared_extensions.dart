import 'package:flutter/widgets.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or
  /// "ffaabbcc" with an optional leading "#".
  static Color fromHex(final String hex) {
    final String hexString = hex.replaceAll(';', '');
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign]
  /// is set to `true` (default is `true`).
  String toHex({final bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  static Color darken(final String hexString, [final double amount = .1]) {
    final color = fromHex(hexString);

    assert(amount >= 0 && amount <= 1, 'invalid amount');

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(final String hexString, [final double amount = .1]) {
    final Color color = fromHex(hexString);
    assert(amount >= 0 && amount <= 1, 'invalid amount');

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

/// generic extension function to update an item of list
extension ListUpdate<T> on List {
  List update(final int pos, final T t) {
    final List<T> list = <T>[];
    list.add(t);
    replaceRange(pos, pos + 1, list);

    return this;
  }
}

extension TestStringPresence on String {
  bool checkStringPresence(final String subString) => contains(subString);
}

extension ObjectExt<T> on T {
  R let<R>(final R Function(T that) op) => op(this);
}
