// Non-Maximum Suppression dla wyjścia YOLOv8 ONNX (Ultralytics).

import 'dart:math';

class YoloDetection {
  const YoloDetection({
    required this.classIndex,
    required this.score,
    required this.bboxXywh,
  });

  final int classIndex;
  final double score;
  final List<double> bboxXywh;
}

/// [rawOutput] — tensor [4 + numClasses][numPredictions] (domyślnie 8400).
List<YoloDetection> yoloNonMaxSuppression(
  List<List<double>> rawOutput, {
  required int numClasses,
  double confidenceThreshold = 0.35,
  double iouThreshold = 0.45,
  double maxBoxCoord = 640,
  /// Minimalny udział powierzchni bbox względem [maxBoxCoord]² (mniej = mniejsze obiekty).
  double minBoxAreaRatio = 0.04,
}) {
  final numFeatures = rawOutput.length;
  if (numFeatures < 5) return const [];

  final numPredictions = rawOutput.first.length;
  final candidates = <YoloDetection>[];

  for (var i = 0; i < numPredictions; i++) {
    final cx = rawOutput[0][i];
    final cy = rawOutput[1][i];
    final w = rawOutput[2][i];
    final h = rawOutput[3][i];

    // Odrzuć predykcje z nierealistycznymi współrzędnymi lub zbyt małym obszarem.
    if (w <= 0 || h <= 0 || w > maxBoxCoord || h > maxBoxCoord) continue;
    if (cx.abs() > maxBoxCoord || cy.abs() > maxBoxCoord) continue;
    if (w * h < maxBoxCoord * maxBoxCoord * minBoxAreaRatio) continue;

    var bestScore = 0.0;
    var bestCls = -1;
    for (var c = 0; c < numClasses; c++) {
      final featureIdx = 4 + c;
      if (featureIdx >= numFeatures) break;
      final score = _classScore(rawOutput[featureIdx][i]);
      if (score > bestScore) {
        bestScore = score;
        bestCls = c;
      }
    }
    if (bestCls >= 0 && bestScore >= confidenceThreshold) {
      candidates.add(YoloDetection(
        classIndex: bestCls,
        score: bestScore,
        bboxXywh: [cx, cy, w, h],
      ));
    }
  }

  candidates.sort((a, b) => b.score.compareTo(a.score));

  final kept = <YoloDetection>[];
  final suppressed = List<bool>.filled(candidates.length, false);

  for (var i = 0; i < candidates.length; i++) {
    if (suppressed[i]) continue;
    kept.add(candidates[i]);
    final boxA = _xywhToXyxy(candidates[i].bboxXywh);
    for (var j = i + 1; j < candidates.length; j++) {
      if (suppressed[j]) continue;
      if (candidates[i].classIndex != candidates[j].classIndex) continue;
      final iou = _computeIou(boxA, _xywhToXyxy(candidates[j].bboxXywh));
      if (iou > iouThreshold) suppressed[j] = true;
    }
  }

  return kept;
}

List<double> _xywhToXyxy(List<double> bbox) {
  final halfW = bbox[2] / 2;
  final halfH = bbox[3] / 2;
  return [bbox[0] - halfW, bbox[1] - halfH, bbox[0] + halfW, bbox[1] + halfH];
}

/// Logity YOLOv8 → prawdopodobieństwo; wartości już w [0,1] pozostaw bez zmian.
double _classScore(double raw) {
  if (raw >= 0 && raw <= 1) return raw;
  return 1 / (1 + exp(-raw));
}

double _computeIou(List<double> a, List<double> b) {
  final xLeft = max(a[0], b[0]);
  final yTop = max(a[1], b[1]);
  final xRight = min(a[2], b[2]);
  final yBottom = min(a[3], b[3]);
  if (xRight <= xLeft || yBottom <= yTop) return 0;
  final intersection = (xRight - xLeft) * (yBottom - yTop);
  final areaA = (a[2] - a[0]) * (a[3] - a[1]);
  final areaB = (b[2] - b[0]) * (b[3] - b[1]);
  return intersection / (areaA + areaB - intersection);
}
