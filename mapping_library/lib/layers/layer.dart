import 'dart:ui';

import 'package:mapping_library/utils/geopoint.dart';

import '../core/viewport.dart';
import '../utils/mapposition.dart';

class Layer {
  void paint(Canvas canvas, Size size) {}

  void setUpdateListener(Function listener) {
    _updatedLayer = listener;
  }

  void notifyLayer(MapPosition mapPosition, Viewport viewport) {}
  Function(Layer layer) _updatedLayer;
  void doTabCheck(GeoPoint clickedPosition, Offset screenPos) {}

  void fireUpdatedLayer() {
    if (_updatedLayer != null) {
      _updatedLayer(this);
    }
  }
}