import 'dart:ui';
import 'dart:math' as math;
import '../core/mapviewport.dart';
import 'markers/markerbase.dart';
import '../utils/mapposition.dart';
import 'markers/markers.dart';
import 'layer.dart';
import '../utils/geopoint.dart';

class MarkersLayer extends Layer {
  MarkersLayer() {
    _markers = Markers();
  }

  Markers _markers;

  void addMarker(MarkerBase marker) {
    _markers.add(marker);
    marker.setUpdateListener(_markerUpdated);
    fireUpdatedLayer();
  }

  void _markerUpdated(MarkerBase marker) {
    _setupMarkersForViewport();
  }

  void paint(Canvas canvas, Size size) {
    for (MarkerBase marker in _markers) {
      if (marker.withinViewport(_viewport)) {
        marker.paint(canvas);
      }
    }
  }

  @override
  void notifyLayer(MapPosition mapPosition, MapViewport viewport) {
    // Calculate the position if the Markers for the current viewport and mapPosition
    _mapPosition = mapPosition;
    _viewport = viewport;
    _setupMarkersForViewport();
  }

  @override
  void doTabCheck(GeoPoint clickedPosition, Offset screenPos) {
    for (MarkerBase marker in _markers) {
      if (marker.markerSelectedByScreenPos(screenPos)) {
        marker.selected = !marker.selected;
        _fireMarkerSelected(marker);
      }
    }
  }

  @override
  void dragStart(GeoPoint clickedPosition, Offset screenPos) {
    // Check if there is a marker om screenPos
    // If is, mark this marker as draggin = true
    // store its startdraggin location (screenPos)
    // Calculate the offset between its current position and the screenPos
    for (MarkerBase marker in _markers) {
      if (marker.dragable) {
        if (marker.markerSelectedByScreenPos(screenPos)) {
          marker.selected = true;
          _markers.dragginMarker = marker;
          _markers.dragginOffset = Offset(screenPos.dx - marker.drawingPoint.x,
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
    if (_markers.dragginMarker != null) {
      Offset s = Offset(screenPos.dx - _markers.dragginOffset.dx,
          screenPos.dy - _markers.dragginOffset.dy);
      GeoPoint tp =
          _viewport.getGeopointForScreenPosition(math.Point(s.dx, s.dy));
      _markers.dragginMarker.location = tp;
      if (markerDrag != null) markerDrag(_markers.dragginMarker, tp);
    }
  }

  @override
  void dragEnd(GeoPoint clickedPosition, Offset screenPos) {
    // Update the marker(s) set draggin = false
    // fire a markerPositionChanged event to the mapview
    if (markerDrag != null) markerDrag(_markers.dragginMarker, clickedPosition);
    _markers.dragginMarker.selected = false;
    _markers.dragginOffset = null;
    _markers.dragginMarker = null;
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

  void _setupMarkersForViewport() {
    for (MarkerBase marker in _markers) {
      marker.calculatePixelPosition(_viewport, _mapPosition);
      marker.doDraw().then(_imageRetrieved);
    }
  }

  void _imageRetrieved(Image image) {
    fireUpdatedLayer();
  }

  MapPosition _mapPosition;
  MapViewport _viewport;
}
