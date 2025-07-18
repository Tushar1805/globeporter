import 'dart:ui' as ui;

import 'package:flutter/services.dart';

Future<Uint8List> getBytesFromAssets({required final String path, required final int width}) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
  ui.FrameInfo fi = await codec.getNextFrame();

  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
}
