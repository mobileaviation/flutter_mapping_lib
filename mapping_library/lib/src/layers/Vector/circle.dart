import 'dart:ui';
import 'dart:math' as math;
import '../../utils/boundingbox.dart';
import '../../utils/geopoint.dart';
import '../../layers/vector/geombase.dart';
import '../../core/mapviewport.dart' as vp;
import '../../utils/mapposition.dart';
import '../../utils/mercatorprojection.dart' as MercatorProjection;
import 'package:vector_math/vector_math.dart' as vector;

class Circle extends GeomBase {
  Circle(GeoPoint centerPoint, double radius) {
    this.centerPoint = centerPoint;
    this.radius = radius;
    defaultPaint();
    _fillBoundingBox(centerPoint, radius);
  }

  GeoPoint centerPoint;
  double radius;

  @override
  void paint(Canvas canvas) {
    if (visible)
      canvas.drawCircle(Offset(_drawCenterPoint.x, _drawCenterPoint.y),
          _drawRadius, geomPaint);
  }

  @override
  calculatePixelPosition(vp.MapViewport viewport, MapPosition mapPosition) {
    int mapSize = MercatorProjection.getMapSize(mapPosition.zoomLevel);
    math.Point centerPixels =
        MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
    math.Point centerPix =
        _getPixelsPosition(centerPoint, mapPosition.zoomLevel);
    Size screensize = viewport.getScreenSize();
    double centerX = centerPix.x - (centerPixels.x - (screensize.width / 2));
    double centerY = centerPix.y - (centerPixels.y - (screensize.height / 2));

    GeoPoint top = centerPoint.destinationPoint(radius, 0.0);
    math.Point topp = _getPixelsPosition(top, mapPosition.zoomLevel);

    double topX = topp.x - (centerPixels.x - (screensize.width / 2));
    double topY = topp.y - (centerPixels.y - (screensize.height / 2));

    _drawCenterPoint = viewport.projectScreenPositionByReferenceAndScale(
        math.Point(centerX, centerY),
        math.Point(screensize.width / 2, screensize.height / 2),
        mapPosition.getZoomFraction() + 1);

    math.Point topDrawp = viewport.projectScreenPositionByReferenceAndScale(
        math.Point(topX, topY),
        math.Point(screensize.width / 2, screensize.height / 2),
        mapPosition.getZoomFraction() + 1);

    _drawRadius = _drawCenterPoint.y - topDrawp.y;
  }

  @override
  bool withinPolygon(GeoPoint geoPoint, Offset screenPoint) {
    vector.Sphere c = vector.Sphere.centerRadius(
        vector.Vector3(_drawCenterPoint.x, _drawCenterPoint.y, 0), _drawRadius);
    return c.containsVector3(vector.Vector3(screenPoint.dx, screenPoint.dy, 0));
  }

  math.Point _getPixelsPosition(GeoPoint location, int zoomLevel) {
    return MercatorProjection.getPixelsPosition(location, zoomLevel);
  }

  _fillBoundingBox(GeoPoint center, double radius) {
    GeoPoint n = center.destinationPoint(radius, 0);
    GeoPoint e = center.destinationPoint(radius, 90);
    GeoPoint w = center.destinationPoint(radius, 180);
    GeoPoint s = center.destinationPoint(radius, 270);

    GeoPoint p1 = GeoPoint(n.getLatitude(), e.getLongitude());
    GeoPoint p2 = GeoPoint(s.getLatitude(), w.getLongitude());

    boundingBox = BoundingBox.fromGeoPoints([p1, p2]);
  }

  math.Point _drawCenterPoint;
  double _drawRadius;
}
