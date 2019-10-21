import 'dart:ui';
import 'dart:math' as math;
import '../../utils/boundingbox.dart' as utils;
import '../../core/mapviewport.dart';
import '../../utils/mapposition.dart';
import '../../utils/geopoint.dart';
import 'Renderers/markerrenderer.dart';
import '../../utils/mercatorprojection.dart' as MercatorProjection;

class MarkerBase {
  MarkerBase(MarkerRenderer drawerBase, Size size, GeoPoint location) {
    _markerDrawer = drawerBase;
    markerSize = size;
    _pivotPoint = new math.Point(size.width/2, size.height/2);
    _location = location;
    name = _location.toString();
  }

  void paint(Canvas canvas) {
    if (markerImage != null) {
      Offset drawPoint = new Offset(drawingPoint.x - pivotPoint.x, drawingPoint.y - pivotPoint.y);
      canvas.drawImage(markerImage, drawPoint, new Paint());
    }
  }

  Future<Image> doDraw() async { return null; }

  String name = "Marker";

  GeoPoint _location;
  get location { return _location; }
  set location(GeoPoint value) {
    _location = value;
    _calcBoundingBox(_scale);
    fireUpdatedMarker();
  }

  utils.BoundingBox _boundingBox;
  get boundingBox { return _boundingBox; }

  double _rotation;
  get rotation { return _rotation; }
  set rotation(double value) {
    _rotation = value;
    _calcBoundingBox(_scale);
    fireUpdatedMarker();
  }

  math.Point _pivotPoint;
  get pivotPoint { return _pivotPoint; }

  Image _markerImage;
  get markerImage { return _markerImage; }
  set markerImage(Image value) {
    _markerImage = value;
    _calcBoundingBox(_scale);
    fireUpdatedMarker();
  }

  Size markerSize;

  math.Point _drawPoint;
  get drawingPoint { return _drawPoint; }

  MarkerRenderer _markerDrawer;
  MarkerRenderer get markerDrawer { return _markerDrawer; }

  double _scale = -1;

  void calculatePixelPosition(MapViewport viewport, MapPosition mapPosition) {
    math.Point markerPixels = _getPixelsPosition(mapPosition.zoomLevel);
    int mapSize = MercatorProjection.getMapSize(mapPosition.zoomLevel);
    math.Point centerPixels =  MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
    Size screensize = viewport.getScreenSize();
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

  bool markerSelectedByScreenPos(Offset screenPos) {
    Offset drawPoint = new Offset(((drawingPoint.x - pivotPoint.x) + (markerSize.width/2)),
        ((drawingPoint.y - pivotPoint.y) + (markerSize.height/2)));
    Rect markerRect = Rect.fromCenter(center: drawPoint, width: markerSize.width, height: markerSize.height);
    return markerRect.contains(screenPos);
  }

  bool withinViewport(MapViewport viewport) {
    if (_boundingBox == null) _calcBoundingBox(_scale);
    return _boundingBox.intersects(viewport.getBoundingBox());
  }

  math.Point _getPixelsPosition(int zoomLevel) {
    return MercatorProjection.getPixelsPosition(location, zoomLevel);
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