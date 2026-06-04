// Konwersja klatek CameraImage → InputImage (ML Kit) — Android NV21 / YUV420, iOS BGRA.

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

InputImage? inputImageFromCameraImage(
  CameraImage image,
  CameraDescription camera,
) {
  final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
  if (rotation == null) return null;

  if (Platform.isAndroid) {
    return _androidInputImage(image, rotation);
  }
  if (Platform.isIOS) {
    return _iosInputImage(image, rotation);
  }
  return null;
}

InputImage? _androidInputImage(CameraImage image, InputImageRotation rotation) {
  final format = InputImageFormatValue.fromRawValue(image.format.raw);

  if (format == InputImageFormat.nv21 && image.planes.length == 1) {
    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.nv21,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  if (image.planes.length >= 3) {
    final nv21 = _yuv420ToNv21(image);
    return InputImage.fromBytes(
      bytes: nv21,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.nv21,
        bytesPerRow: image.width,
      ),
    );
  }

  debugPrint('[CameraImage] Nieobsługiwany format Android: $format, planes=${image.planes.length}');
  return null;
}

InputImage? _iosInputImage(CameraImage image, InputImageRotation rotation) {
  if (image.planes.length != 1) return null;
  final plane = image.planes.first;
  return InputImage.fromBytes(
    bytes: plane.bytes,
    metadata: InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: InputImageFormat.bgra8888,
      bytesPerRow: plane.bytesPerRow,
    ),
  );
}

Uint8List _yuv420ToNv21(CameraImage image) {
  final width = image.width;
  final height = image.height;
  final yPlane = image.planes[0];
  final uPlane = image.planes[1];
  final vPlane = image.planes[2];
  final uvPixelStride = uPlane.bytesPerPixel ?? 1;

  final nv21 = Uint8List(width * height + (width * height ~/ 2));
  var offset = 0;

  for (var row = 0; row < height; row++) {
    final rowStart = row * yPlane.bytesPerRow;
    nv21.setRange(offset, offset + width, yPlane.bytes, rowStart);
    offset += width;
  }

  final uvHeight = height ~/ 2;
  final uvWidth = width ~/ 2;
  for (var row = 0; row < uvHeight; row++) {
    for (var col = 0; col < uvWidth; col++) {
      final uvIndex = row * uPlane.bytesPerRow + col * uvPixelStride;
      nv21[offset++] = vPlane.bytes[uvIndex];
      nv21[offset++] = uPlane.bytes[uvIndex];
    }
  }

  return nv21;
}
