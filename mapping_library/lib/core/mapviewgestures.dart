import '../utils/geopoint.dart';
import '../utils/mapposition.dart';
import '../utils/mercatorprojection.dart' as MercatorProjection;
import 'mapviewstatebase.dart';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'viewport.dart' as viewPort;

class MapViewGestures extends MapViewStateBase {
  viewPort.Viewport _dragViewport;
  Offset _touchedOffset;
  double _scale;

  _mapScaleStart(ScaleStartDetails scaleStartDetails) {
    log("ScaleStartDetails " + scaleStartDetails.toString());
    _touchedOffset = Offset(scaleStartDetails.localFocalPoint.dx,
        scaleStartDetails.localFocalPoint.dy);
    _dragViewport = viewPort.Viewport.fromViewport(widget.viewport);
    _scale = widget.GetMapPosition().getScale();
  }

  _mapScaleUpdate(ScaleUpdateDetails scaleUpdateDetails) {
    GeoPoint newCenterPoint = _dragViewport.GetNewCenterGeopointForDragPosition(
        _touchedOffset, scaleUpdateDetails.localFocalPoint);
    MapPosition newMapPosition =
        MapPosition.fromGeopointScale(newCenterPoint, _scale);

    double s = MercatorProjection.zoomLevelToScaleD(
        newMapPosition.getZoom() + (scaleUpdateDetails.scale - 1));
    newMapPosition = newMapPosition.setScale(s);

    widget.SetMapPosition(newMapPosition);
  }

  _mapScaleEnd(ScaleEndDetails scaleEndDetails) {
    log("ScaleEndDetails " + scaleEndDetails.toString());
  }

  _mapTap(TapUpDetails tapUpDetails) {
    log("MapTab " + tapUpDetails.toString());
    GeoPoint tp = widget.viewport.GetGeopointForScreenPosition(new math.Point(
        tapUpDetails.localPosition.dx, tapUpDetails.localPosition.dy));
    widget.layerPainter.doLayerTabCheck(tp, tapUpDetails.localPosition);
    if (widget.mapClicked != null) widget.mapClicked(tp);
    log("MapTab: " + tp.toString());
  }

  @override
  Widget build(BuildContext context) {
    CustomPaint p = super.build(context);

    GestureDetector gestureDetector = new GestureDetector(
      child: p,
      onScaleStart: _mapScaleStart,
      onScaleUpdate: _mapScaleUpdate,
      onScaleEnd: _mapScaleEnd,
      onTapUp: _mapTap,
      behavior: HitTestBehavior.translucent,
    );

    return Container(child: gestureDetector);
  }
}
