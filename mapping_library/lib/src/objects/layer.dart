import 'dart:ui';
import '../utils/geopoint.dart';
import '../core/mapviewport.dart';
import '../utils/mapposition.dart';

class Layer {
  void paint(Canvas canvas, Size size) {}

  void setUpdateListener(Function listener) {
    _updatedLayer = listener;
  }

  void notifyLayer(MapPosition mapPosition, MapViewport viewport) {}
  Function(Layer layer) _updatedLayer;

  void doTabCheck(GeoPoint clickedPosition, Offset screenPos) {}

  void dragStart(GeoPoint clickedPosition, Offset screenPos) {}
  void drag(GeoPoint clickedPosition, Offset screenPos) {}
  void dragEnd(GeoPoint clickedPosition, Offset screenPos) {}

  void fireUpdatedLayer() {
    if (_updatedLayer != null) {
      _updatedLayer(this);
    }
  }
}
