import 'dart:ui';
import 'dart:math' as math;
import '../../utils/boundingbox.dart' as utils;
import '../../core/viewport.dart';
import '../../utils/mapposition.dart';
import '../../utils/geopoint.dart';
import 'Renderers/markerrenderer.dart';
import '../../utils/mercatorprojection.dart' as MercatorProjection;

class MarkerBase {
  MarkerBase(MarkerRenderer drawerBase, Size size, GeoPoint location) {
    _markerDrawer = drawerBase;
    MarkerSize = size;
    _pivotPoint = new math.Point(size.width/2, size.height/2);
    _location = location;
    Name = _location.toString();
  }

  void paint(Canvas canvas) {
    if (MarkerImage != null) {
      Offset drawPoint = new Offset(DrawPoint._x - PivotPoint._x, DrawPoint._y - PivotPoint._y);
      canvas.drawImage(MarkerImage, drawPoint, new Paint());
    }
  }

  Future<Image> doDraw() async { return null; }

  String Name;

  GeoPoint _location;
  get Location { return _location; }
  set Location(GeoPoint value) {
    _location = value;
    _calcBoundingBox(_scale);
    fireUpdatedMarker();
  }

  utils.BoundingBox _boundingBox;
  get BoundingBox { return _boundingBox; }

  double _rotation;
  get Rotation { return _rotation; }
  set Rotation(double value) {
    _rotation = value;
    _calcBoundingBox(_scale);
    fireUpdatedMarker();
  }

  math.Point _pivotPoint;
  get PivotPoint { return _pivotPoint; }

  Image _markerImage;
  get MarkerImage { return _markerImage; }
  set MarkerImage(Image value) {
    _markerImage = value;
    _calcBoundingBox(_scale);
    fireUpdatedMarker();
  }

  Size MarkerSize;

  math.Point _drawPoint;
  get DrawPoint { return _drawPoint; }

  MarkerRenderer _markerDrawer;
  MarkerRenderer get MarkerDrawer { return _markerDrawer; }

  double _scale = -1;

  void CalculatePixelPosition(Viewport viewport, MapPosition mapPosition) {
    math.Point markerPixels = _getPixelsPosition(mapPosition.zoomLevel);
    int mapSize = MercatorProjection.getMapSize(mapPosition.zoomLevel);
    math.Point centerPixels =  MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
    Size screensize = viewport.GetScreenSize();
    double screenPosX = markerPixels.x - (centerPixels.x - (screensize.width/2));
    double screenPosY = markerPixels.y - (centerPixels.y - (screensize.height/2));
    _drawPoint = viewport.projectScreenPositionByReferenceAndScale(new math.Point(screenPosX, screenPosY),
        new math.Point(screensize.width/2, screensize.height/2),
        mapPosition.getZoomFraction() + 1);
    //_calcBoundingBoxByMapsize(mapSize);
    //_getBoundingBox(MercatorProjection.zoomLevelToScaleD(mapPosition.getZoom()));
  }

  void _getBoundingBox(double scale) {
    if (_scale != scale) {
      _scale = scale;
      _calcBoundingBox(scale);
    }
  }

  void _calcBoundingBoxByMapsize(int mapsize) {
    math.Point pos = MercatorProjection.getPixel(_location, mapsize);
    math.Point tl = new math.Point(
        pos.x - _pivotPoint.x, pos.y - _pivotPoint.y);
    math.Point br = new math.Point(
        pos.x + _pivotPoint.x, pos.y + _pivotPoint.y);

    GeoPoint gtl = MercatorProjection.fromPixels(
        tl.x, tl.y, mapsize);
    GeoPoint gbr = MercatorProjection.fromPixels(
        br.x, br.y, mapsize);

    _boundingBox = new utils.BoundingBox.fromGeoPoints([gtl, gbr]);
  }

  void _calcBoundingBox(double scale) {
    math.Point pos = MercatorProjection.getPixelWithScale(_location, scale);
    math.Point tl = new math.Point(
        pos.x - _pivotPoint.x, pos.y - _pivotPoint.y);
    math.Point br = new math.Point(
        pos.x + _pivotPoint.x, pos.y + _pivotPoint.y);


    GeoPoint gtl = MercatorProjection.fromPixels(
        tl.x, tl.y, MercatorProjection.getMapSizeWithScale(scale));
    GeoPoint gbr = MercatorProjection.fromPixels(
        br.x, br.y, MercatorProjection.getMapSizeWithScale(scale));

    _boundingBox = new utils.BoundingBox.fromGeoPoints([gtl, gbr]);
  }

  bool MarkerSelectedByScreenPos(Offset screenPos) {
    Offset drawPoint = new Offset(((DrawPoint._x - PivotPoint._x) + (MarkerSize.width/2)),
        ((DrawPoint._y - PivotPoint._y) + (MarkerSize.height/2)));
    Rect markerRect = Rect.fromCenter(center: drawPoint, width: MarkerSize.width, height: MarkerSize.height);
    return markerRect.contains(screenPos);
  }

  bool WithinViewport(Viewport viewport) {
    if (_boundingBox == null) _calcBoundingBox(_scale);
    return _boundingBox.intersects(viewport.GetBoundingBox());
  }

  math.Point _getPixelsPosition(int zoomLevel) {
    return MercatorProjection.GetPixelsPosition(Location, zoomLevel);
  }

  void setUpdateListener(Function listener) {
    _markerUpdated = listener;
  }

  Function(MarkerBase marker) _markerUpdated;

  void fireUpdatedMarker() {
    if (_markerUpdated != null) {
      _markerUpdated(this);
    }
  }

}