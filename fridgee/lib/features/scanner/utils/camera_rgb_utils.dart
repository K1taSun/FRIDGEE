// Konwersja CameraImage (YUV420 / BGRA) → RGB do inferencji YOLO.

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Zwraca obraz RGB lub null przy nieobsługiwanym formacie.
img.Image? cameraImageToRgb(CameraImage cameraImage) {
  if (Platform.isIOS && cameraImage.planes.length == 1) {
    return _bgraToRgb(cameraImage);
  }
  if (cameraImage.planes.length >= 3) {
    return _yuv420ToRgb(cameraImage);
  }
  if (cameraImage.planes.length == 2) {
    return _yuv420TwoPlaneToRgb(cameraImage);
  }
  if (cameraImage.planes.length == 1) {
    return _nv21ToRgb(cameraImage);
  }
  debugPrint('[CameraRGB] Nieobsługiwany format: planes=${cameraImage.planes.length}');
  return null;
}

img.Image _bgraToRgb(CameraImage cameraImage) {
  final plane = cameraImage.planes.first;
  final width = cameraImage.width;
  final height = cameraImage.height;
  final rowStride = plane.bytesPerRow;
  final image = img.Image(width: width, height: height);

  for (var y = 0; y < height; y++) {
    final rowStart = y * rowStride;
    for (var x = 0; x < width; x++) {
      final offset = rowStart + x * 4;
      if (offset + 3 >= plane.bytes.length) continue;
      final b = plane.bytes[offset];
      final g = plane.bytes[offset + 1];
      final r = plane.bytes[offset + 2];
      image.setPixelRgb(x, y, r, g, b);
    }
  }
  return image;
}

img.Image _yuv420ToRgb(CameraImage cameraImage) {
  final width = cameraImage.width;
  final height = cameraImage.height;
  final yPlane = cameraImage.planes[0];
  final uPlane = cameraImage.planes[1];
  final vPlane = cameraImage.planes[2];
  final uvPixelStride = uPlane.bytesPerPixel ?? 1;

  final image = img.Image(width: width, height: height);
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final yIndex = y * yPlane.bytesPerRow + x;
      if (yIndex >= yPlane.bytes.length) continue;

      final uvRow = y ~/ 2;
      final uvCol = x ~/ 2;
      final uvIndex = uvRow * uPlane.bytesPerRow + uvCol * uvPixelStride;

      final yVal = yPlane.bytes[yIndex];
      int uVal;
      int vVal;
      if (uvPixelStride == 2) {
        if (uvIndex + 1 >= uPlane.bytes.length) continue;
        uVal = uPlane.bytes[uvIndex];
        vVal = uPlane.bytes[uvIndex + 1];
      } else {
        if (uvIndex >= uPlane.bytes.length || uvIndex >= vPlane.bytes.length) continue;
        uVal = uPlane.bytes[uvIndex];
        vVal = vPlane.bytes[uvIndex];
      }

      final rgb = _yuvToRgb(yVal, uVal, vVal);
      image.setPixelRgb(x, y, rgb[0], rgb[1], rgb[2]);
    }
  }
  return image;
}

/// Android: czasem Y + UV w jednym buforze (2 plane).
img.Image _yuv420TwoPlaneToRgb(CameraImage cameraImage) {
  final width = cameraImage.width;
  final height = cameraImage.height;
  final yPlane = cameraImage.planes[0];
  final uvPlane = cameraImage.planes[1];
  final uvPixelStride = uvPlane.bytesPerPixel ?? 2;
  final image = img.Image(width: width, height: height);

  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final yIndex = y * yPlane.bytesPerRow + x;
      if (yIndex >= yPlane.bytes.length) continue;

      final uvRow = y ~/ 2;
      final uvCol = x ~/ 2;
      final uvIndex = uvRow * uvPlane.bytesPerRow + uvCol * uvPixelStride;
      if (uvIndex + 1 >= uvPlane.bytes.length) continue;

      final yVal = yPlane.bytes[yIndex];
      final uVal = uvPlane.bytes[uvIndex];
      final vVal = uvPlane.bytes[uvIndex + 1];
      final rgb = _yuvToRgb(yVal, uVal, vVal);
      image.setPixelRgb(x, y, rgb[0], rgb[1], rgb[2]);
    }
  }
  return image;
}

img.Image _nv21ToRgb(CameraImage cameraImage) {
  final width = cameraImage.width;
  final height = cameraImage.height;
  final plane = cameraImage.planes.first;
  final bytes = plane.bytes;
  final yRowStride = plane.bytesPerRow;
  final image = img.Image(width: width, height: height);
  final ySize = yRowStride * height;

  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final yIndex = y * yRowStride + x;
      if (yIndex >= bytes.length) continue;

      final uvRow = y ~/ 2;
      final uvCol = x ~/ 2;
      final uvIndex = ySize + uvRow * yRowStride + uvCol * 2;
      if (uvIndex + 1 >= bytes.length) continue;

      final yVal = bytes[yIndex];
      final vVal = bytes[uvIndex];
      final uVal = bytes[uvIndex + 1];
      final rgb = _yuvToRgb(yVal, uVal, vVal);
      image.setPixelRgb(x, y, rgb[0], rgb[1], rgb[2]);
    }
  }
  return image;
}

List<int> _yuvToRgb(int y, int u, int v) {
  final yf = y - 16;
  final uf = u - 128;
  final vf = v - 128;
  var r = (1.164 * yf + 1.596 * vf).round().clamp(0, 255);
  var g = (1.164 * yf - 0.392 * uf - 0.813 * vf).round().clamp(0, 255);
  var b = (1.164 * yf + 2.017 * uf).round().clamp(0, 255);
  return [r, g, b];
}
