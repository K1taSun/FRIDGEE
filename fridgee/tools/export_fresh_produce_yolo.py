#!/usr/bin/env python3
"""Pobiera wagi YOLOv8 (63 klasy owoców/warzyw) i eksportuje do ONNX dla Fridgee.

TensorFlow/TFLite wymaga Pythona <= 3.12 — na nowszych wersjach używamy ONNX.

    py -3 -m pip install ultralytics gdown onnx onnxslim onnxruntime
    py -3 tools/export_fresh_produce_yolo.py
"""

from __future__ import annotations

import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "assets" / "models"
GDRIVE_FOLDER = "https://drive.google.com/drive/folders/1I4mtQK11C3p41pO9raR0trgPVj0eQ2yb"
PREFERRED_WEIGHTS = (
    "yolo_fruits_and_vegetables_v1.pt",
    "yolov8m.pt",
    "best.pt",
)


def main() -> int:
    try:
        import gdown
        from ultralytics import YOLO
    except ImportError:
        print("Zainstaluj: py -3 -m pip install ultralytics gdown onnx onnxslim onnxruntime")
        return 1

    ASSETS.mkdir(parents=True, exist_ok=True)
    download_dir = ROOT / "tools" / "_yolo_download"
    download_dir.mkdir(parents=True, exist_ok=True)

    print("Pobieranie wag YOLOv8 (henningheyen / LVIS, 63 klasy)…")
    gdown.download_folder(GDRIVE_FOLDER, output=str(download_dir), quiet=False, use_cookies=False)

    weights_path: Path | None = None
    for name in PREFERRED_WEIGHTS:
        candidate = download_dir / name
        if candidate.exists():
            weights_path = candidate
            break
    if weights_path is None:
        pt_files = sorted(download_dir.rglob("*.pt"))
        if not pt_files:
            print("Nie znaleziono pliku .pt.")
            return 1
        weights_path = pt_files[0]

    print(f"Wagi: {weights_path.name}")

    model = YOLO(str(weights_path))
    export_path = Path(model.export(format="onnx", imgsz=320, simplify=True, opset=12))
    dest = ASSETS / "yolo_fresh_produce.onnx"
    shutil.copy2(export_path, dest)
    print(f"Zapisano: {dest} ({dest.stat().st_size / 1024 / 1024:.1f} MB)")

    labels = ASSETS / "yolo_labels.txt"
    if labels.exists():
        print(f"Etykiety: {labels}")

    shutil.rmtree(download_dir, ignore_errors=True)
    print("Gotowe — uruchom: flutter pub get && flutter run")
    return 0


if __name__ == "__main__":
    sys.exit(main())
