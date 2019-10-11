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

class Polygon extends GeomBase {
  Polygon(GeoPoints points) {
    _points = points;
    boundingBox = points.BoundingBox;
    _drawPoints = new List();
    defaultPaint();
  }

  GeoPoints _points;
  List<Offset> _drawPoints;

  get Closed { return (_points != null) ? _points.Closed : false; }

  @override
  void paint(Canvas canvas) {
    if (Visible) {
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
    if (!_points.Closed)
      return super.WithinPolygon(geoPoint, screenPoint);
    else {

      int i = geomutils.wn_PnPoly(new math.Point(geoPoint.longitudeE6, geoPoint.latitudeE6)
          , _points.MathPointsE6);

      return (i==-1);

      // check C++ code for intersection point with polygon
      // http://geomalgorithms.com/a03-_inclusion.html
    }
  }
}