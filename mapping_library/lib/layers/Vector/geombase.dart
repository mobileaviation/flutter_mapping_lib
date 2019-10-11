import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/geopoint.dart';
import '../../utils/boundingbox.dart';
import '../../core/viewport.dart' as vp;
import '../../utils/mapposition.dart';

class GeomBase {
  Paint geomPaint;
  Paint geomPaint2;

  BoundingBox boundingBox;

  String Name = "Vector";

  bool _visible = true;
  set Visible(bool value) {
    _visible = value;
    fireUpdatedVector();
  }
  get Visible { return _visible; }

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

  CalculatePixelPosition(vp.Viewport viewport, MapPosition mapPosition) {}
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

  bool WithinViewport(vp.Viewport viewport) {
    if (boundingBox == null) return true;
    return boundingBox.intersects(viewport.GetBoundingBox());
  }

  bool WithinPolygon(GeoPoint geoPoint, Offset screenPoint) { return false; }
}