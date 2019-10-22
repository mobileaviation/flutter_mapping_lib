import 'dart:developer';
import 'dart:math' as math;
import '../utils/geopoint.dart';
import '../utils/mapposition.dart';
import '../utils/mercatorprojection.dart' as MercatorProjection;
import 'mapviewstatebase.dart';
import 'package:flutter/widgets.dart';
import 'mapviewport.dart' as viewPort;

class MapViewGestures extends MapViewStateBase {
  viewPort.MapViewport _dragViewport;
  Offset _touchedOffset;
  double _scale;

  _mapScaleStart(ScaleStartDetails scaleStartDetails) {
    _touchedOffset = Offset(scaleStartDetails.localFocalPoint.dx,
        scaleStartDetails.localFocalPoint.dy);
    _dragViewport = viewPort.MapViewport.fromViewport(widget.viewport);
    _scale = widget.getMapPosition().getScale();
  }

  _mapScaleUpdate(ScaleUpdateDetails scaleUpdateDetails) {
    GeoPoint newCenterPoint = _dragViewport.getNewCenterGeopointForDragPosition(
        _touchedOffset, scaleUpdateDetails.localFocalPoint);
    MapPosition newMapPosition =
        MapPosition.fromGeopointScale(newCenterPoint, _scale);

    double s = MercatorProjection.zoomLevelToScaleD(
        newMapPosition.getZoom() + (scaleUpdateDetails.scale - 1));
    newMapPosition = newMapPosition.setScale(s);

    widget.setMapPosition(newMapPosition);
  }

  _mapScaleEnd(ScaleEndDetails scaleEndDetails) {
    //log("ScaleEndDetails " + scaleEndDetails.toString());
  }

  _mapTap(TapUpDetails tapUpDetails) {
    GeoPoint tp = widget.viewport.getGeopointForScreenPosition(new math.Point(
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
