import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mapping_library/src/objects/markers/buttonsmarker.dart';
import 'package:mapping_library/src/objects/markers/renderers/buttonsmarkerrenderer.dart';
import '../../objects/vector/markergeopoint.dart';
import '../../objects/markers/renderers/pointmarkerrenderer.dart';
import '../../objects/markers/pointmarker.dart';
import '../../objects/markers/markers.dart';
import '../../objects/vector/geombase.dart';
import '../../utils/mapposition.dart';
import 'dart:math' as math;
import '../../core/mapviewport.dart' as vp;
import 'package:geometric_utils/geometric_utils.dart' as gp;
import 'package:geometric_utils/mercator_utils.dart'  as MercatorProjection;
import 'package:geometric_utils/geomutils_utils.dart'  as geomutils;

class Polyline extends GeomBase {
  Polyline() {
    _points = gp.GeoPoints();
    _drawPoints = [];
    defaultPaint();
    _markerDrawer = PointMarkerRenderer();
    _markerDrawer.setup(_getPointMarkerData());
    _buttonDrawer = ButtonsMarkerRenderer();
    _buttonDrawer.setup(_getButtonsMarkerData());
    borderColor = geomPaint2.color;
    name = "Polyline";
  }

  gp.GeoPoints _points;
  gp.GeoPoints get points { return _points; }
  Markers _pointMarkers;
  List<Offset> _drawPoints;
  PointMarkerRenderer _markerDrawer;
  ButtonsMarkerRenderer _buttonDrawer;

  int _lineWidth = 5;
  int _borderWidth = 0;
  int _borderLineWidth = 5;
  Color _borderColor;
  bool _drawMarkers = true;
  bool _editEnabled = true;

  bool get drawMarkers => _drawMarkers;
  set drawMarkers (bool value) { _drawMarkers = value; }

  bool get editEnabled => _editEnabled;
  set editEnabled (bool value) { _editEnabled = value; }

  Color get borderColor => _borderColor;
  set borderColor(Color value) {
    _borderColor = value;
    _setupPaints();
  }

  int get borderWidth => _borderWidth;

  set borderWidth(int value) {
    _borderWidth = value;
    _setupPaints();
  }

  int get lineWidth => _lineWidth;

  set lineWidth(int value) {
    _lineWidth = value;
    _setupPaints();
  }

  void _setupPaints() {
    _borderLineWidth = _lineWidth + (_borderWidth * 2);
    geomPaint2.color = _borderColor;
    geomPaint2.strokeWidth = _borderLineWidth.toDouble();
    geomPaint.strokeWidth = _lineWidth.toDouble();
  }

  void addPoints(List<gp.GeoPoint> points) {
    for(gp.GeoPoint geoPoint in points)
    {
      MarkerGeopoint p = _setupMarker(geoPoint, null);
      _points.add(p);
    }
    fireUpdatedVector();
  }

  void startEdit(gp.GeoPoint geoPoint, Object data){
    if (_editEnabled) {
      _setupButtonsMarker(geoPoint, data);
    }
  }

  MarkerGeopoint _setupMarker(gp.GeoPoint geoPoint, Object data)
  {
    MarkerGeopoint p = MarkerGeopoint.fromGeopoint(geoPoint);
    p.data = data;
    p.marker = PointMarker(_markerDrawer, Size(20,20), geoPoint);
    p.marker.dragable = true;
    p.marker.doDraw().then((value) {
      fireUpdatedVector();
    });
    return p;
  }

  MarkerGeopoint _setupButtonsMarker(gp.GeoPoint geoPoint, Object data)
  {
    MarkerGeopoint p = MarkerGeopoint.fromGeopoint(geoPoint);
    p.data = data;
    p.marker = ButtonsMarker(_markerDrawer, Size(20,20), geoPoint);
    p.marker.dragable = false;
    p.marker.doDraw().then((value) {
      fireUpdatedVector();
    });
    return p;
  }

