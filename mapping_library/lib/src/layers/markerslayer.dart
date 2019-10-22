import 'dart:ui';
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
        _fireMarkerSelected(marker);
      }
    }
  }

  Function(MarkerBase marker) markerSelected;

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
