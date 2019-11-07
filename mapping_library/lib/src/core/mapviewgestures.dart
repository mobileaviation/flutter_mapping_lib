import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/core/mapviewport.dart';
import 'mapview.dart';
import 'package:mapping_library/src/utils/geopoint.dart';
import 'package:mapping_library/src/utils/mapposition.dart';
import 'package:mapping_library/src/utils/mercatorprojection.dart' as MercatorProjection;
import '../layers/layers.dart';
import '../layers/layer.dart';

class MapViewGestures {
  MapViewGestures(this._mapview, this._layers);

  Mapview _mapview;
  Layers _layers;

  MapViewport _dragViewport;
  Offset _touchedOffset;
  double _scale;

  mapTap(TapUpDetails tapUpdetails) {
    GeoPoint tp = _mapview.mapViewport.getGeopointForScreenPosition(new math.Point(
        tapUpdetails.localPosition.dx, tapUpdetails.localPosition.dy));

    for (Layer layer in _layers.children) {
      layer.doTabCheck(tp, tapUpdetails.localPosition);
    }

    //if (widget.mapClicked != null) widget.mapClicked(tp);
    log("Layer Tapped: ${tapUpdetails.localPosition.toString()} : Geopoint: ${tp.toString()}" );
  }

  mapScaleStart(ScaleStartDetails scaleStartDetails) {
    _touchedOffset = Offset(scaleStartDetails.localFocalPoint.dx,
        scaleStartDetails.localFocalPoint.dy);
    _dragViewport = MapViewport.fromViewport(_mapview.mapViewport);
    _scale = _mapview.mapPosition.getScale();
  }

  mapScaleUpdate(ScaleUpdateDetails scaleUpdateDetails) {
    GeoPoint newCenterPoint = _dragViewport.getNewCenterGeopointForDragPosition(
        _touchedOffset, scaleUpdateDetails.localFocalPoint);
    MapPosition newMapPosition =
    MapPosition.fromGeopointScale(newCenterPoint, _scale);

    double s = MercatorProjection.zoomLevelToScaleD(
        newMapPosition.getZoom() + (scaleUpdateDetails.scale - 1));
    newMapPosition = newMapPosition.setScale(s);

    _mapview.mapPosition = newMapPosition;
  }

  mapLongPressStart(LongPressStartDetails longPressStartDetails) {
    Offset s = longPressStartDetails.localPosition;
    GeoPoint tp = _mapview.mapViewport.getGeopointForScreenPosition(new math.Point(
        s.dx, s.dy));
    for (Layer layer in _layers.children) {
      layer.dragStart(tp, s);
    }
  }

  mapLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    Offset s = details.localPosition;
    GeoPoint tp = _mapview.mapViewport.getGeopointForScreenPosition(new math.Point(
        s.dx, s.dy));
    for (Layer layer in _layers.children) {
      layer.drag(tp, s);
    }
  }

  mapLongPressEnd(LongPressEndDetails details) {
    Offset s = details.localPosition;
    GeoPoint tp = _mapview.mapViewport.getGeopointForScreenPosition(new math.Point(
        s.dx, s.dy));
    for (Layer layer in _layers.children) {
      layer.dragEnd(tp, s);
    }
  }

}