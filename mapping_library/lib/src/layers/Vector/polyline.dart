import 'dart:ui';
import 'package:flutter/material.dart';
import '../../layers/vector/geombase.dart';
import '../../utils/mapposition.dart';
import 'dart:math' as math;
import '../../utils/geopoint.dart' as gp;
import '../../core/mapviewport.dart' as vp;
import '../../utils/mercatorprojection.dart' as MercatorProjection;
import '../../utils/geopoints.dart';

class Polyline extends GeomBase {
  Polyline() {
    _points = GeoPoints();
    _drawPoints = [];
    defaultPaint();
    borderColor = geomPaint2.color;
  }

  GeoPoints _points;
  List<Offset> _drawPoints;

  int _lineWidth = 5;
  int _borderWidth = 0;
  int _borderLineWidth = 5;
  Color _borderColor;

  get borderColor {
    return _borderColor;
  }

  set borderColor(Color value) {
    _borderColor = value;
    _setupPaints();
  }

  get borderWidth {
    return _borderWidth;
  }

  set borderWidth(int value) {
    _borderWidth = value;
    _setupPaints();
  }

  get lineWidth {
    return _lineWidth;
  }

  set lineWidth(int value) {
    _lineWidth = value;
    _setupPaints();
  }

  void _setupPaints() {
    _borderLineWidth = _lineWidth + (_borderWidth * 2);
    geomPaint2.color = _borderColor;
    geomPaint2.strokeWidth = _borderLineWidth.toDouble();
    geomPaint.strokeWidth = _lineWidth.toDouble();
  }

  void addPoints(List<gp.GeoPoint> points) {
    _points.addAll(points);
    fireUpdatedVector();
  }

  void addPoint(gp.GeoPoint point) {
    _points.add(point);
    fireUpdatedVector();
  }

  void editPoint(gp.GeoPoint point, int index) {
    _points.insert(index, point);
    fireUpdatedVector();
  }

  void deletePoint(int index) {
    _points.removeAt(index);
    fireUpdatedVector();
  }

  @override
  void paint(Canvas canvas) {
    if (visible) {
      if (_borderWidth > 0) {
        Path p = Path();
        p.addPolygon(_drawPoints, false);
        canvas.drawPath(p, geomPaint2);
      }
      Path p = Path();
      p.addPolygon(_drawPoints, false);
      canvas.drawPath(p, geomPaint);
    }
  }

  @override
  calculatePixelPosition(vp.MapViewport viewport, MapPosition mapPosition) {
    _calculateDrawPositions(viewport, mapPosition);
  }

  _calculateDrawPositions(vp.MapViewport viewport, MapPosition mapPosition) {
    int mapSize = MercatorProjection.getMapSize(mapPosition.zoomLevel);
    math.Point centerPixels =
        MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
    Size screensize = viewport.getScreenSize();
    double sw2 = screensize.width / 2;
    double sh2 = screensize.height / 2;
    double cx = centerPixels.x - sw2;
    double cy = centerPixels.y - sh2;

    _drawPoints.clear();
    for (gp.GeoPoint p in _points) {
      math.Point pix = _getPixelsPosition(p, mapPosition.zoomLevel);
      double x = pix.x - cx;
      double y = pix.y - cy;
      math.Point pp = viewport.projectScreenPositionByReferenceAndScale(
          math.Point(x, y),
          math.Point(sw2, sh2),
          mapPosition.getZoomFraction() + 1);
      _drawPoints.add(Offset(pp.x, pp.y));
    }
  }

  math.Point _getPixelsPosition(gp.GeoPoint location, int zoomLevel) {
    return MercatorProjection.getPixelsPosition(location, zoomLevel);
  }

  @override
  bool withinPolygon(gp.GeoPoint geoPoint, Offset screenPoint) {
    return super.withinPolygon(geoPoint, screenPoint);
  }
}
