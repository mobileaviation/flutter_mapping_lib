import 'dart:ui';
import 'package:flutter/material.dart';
import '../../layers/Vector/geombase.dart';
import '../../utils/mapposition.dart';
import 'dart:math' as math;
import '../../utils/geopoint.dart';
import '../../core/mapviewport.dart' as vp;
import '../../utils/mercatorprojection.dart' as MercatorProjection;
import '../../utils/geopoints.dart';
import '../../utils/geomutils.dart' as geomutils;

class Polygon extends GeomBase {
  Polygon(GeoPoints points) {
    _points = points;
    boundingBox = points.boundingBox;
    _drawPoints = new List();
    defaultPaint();
  }

  GeoPoints _points;
  List<Offset> _drawPoints;

  get closed { return (_points != null) ? _points.closed : false; }

  @override
  void paint(Canvas canvas) {
    if (visible) {
      Path p = new Path();
      p.addPolygon(_drawPoints, false);
      canvas.drawPath(p, geomPaint);
    }
  }

  @override
  calculatePixelPosition(vp.MapViewport viewport, MapPosition mapPosition)
  {
    _calculateDrawPositions(viewport, mapPosition);
  }

  _calculateDrawPositions(vp.MapViewport viewport, MapPosition mapPosition) {
    int mapSize = MercatorProjection.getMapSize(mapPosition.zoomLevel);
    math.Point centerPixels =  MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
    Size screensize = viewport.getScreenSize();
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
    return MercatorProjection.getPixelsPosition(location, zoomLevel);
  }

  @override
  bool withinPolygon(GeoPoint geoPoint, Offset screenPoint) {
    if (!_points.closed)
      return super.withinPolygon(geoPoint, screenPoint);
    else {

      int i = geomutils.wnPnPoly(new math.Point(geoPoint.longitudeE6, geoPoint.latitudeE6)
          , _points.mathPointsE6);

      return (i==-1);

      // check C++ code for intersection point with polygon
      // http://geomalgorithms.com/a03-_inclusion.html
    }
  }
}