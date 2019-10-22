import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/boundingbox.dart';
import '../../layers/vector/geombase.dart';
import '../../utils/mapposition.dart';
import 'dart:math' as math;
import '../../utils/geopoint.dart';
import '../../core/mapviewport.dart' as vp;
import '../../utils/mercatorprojection.dart' as MercatorProjection;
import 'package:vector_math/vector_math.dart' as vector;
import '../../utils/geomutils.dart' as geomutils;

class Line extends GeomBase {
  Line(this.startPoint, this.endPoint) {
    defaultPaint();
    _fillBoundingBox(startPoint, endPoint);
  }

  GeoPoint startPoint;
  GeoPoint endPoint;

  @override
  void paint(Canvas canvas) {
    if (visible)
      canvas.drawLine(Offset(_drawStartPoint.x, _drawStartPoint.y),
          Offset(_drawEndPoint.x, _drawEndPoint.y), geomPaint);
  }

  @override
  calculatePixelPosition(vp.MapViewport viewport, MapPosition mapPosition) {
    _calculateDrawPositions(viewport, mapPosition);
  }

  @override
  bool withinPolygon(GeoPoint geoPoint, Offset screenPoint) {
    var test = geomutils.interceptOnCircle(
        math.Point(_drawStartPoint.x, _drawStartPoint.y),
        math.Point(_drawEndPoint.x, _drawEndPoint.y),
        math.Point(screenPoint.dx, screenPoint.dy),
        7);
    return (test != null);
  }

  _calculateDrawPositions(vp.MapViewport viewport, MapPosition mapPosition) {
    math.Point startPix = _getPixelsPosition(startPoint, mapPosition.zoomLevel);
    math.Point endPix = _getPixelsPosition(endPoint, mapPosition.zoomLevel);
    int mapSize = MercatorProjection.getMapSize(mapPosition.zoomLevel);
    math.Point centerPixels =
        MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
    Size screensize = viewport.getScreenSize();
    double startX = startPix.x - (centerPixels.x - (screensize.width / 2));
    double startY = startPix.y - (centerPixels.y - (screensize.height / 2));
    double endX = endPix.x - (centerPixels.x - (screensize.width / 2));
    double endY = endPix.y - (centerPixels.y - (screensize.height / 2));
    math.Point drawStartPoint =
        viewport.projectScreenPositionByReferenceAndScale(
            math.Point(startX, startY),
            math.Point(screensize.width / 2, screensize.height / 2),
            mapPosition.getZoomFraction() + 1);
    math.Point drawEndPoint = viewport.projectScreenPositionByReferenceAndScale(
        math.Point(endX, endY),
        math.Point(screensize.width / 2, screensize.height / 2),
        mapPosition.getZoomFraction() + 1);
    _drawStartPoint = vector.Vector3(drawStartPoint.x, drawStartPoint.y, 0);
    _drawEndPoint = vector.Vector3(drawEndPoint.x, drawEndPoint.y, 0);
  }

  vector.Vector3 _drawStartPoint;
  vector.Vector3 _drawEndPoint;

  math.Point _getPixelsPosition(GeoPoint location, int zoomLevel) {
    return MercatorProjection.getPixelsPosition(location, zoomLevel);
  }

  _fillBoundingBox(GeoPoint start, GeoPoint end) {
    boundingBox = BoundingBox.fromGeoPoints([start, end]);
  }
}
