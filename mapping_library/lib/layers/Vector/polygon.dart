import 'dart:ui';
import 'package:flutter/material.dart';
import '../../layers/Vector/geombase.dart';
import '../../core/viewport.dart';
import '../../utils/mapposition.dart';
import 'dart:math' as math;
import '../../utils/geopoint.dart';
import '../../core/viewport.dart' as vp;
import '../../utils/mercatorprojection.dart' as MercatorProjection;

class Polygon extends GeomBase {
  Polygon(List<GeoPoint> points) {
    _points = points;
    _drawPoints = new List();
    defaultPaint();
  }

  List<GeoPoint> _points;
  List<Offset> _drawPoints;

  @override
  void paint(Canvas canvas) {
    Offset p1, p2;
    for (Offset p in _drawPoints) {
      if (p1 == null) p1 = p;
      if (p1 != null) {
        p2 = p;
        canvas.drawLine(p1, p2, geomPaint);
        p1 = p;
      }
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
}