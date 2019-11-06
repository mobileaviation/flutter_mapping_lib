import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart' as material;
import '../../utils/angles.dart';
import '../../utils/boundingbox.dart' as utils;
import '../../core/mapviewport.dart';
import '../../utils/mapposition.dart';
import '../../utils/geopoint.dart';
import 'renderers/markerrenderer.dart';
import '../../utils/mercatorprojection.dart' as MercatorProjection;

class MarkerBase {
  MarkerBase(MarkerRenderer drawerBase, Size size, GeoPoint location) {
    _markerDrawer = drawerBase;
    markerSize = size;
    _calcPivotPoint();
    _location = location;
    _rotation = 0;
    name = _location.toString();
  }

  void _calcPivotPoint() {
    if (markerSize != null) {
      _pivotPoint = math.Point(markerSize.width / 2, markerSize.height / 2);
    }
    else _pivotPoint = math.Point(0,0);
  }

  Future<Image> _drawMarker() async {
    var pictureRec = PictureRecorder();
    Canvas c = Canvas(pictureRec);
    _calcPivotPoint();
    c.translate(_pivotPoint.x, _pivotPoint.y);
    c.rotate(toRadians(_rotation));
    c.translate(-_pivotPoint.x, -_pivotPoint.y);
    c.drawImage(markerImage, Offset.zero, Paint());
    return await pictureRec.endRecording().toImage(markerSize.width.floor(),
        markerSize.height.floor());
  }

  void paint(Canvas canvas) {
    if (_visible) {
      _calcPivotPoint();
      if (_drawImage != null) {
        Offset drawPoint =
        Offset(drawingPoint.x - pivotPoint.x, drawingPoint.y - pivotPoint.y);
        canvas.drawImage(_drawImage, drawPoint, Paint());

        if (_selected) {
          Size selectedBorderSize = Size(
              markerSize.width + (0.1 * markerSize.width),
              markerSize.height + (0.1 * markerSize.height));
          Paint selectedBorderPaint = Paint()
            ..style = PaintingStyle.stroke
            ..isAntiAlias = true
            ..strokeWidth = 5
            ..color = selectedColor;
          Rect rect = Rect.fromLTWH(
              drawingPoint.x - (selectedBorderSize.width / 2),
              drawingPoint.y - (selectedBorderSize.height / 2),
              selectedBorderSize.width, selectedBorderSize.height);
          RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(20));
          canvas.drawRRect(rrect, selectedBorderPaint);

//        if (DateTime.now().difference(_selectedTime).inMilliseconds >_showSelectedBorderFor) {
//          selected = false;
//        }
        }
      }
    }
  }

  Future<Image> doDraw() async {
    if (_rotation == 0) {
      _drawImage = await markerImage;
      return await markerImage;
    } else {
      _drawImage = await _drawMarker();
      return await _drawImage;
    }
  }

  String name = "Marker";
  dynamic object;

  GeoPoint _location;
  get location {
    return _location;
  }

  set location(GeoPoint value) {
    _location = value;
    _calcBoundingBox(_scale);
    fireUpdatedMarker();
  }

  utils.BoundingBox _boundingBox;
  get boundingBox {
    return _boundingBox;
  }

  double _rotation;
  get rotation {
    return _rotation;
  }
  set rotation(double value) {
    _rotation = value;
    _calcBoundingBox(_scale);
    fireUpdatedMarker();
  }

  math.Point _pivotPoint;
  get pivotPoint {
    return _pivotPoint;
  }

  Image _markerImage;
  get markerImage {
    return _markerImage;
  }
  set markerImage(Image value) {
    _markerImage = value;
    _calcBoundingBox(_scale);
    fireUpdatedMarker();
  }
  Image _drawImage;

  Size markerSize;

  math.Point _drawPoint;
  get drawingPoint {
    return _drawPoint;
  }
  set drawingPoint(value) { _drawPoint = value; }

  MarkerRenderer _markerDrawer;
  MarkerRenderer get markerDrawer {
    return _markerDrawer;
  }

  bool _dragable = false;
  get dragable { return _dragable; }
  set dragable(value) { _dragable = value; }

  bool selectable = true;
  bool _selected = false;
  set selected(value) {
    _selected = value;
    _selectedTime = DateTime.now();
    fireUpdatedMarker();
  }
  get selected { return _selected; }

  bool _visible = true;
  get visible { return _visible; }
  set visible(value) {
    _visible = value;
    fireUpdatedMarker();
  }

  int _showSelectedBorderFor = 2000; // in MS
  DateTime _selectedTime;
  Color selectedColor = material.Colors.red;

  double _scale = -1;

  void calculatePixelPosition(MapViewport viewport, MapPosition mapPosition) {
    math.Point markerPixels = _getPixelsPosition(mapPosition.zoomLevel);
    int mapSize = MercatorProjection.getMapSize(mapPosition.zoomLevel);
    math.Point centerPixels =
        MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
    Size screensize = viewport.getScreenSize();
    double screenPosX =
        markerPixels.x - (centerPixels.x - (screensize.width / 2));
    double screenPosY =
        markerPixels.y - (centerPixels.y - (screensize.height / 2));
    _drawPoint = viewport.projectScreenPositionByReferenceAndScale(
        new math.Point(screenPosX, screenPosY),
        new math.Point(screensize.width / 2, screensize.height / 2),
        mapPosition.getZoomFraction() + 1);
  }



  void _getBoundingBox(double scale) {
    if (_scale != scale) {
      _scale = scale;
      _calcBoundingBox(scale);
    }
  }

  void _calcBoundingBoxByMapsize(int mapsize) {
    math.Point pos = MercatorProjection.getPixel(_location, mapsize);
    math.Point tl = math.Point(pos.x - _pivotPoint.x, pos.y - _pivotPoint.y);
    math.Point br = math.Point(pos.x + _pivotPoint.x, pos.y + _pivotPoint.y);

    GeoPoint gtl = MercatorProjection.fromPixels(tl.x, tl.y, mapsize);
    GeoPoint gbr = MercatorProjection.fromPixels(br.x, br.y, mapsize);

    _boundingBox = utils.BoundingBox.fromGeoPoints([gtl, gbr]);
  }

  void _calcBoundingBox(double scale) {
    math.Point pos = MercatorProjection.getPixelWithScale(_location, scale);
    math.Point tl = math.Point(pos.x - _pivotPoint.x, pos.y - _pivotPoint.y);
    math.Point br = math.Point(pos.x + _pivotPoint.x, pos.y + _pivotPoint.y);

    GeoPoint gtl = MercatorProjection.fromPixels(
        tl.x, tl.y, MercatorProjection.getMapSizeWithScale(scale));
    GeoPoint gbr = MercatorProjection.fromPixels(
        br.x, br.y, MercatorProjection.getMapSizeWithScale(scale));

    _boundingBox = utils.BoundingBox.fromGeoPoints([gtl, gbr]);
  }

  bool markerSelectedByScreenPos(Offset screenPos) {
    Offset drawPoint = new Offset(
        ((drawingPoint.x - pivotPoint.x) + (markerSize.width / 2)),
        ((drawingPoint.y - pivotPoint.y) + (markerSize.height / 2)));
    Rect markerRect = Rect.fromCenter(
        center: drawPoint, width: markerSize.width, height: markerSize.height);
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