  PointMarkerRendererData _getPointMarkerData() {
    PointMarkerRendererData data = PointMarkerRendererData();
    data.borderWidth = 3;
    data.borderColor = Colors.red;
    data.backgroundColor = Colors.greenAccent;
    return data;
  }

  ButtonsMarkerRendererData _getButtonsMarkerData() {
    ButtonsMarkerRendererData data = ButtonsMarkerRendererData();
    ButtonMarker button = ButtonMarker();
    button.text = '+';
    data.buttons.add(button);
    return data;
  }

  void addPoint(gp.GeoPoint point, Object data) {
    MarkerGeopoint p = _setupMarker(point, data);
    _points.add(p);
    fireUpdatedVector();
  }

  void insertPoint(gp.GeoPoint point, int index, Object data) {
    MarkerGeopoint p = _setupMarker(point, data);
    _points.insert(index, p);
    fireUpdatedVector();
  }

  void deletePoint(int index) {
    _points.removeAt(index);
    fireUpdatedVector();
  }

  @override
  void paint(Canvas canvas) {
    if (visible) {
      if (_borderWidth > 0) {
        Path p = Path();
        p.addPolygon(_drawPoints, false);
        canvas.drawPath(p, geomPaint2);
      }
      Path p = Path();
      p.addPolygon(_drawPoints, false);
      canvas.drawPath(p, geomPaint);

      if (_drawMarkers)
        for (MarkerGeopoint geopoint in _points) {
          geopoint.marker.paint(canvas);
        }
    }
  }

  @override
  calculatePixelPosition(vp.MapViewport viewport, MapPosition mapPosition) async {
    _calculateDrawPositions(viewport, mapPosition);
  }

  _calculateDrawPositions(vp.MapViewport viewport, MapPosition mapPosition) async {
    int mapSize = MercatorProjection.getMapSize(mapPosition.zoomLevel);
    math.Point centerPixels =
        MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
    Size screensize = viewport.getScreenSize();
    double sw2 = screensize.width / 2;
    double sh2 = screensize.height / 2;
    double cx = centerPixels.x - sw2;
    double cy = centerPixels.y - sh2;

    _drawPoints.clear();
    for (MarkerGeopoint p in _points) {
      math.Point pix = _getPixelsPosition(p, mapPosition.zoomLevel);
      double x = pix.x - cx;
      double y = pix.y - cy;
      math.Point pp = viewport.projectScreenPositionByReferenceAndScale(
          math.Point(x, y),
          math.Point(sw2, sh2),
          mapPosition.getZoomFraction() + 1);
      _drawPoints.add(Offset(pp.x, pp.y));
      p.marker.drawingPoint = pp;
    }
  }

  math.Point _getPixelsPosition(gp.GeoPoint location, int zoomLevel) {
    return MercatorProjection.getPixelsPosition(location, zoomLevel);
  }

  @override
  bool withinPolygon(gp.GeoPoint geoPoint, Offset screenPoint) {
    bool test;

    test = _withinPolygon(geoPoint, screenPoint);
    if (test) startEdit(geoPoint, this);

    return test;
  }

  bool _withinPolygon(gp.GeoPoint geoPoint, Offset screenPoint) {
    bool test = false;
    for (int i=1; i<_drawPoints.length; i++) {
      // var segmentTest = geomutils.interceptOnCircle(
      //     math.Point(_drawPoints[i-1].dx, _drawPoints[i-1].dy),
      //     math.Point(_drawPoints[i].dx, _drawPoints[i].dy),
      //     math.Point(screenPoint.dx, screenPoint.dy),
      //     5);
      test = (geomutils.findLineCircleIntersections(math.Point(_drawPoints[i-1].dx, _drawPoints[i-1].dy),
          math.Point(_drawPoints[i].dx, _drawPoints[i].dy),
          math.Point(screenPoint.dx, screenPoint.dy), 15))>0 ? true : false;

      if (test) break;
      //test = test || (segmentTest != null);
    }

    return test;
  }
}
