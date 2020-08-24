import 'dart:developer';
import 'dart:math' as math;
import 'dart:core';
import 'package:flutter/widgets.dart';
import 'mapviewport.dart';
import 'mapview.dart';
import 'package:geometric_utils/geometric_utils.dart';
import 'package:geometric_utils/mercator_utils.dart' as MercatorProjection;
import '../utils/mapposition.dart';
import '../layers/layers.dart';
import '../layers/layer.dart';

class MapViewGestures {
  MapViewGestures(this._mapview, this._layers);

  Mapview _mapview;
  Layers _layers;

  Animation<Offset> _offset;
  CurvedAnimation animation;
  AnimationController _controller;
  set controller(AnimationController controller) {
    _controller = controller;
    _controller
      ..addListener(() {
        if (_offset != null) {
          MapPosition newMapPosition =
          _updateMapPosition(_offset.value);
          newMapPosition = _updateScale(newMapPosition, _dragScale);
          _mapview.mapPosition = newMapPosition;
        }
      });
  }

  MapViewport _dragViewport;
  Offset _touchedOffset;
  Offset _lastOffset;
  double _scale;
  double _dragScale;
  DateTime _startDragTime;

  mapTap(TapUpDetails tapUpdetails) {
    GeoPoint tp = _mapview.mapViewport.getGeopointForScreenPosition(new math.Point(
        tapUpdetails.localPosition.dx, tapUpdetails.localPosition.dy));

    for (Layer layer in _layers.layers) {
      layer.doTabCheck(tp, tapUpdetails.localPosition);
    }

    //if (widget.mapClicked != null) widget.mapClicked(tp);
    log("Layer Tapped: ${tapUpdetails.localPosition.toString()} : Geopoint: ${tp.toString()}" );
  }

  mapScaleStart(ScaleStartDetails scaleStartDetails) {
    //_controller.stop();
    _startDragTime = DateTime.now();
    _touchedOffset = Offset(scaleStartDetails.localFocalPoint.dx,
        scaleStartDetails.localFocalPoint.dy);
    _dragViewport = MapViewport.fromViewport(_mapview.mapViewport);
    _scale = _mapview.mapPosition.getScale();
  }

  mapScaleUpdate(ScaleUpdateDetails scaleUpdateDetails) {
    //_controller.stop();
    _lastOffset = scaleUpdateDetails.localFocalPoint;
    MapPosition newMapPosition =
      _updateMapPosition(scaleUpdateDetails.localFocalPoint);

    _dragScale = scaleUpdateDetails.scale;
    newMapPosition = _updateScale(newMapPosition, _dragScale);

    _mapview.mapPosition = newMapPosition;
  }

  MapPosition _updateMapPosition(Offset localFocalPoint) {
    GeoPoint newCenterPoint = _dragViewport.getNewCenterGeopointForDragPosition(
        _touchedOffset, localFocalPoint);
    return MapPosition.fromGeopointScale(newCenterPoint, _scale);
  }

  MapPosition _updateScale(MapPosition mapPosition, double scale) {
    double s = MercatorProjection.zoomLevelToScaleD(
        mapPosition.getZoom() + (scale - 1));
    mapPosition = mapPosition.setScale(s);
    return mapPosition;
  }

  mapScaleEnd(ScaleEndDetails scaleEndDetails) {
    Velocity clambedVelocity = scaleEndDetails.velocity.clampMagnitude(0, 300);
    double velocityFactor = 1.2;
    if (DateTime.now().difference(_startDragTime).inMilliseconds < 300) {
      if (clambedVelocity.pixelsPerSecond.dx.abs() > 5 ||
          clambedVelocity.pixelsPerSecond.dy.abs() > 5) {
        Offset posibleNewOffset = Offset(
            _lastOffset.dx +
                clambedVelocity.pixelsPerSecond.dx * velocityFactor,
            _lastOffset.dy +
                clambedVelocity.pixelsPerSecond.dy * velocityFactor);

        _controller.reset();
        _offset = Tween<Offset>(begin: _lastOffset, end: posibleNewOffset)
            .animate(
            new CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOut
            )
        );
        _controller.forward();
      }
    }
    //log("ScaleEndDetails: ${clambedVelocity.toString()}");
  }

  mapLongPressStart(LongPressStartDetails longPressStartDetails) {
    Offset s = longPressStartDetails.localPosition;
    GeoPoint tp = _mapview.mapViewport.getGeopointForScreenPosition(new math.Point(
        s.dx, s.dy));
    for (Layer layer in _layers.layers) {
      layer.dragStart(tp, s);
    }
  }

  mapLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    Offset s = details.localPosition;
    GeoPoint tp = _mapview.mapViewport.getGeopointForScreenPosition(new math.Point(
        s.dx, s.dy));
    for (Layer layer in _layers.layers) {
      layer.drag(tp, s);
    }
  }

  mapLongPressEnd(LongPressEndDetails details) {
    Offset s = details.localPosition;
    GeoPoint tp = _mapview.mapViewport.getGeopointForScreenPosition(new math.Point(
        s.dx, s.dy));
    for (Layer layer in _layers.layers) {
      layer.dragEnd(tp, s);
    }
  }

}