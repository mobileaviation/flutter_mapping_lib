import 'dart:ui';
import 'dart:math' as math;
import '../../utils/geopoint.dart';
import '../../layers/Vector/geombase.dart';
import '../../core/viewport.dart' as vp;
import '../../utils/mapposition.dart';
import '../../utils/mercatorprojection.dart' as MercatorProjection;

class Circle extends GeomBase {
  Circle(GeoPoint centerPoint, double radius) {
    this.centerPoint = centerPoint;
    this.radius = radius;
    defaultPaint();

  }
  GeoPoint centerPoint;
  double radius;

  @override
  void paint(Canvas canvas) {
    canvas.drawCircle(new Offset(_drawCenterPoint.x, _drawCenterPoint.y), _drawRadius, geomPaint);
  }

  @override
  CalculatePixelPosition(vp.Viewport viewport, MapPosition mapPosition)
  {
    int mapSize = MercatorProjection.getMapSize(mapPosition.zoomLevel);
    math.Point centerPixels =  MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
    math.Point centerPix = _getPixelsPosition(centerPoint, mapPosition.zoomLevel);
    Size screensize = viewport.GetScreenSize();
    double centerX = centerPix.x - (centerPixels.x - (screensize.width/2));
    double centerY = centerPix.y - (centerPixels.y - (screensize.height/2));

    GeoPoint top = centerPoint.destinationPoint(radius, 0.0);
    math.Point topp = _getPixelsPosition(top, mapPosition.zoomLevel);

    double topX = topp.x - (centerPixels.x - (screensize.width/2));
    double topY = topp.y - (centerPixels.y - (screensize.height/2));

    _drawCenterPoint = viewport.projectScreenPositionByReferenceAndScale(new math.Point(centerX, centerY),
        new math.Point(screensize.width/2, screensize.height/2),
        mapPosition.getZoomFraction() + 1);

    math.Point topDrawp = viewport.projectScreenPositionByReferenceAndScale(new math.Point(topX, topY),
        new math.Point(screensize.width/2, screensize.height/2),
        mapPosition.getZoomFraction() + 1);

    _drawRadius = _drawCenterPoint.y - topDrawp.y;
  }

  math.Point _getPixelsPosition(GeoPoint location, int zoomLevel) {
    return MercatorProjection.GetPixelsPosition(location, zoomLevel);
  }

  math.Point _drawCenterPoint;
  double _drawRadius;

}