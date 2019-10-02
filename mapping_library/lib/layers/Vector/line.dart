import 'dart:ui';
import 'package:flutter/material.dart';
import '../../layers/Vector/geombase.dart';
import '../../core/viewport.dart';
import '../../utils/mapposition.dart';
import 'dart:math' as math;
import '../../utils/geopoint.dart';
import '../../core/viewport.dart' as vp;
import '../../utils/mercatorprojection.dart' as MercatorProjection;

class Line extends GeomBase {
  Line(this.startPoint, this.endPoint) {
    defaultPaint();
  }

  GeoPoint startPoint;
  GeoPoint endPoint;

  @override
  void paint(Canvas canvas) {
    canvas.drawLine(new Offset(_drawStartPoint.x, _drawStartPoint.y),
        new Offset(_drawEndPoint.x, _drawEndPoint.y), geomPaint);
  }

  @override
  CalculatePixelPosition(vp.Viewport viewport, MapPosition mapPosition)
  {
    _calculateDrawPositions(viewport, mapPosition);
  }

  _calculateDrawPositions(vp.Viewport viewport, MapPosition mapPosition) {
    math.Point startPix = _getPixelsPosition(startPoint, mapPosition.zoomLevel);
    math.Point endPix = _getPixelsPosition(endPoint, mapPosition.zoomLevel);
    int mapSize = MercatorProjection.getMapSize(mapPosition.zoomLevel);
    math.Point centerPixels =  MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
    Size screensize = viewport.GetScreenSize();
    double startX = startPix.x - (centerPixels.x - (screensize.width/2));
    double startY = startPix.y - (centerPixels.y - (screensize.height/2));
    double endX = endPix.x - (centerPixels.x - (screensize.width/2));
    double endY = endPix.y - (centerPixels.y - (screensize.height/2));
    _drawStartPoint = viewport.projectScreenPositionByReferenceAndScale(new math.Point(startX, startY),
        new math.Point(screensize.width/2, screensize.height/2),
        mapPosition.getZoomFraction() + 1);
    _drawEndPoint = viewport.projectScreenPositionByReferenceAndScale(new math.Point(endX, endY),
        new math.Point(screensize.width/2, screensize.height/2),
        mapPosition.getZoomFraction() + 1);
  }

  math.Point _drawStartPoint;
  math.Point _drawEndPoint;

  math.Point _getPixelsPosition(GeoPoint location, int zoomLevel) {
    return MercatorProjection.GetPixelsPosition(location, zoomLevel);
  }

}