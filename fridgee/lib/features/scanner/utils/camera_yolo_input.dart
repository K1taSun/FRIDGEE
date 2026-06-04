// Bezpośrednio CameraImage (YUV/NV21) → bufor NCHW 320×320 (bez pełnego obrazu RGB).

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

const int kYoloInputSize = 320;

/// Wypełnia [buffer] (3×320×320, NCHW, 0..1) — center crop + skalowanie.
bool fillYoloInputFromCamera(CameraImage image, Float32List buffer) {
  if (buffer.length != 3 * kYoloInputSize * kYoloInputSize) return false;

  final w = image.width;
  final h = image.height;
  final minSide = w < h ? w : h;
  final x0 = (w - minSide) ~/ 2;
  final y0 = (h - minSide) ~/ 2;

  if (Platform.isIOS && image.planes.length == 1) {
    return _fillFromBgra(image, buffer, x0, y0, minSide);
  }
  if (image.planes.length >= 3) {
    return _fillFromYuv420(image, buffer, x0, y0, minSide);
  }
  if (image.planes.length == 2) {
    return _fillFromYuv420TwoPlane(image, buffer, x0, y0, minSide);
  }
  if (image.planes.length == 1) {
    return _fillFromNv21(image, buffer, x0, y0, minSide);
  }
  debugPrint('[YoloInput] Nieobsługiwany format: planes=${image.planes.length}');
  return false;
}

void _writeRgb(
  Float32List buffer,
  int ox,
  int oy,
  int r,
  int g,
  int b,
) {
  final planeSize = kYoloInputSize * kYoloInputSize;
  final idx = oy * kYoloInputSize + ox;
  buffer[idx] = r / 255.0;
  buffer[planeSize + idx] = g / 255.0;
  buffer[2 * planeSize + idx] = b / 255.0;
}

void _yuvToRgb(int y, int u, int v, List<int> out) {
  final yf = y - 16;
  final uf = u - 128;
  final vf = v - 128;
  out[0] = (1.164 * yf + 1.596 * vf).round().clamp(0, 255);
  out[1] = (1.164 * yf - 0.392 * uf - 0.813 * vf).round().clamp(0, 255);
  out[2] = (1.164 * yf + 2.017 * uf).round().clamp(0, 255);
}

final List<int> _rgbScratch = List<int>.filled(3, 0);

bool _fillFromNv21(
  CameraImage image,
  Float32List buffer,
  int x0,
  int y0,
  int minSide,
) {
  final plane = image.planes.first;
  final bytes = plane.bytes;
  final yRowStride = plane.bytesPerRow;
  final h = image.height;
  final ySize = yRowStride * h;

  for (var oy = 0; oy < kYoloInputSize; oy++) {
    final sy = y0 + (oy * minSide ~/ kYoloInputSize);
    for (var ox = 0; ox < kYoloInputSize; ox++) {
      final sx = x0 + (ox * minSide ~/ kYoloInputSize);
      final yIndex = sy * yRowStride + sx;
      if (yIndex >= bytes.length) continue;

      final uvRow = sy ~/ 2;
      final uvCol = sx ~/ 2;
      final uvIndex = ySize + uvRow * yRowStride + uvCol * 2;
      if (uvIndex + 1 >= bytes.length) continue;

      _yuvToRgb(bytes[yIndex], bytes[uvIndex + 1], bytes[uvIndex], _rgbScratch);
      _writeRgb(buffer, ox, oy, _rgbScratch[0], _rgbScratch[1], _rgbScratch[2]);
    }
  }
  return true;
}

bool _fillFromYuv420(
  CameraImage image,
  Float32List buffer,
  int x0,
  int y0,
  int minSide,
) {
  final yPlane = image.planes[0];
  final uPlane = image.planes[1];
  final vPlane = image.planes[2];
  final uvPixelStride = uPlane.bytesPerPixel ?? 1;

  for (var oy = 0; oy < kYoloInputSize; oy++) {
    final sy = y0 + (oy * minSide ~/ kYoloInputSize);
    for (var ox = 0; ox < kYoloInputSize; ox++) {
      final sx = x0 + (ox * minSide ~/ kYoloInputSize);
      final yIndex = sy * yPlane.bytesPerRow + sx;
      if (yIndex >= yPlane.bytes.length) continue;

      final uvRow = sy ~/ 2;
      final uvCol = sx ~/ 2;
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
      _yuvToRgb(yVal, uVal, vVal, _rgbScratch);
      _writeRgb(buffer, ox, oy, _rgbScratch[0], _rgbScratch[1], _rgbScratch[2]);
    }
  }
  return true;
}

bool _fillFromYuv420TwoPlane(
  CameraImage image,
  Float32List buffer,
  int x0,
  int y0,
  int minSide,
) {
  final yPlane = image.planes[0];
  final uvPlane = image.planes[1];
  final uvPixelStride = uvPlane.bytesPerPixel ?? 2;

  for (var oy = 0; oy < kYoloInputSize; oy++) {
    final sy = y0 + (oy * minSide ~/ kYoloInputSize);
    for (var ox = 0; ox < kYoloInputSize; ox++) {
      final sx = x0 + (ox * minSide ~/ kYoloInputSize);
      final yIndex = sy * yPlane.bytesPerRow + sx;
      if (yIndex >= yPlane.bytes.length) continue;

      final uvRow = sy ~/ 2;
      final uvCol = sx ~/ 2;
      final uvIndex = uvRow * uvPlane.bytesPerRow + uvCol * uvPixelStride;
      if (uvIndex + 1 >= uvPlane.bytes.length) continue;

      _yuvToRgb(
        yPlane.bytes[yIndex],
        uvPlane.bytes[uvIndex],
        uvPlane.bytes[uvIndex + 1],
        _rgbScratch,
      );
      _writeRgb(buffer, ox, oy, _rgbScratch[0], _rgbScratch[1], _rgbScratch[2]);
    }
  }
  return true;
}

bool _fillFromBgra(
  CameraImage image,
  Float32List buffer,
  int x0,
  int y0,
  int minSide,
) {
  final plane = image.planes.first;
  final rowStride = plane.bytesPerRow;

  for (var oy = 0; oy < kYoloInputSize; oy++) {
    final sy = y0 + (oy * minSide ~/ kYoloInputSize);
    for (var ox = 0; ox < kYoloInputSize; ox++) {
      final sx = x0 + (ox * minSide ~/ kYoloInputSize);
      final offset = sy * rowStride + sx * 4;
      if (offset + 3 >= plane.bytes.length) continue;
      _writeRgb(
        buffer,
        ox,
        oy,
        plane.bytes[offset + 2],
        plane.bytes[offset + 1],
        plane.bytes[offset],
      );
    }
  }
  return true;
}
