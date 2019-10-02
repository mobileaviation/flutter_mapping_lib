import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/viewport.dart' as vp;
import '../../utils/mapposition.dart';

class GeomBase {
  Paint geomPaint;

  void defaultPaint() {
    geomPaint = new Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  CalculatePixelPosition(vp.Viewport viewport, MapPosition mapPosition) {}
  paint(Canvas canvas) {}
  void setUpdateListener(Function listener) {
    _vectorUpdated = listener;
  }

  Function(GeomBase vector) _vectorUpdated;

  void fireUpdatedMarker() {
    if (_vectorUpdated != null) {
      _vectorUpdated(this);
    }
  }
}