import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/core/mapviewport.dart';
import 'package:mapping_library/src/layers/markers/markerbase.dart';
import 'package:mapping_library/src/layers/markers/markers.dart';
import 'package:mapping_library/src/utils/geopoint.dart';
import 'package:mapping_library/src/utils/mercatorprojection.dart' as MercatorProjection;
import 'layer.dart';
import 'painters/markerslayerpainter.dart';

class MarkersLayer extends Layer {
  MarkersLayer({Key key,
    Markers markers,
    Function(MarkerBase marker) markerSelected,
    String name}) : super(key) {

    this.markers = markers;
    _setMarkersUpdateListener();

    layerPainter = MarkersLayerPainter();
    layerPainter.layer = this;

    this.markerSelected = markerSelected;

    this.name = (name == null) ? "MarkersLayer" : name;
  }

  Markers markers;
  MarkerBase _dragginMarker;
  Offset _dragginOffset;

  _setMarkersUpdateListener() {
    for (MarkerBase marker in markers) {
      marker.setUpdateListener(_markerUpdated);
    }
  }

  _setup(MapViewport viewport) {
    for (MarkerBase marker in markers) {
      marker.calculatePixelPosition(viewport, viewport.mapPosition);
      marker.doDraw().then((image) {
        layerPainter.redraw();
      });
    }
  }

  void _markerUpdated(MarkerBase marker) {
    notifyLayer(mapViewPort, true);
  }

  @override
  notifyLayer(MapViewport viewport, bool mapChanged) {
    super.notifyLayer(viewport, mapChanged);
    _setup(viewport);
  }

  void addMarker(MarkerBase marker) {
    marker.setUpdateListener(_markerUpdated);
    markers.add(marker);
    _setup(mapViewPort);
  }

  @override
  void doTabCheck(GeoPoint clickedPosition, Offset screenPos) {
    for (MarkerBase marker in markers) {
      if (marker.markerSelectedByScreenPos(screenPos)) {
        marker.selected = !marker.selected;
        _fireMarkerSelected(marker);
      } else marker.selected = false;
    }
  }

  @override
  void dragStart(GeoPoint clickedPosition, Offset screenPos) {
    // Check if there is a marker om screenPos
    // If is, mark this marker as draggin = true
    // store its startdraggin location (screenPos)
    // Calculate the offset between its current position and the screenPos
    for (MarkerBase marker in markers) {
      if (marker.dragable) {
        if (marker.markerSelectedByScreenPos(screenPos)) {
          marker.selected = true;
          _dragginMarker = marker;
          _dragginOffset = Offset(screenPos.dx - marker.drawingPoint.x,
              screenPos.dy - marker.drawingPoint.y);
          if (markerDragStart != null) markerDragStart(marker, clickedPosition);
          break;
        }
      }
    }
  }

  @override
  void drag(GeoPoint clickedPosition, Offset screenPos) {
    // Update the marker(s) (draggin = true) position
    // newPosition = screenPos + markerOffset (from dragStart)
    // fire markerupdated for repaint
    if (_dragginMarker != null) {
      Offset s = Offset(screenPos.dx - _dragginOffset.dx,
          screenPos.dy - _dragginOffset.dy);
      GeoPoint tp =
      mapViewPort.getGeopointForScreenPosition(math.Point(s.dx, s.dy));
      _dragginMarker.location = tp;
      if (markerDrag != null) markerDrag(_dragginMarker, tp);
    }
  }

  @override
  void dragEnd(GeoPoint clickedPosition, Offset screenPos) {
    // Update the marker(s) set draggin = false
    // fire a markerPositionChanged event to the mapview
    if (_dragginMarker != null) {
      if (markerDragEnd != null) markerDragEnd(_dragginMarker, clickedPosition);
      _dragginMarker.selected = false;
      _dragginOffset = null;
      _dragginMarker = null;
    }
  }

  Function(MarkerBase marker) markerSelected;
  Function(MarkerBase marker, GeoPoint startPosition) markerDragStart;
  Function(MarkerBase marker, GeoPoint dragToPosition) markerDrag;
  Function(MarkerBase marker, GeoPoint endPosition) markerDragEnd;

  void _fireMarkerSelected(MarkerBase marker) {
    if (markerSelected != null) {
      markerSelected(marker);
    }
  }
}