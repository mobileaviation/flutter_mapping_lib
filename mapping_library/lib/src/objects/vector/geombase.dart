import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geometric_utils/geometric_utils.dart';
import '../../core/mapviewport.dart' as vp;
import '../../utils/mapposition.dart';

class GeomBase {
  Paint geomPaint;
  Paint geomPaint2;

  BoundingBox boundingBox;

  String name = "Vector";

  bool _visible = true;

  set visible(bool value) {
    _visible = value;
    fireUpdatedVector();
  }

  get visible {
    return _visible;
  }

  void defaultPaint() {
    geomPaint = new Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    geomPaint2 = new Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  calculatePixelPosition(vp.MapViewport viewport, MapPosition mapPosition) {}

  paint(Canvas canvas) {}

  void setUpdateListener(Function listener) {
    _vectorUpdated = listener;
  }

  Function(GeomBase vector) _vectorUpdated;

  void fireUpdatedVector() {
    if (_vectorUpdated != null) {
      _vectorUpdated(this);
    }
  }

  bool withinViewport(vp.MapViewport viewport) {
    if (boundingBox == null) return true;
    return boundingBox.intersects(viewport.getBoundingBox());
  }

  bool withinPolygon(GeoPoint geoPoint, Offset screenPoint) {
    return false;
  }
}
