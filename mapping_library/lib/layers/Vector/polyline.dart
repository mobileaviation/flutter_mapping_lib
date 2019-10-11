import 'dart:ui';
import 'package:flutter/material.dart';
import '../../layers/Vector/geombase.dart';
import '../../core/viewport.dart';
import '../../utils/mapposition.dart';
import 'dart:math' as math;
import '../../utils/geopoint.dart';
import '../../core/viewport.dart' as vp;
import '../../utils/mercatorprojection.dart' as MercatorProjection;
import '../../utils/geopoints.dart';
import '../../utils/geomutils.dart' as geomutils;

class Polyline extends GeomBase {
  Polyline() {
    _points = new GeoPoints();
    _drawPoints = new List();
    defaultPaint();
    BorderColor = geomPaint2.color;
  }

  GeoPoints _points;
  List<Offset> _drawPoints;

  int _lineWidth = 5;
  int _borderWidth = 0;
  int _borderLineWidth = 5;
  Color _borderColor;
  get BorderColor { return _borderColor; }
  set BorderColor(Color value) {
    _borderColor = value;
    _setupPaints();
  }

  get BorderWidth { return _borderWidth; }
  set BorderWidth(int value) {
    _borderWidth = value;
    _setupPaints();
  }

  get LineWidth { return _lineWidth; }
  set LineWidth(int value) {
    _lineWidth = value;
    _setupPaints();
  }

  void _setupPaints() {
    _borderLineWidth = _lineWidth + (_borderWidth * 2);
    geomPaint2.color = _borderColor;
    geomPaint2.strokeWidth = _borderLineWidth.toDouble();
    geomPaint.strokeWidth = _lineWidth.toDouble();
  }

  void AddPoints(List<GeoPoint> points) {
    _points.addAll(points);
    fireUpdatedVector();
  }

  void AddPoint(GeoPoint point) {
    _points.add(point);
    fireUpdatedVector();
  }

  void EditPoint(GeoPoint point, int index) {
    _points.insert(index, point);
    fireUpdatedVector();
  }

  void DeletePoint(int index) {
    _points.removeAt(index);
    fireUpdatedVector();
  }

  @override
  void paint(Canvas canvas) {
    if (Visible) {
      if (_borderWidth>0) {
        Path p = new Path();
        p.addPolygon(_drawPoints, false);
        canvas.drawPath(p, geomPaint2);
      }
      Path p = new Path();
      p.addPolygon(_drawPoints, false);
      canvas.drawPath(p, geomPaint);
    }
  }

  @override
  CalculatePixelPosition(vp.Viewport viewport, MapPosition mapPosition)
  {
    _calculateDrawPositions(viewport, mapPosition);
  }

  _calculateDrawPositions(vp.Viewport viewport, MapPosition mapPosition) {
    int mapSize = MercatorProjection.getMapSize(mapPosition.zoomLevel);
    math.Point centerPixels =  MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
    Size screensize = viewport.GetScreenSize();
    double sw2 = screensize.width/2;
    double sh2 = screensize.height/2;
    double cx = centerPixels.x - sw2;
    double cy = centerPixels.y - sh2;

    _drawPoints.clear();
    for (GeoPoint p in _points) {
      math.Point pix = _getPixelsPosition(p, mapPosition.zoomLevel);
      double x = pix.x - cx;
      double y = pix.y - cy;
      math.Point pp = viewport.projectScreenPositionByReferenceAndScale(new math.Point(x, y),
          new math.Point(sw2, sh2),
          mapPosition.getZoomFraction() + 1);
      _drawPoints.add(new Offset(pp.x, pp.y));
    }
  }

  math.Point _getPixelsPosition(GeoPoint location, int zoomLevel) {
    return MercatorProjection.GetPixelsPosition(location, zoomLevel);
  }

  @override
  bool WithinPolygon(GeoPoint geoPoint, Offset screenPoint) {
    return super.WithinPolygon(geoPoint, screenPoint);
  }
}