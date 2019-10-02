import 'dart:ui';
import '../layers/Vector/geombase.dart';
import '../utils/geopoint.dart';
import '../core/viewport.dart';
import 'Vector/vectors.dart';
import '../utils/mapposition.dart';
import 'layer.dart';

class VectorLayer extends Layer {
  VectorLayer() {
    _vectors = new Vectors();
  }

  Vectors _vectors;

  void AddVectors(GeomBase vector) {
    _vectors.add(vector);
    vector.setUpdateListener(_vectorUpdated);
    fireUpdatedLayer();
  }

  void paint(Canvas canvas, Size size) {
    for (GeomBase vector in _vectors) {
      vector.paint(canvas);
    }
  }

  @override
  void notifyLayer(MapPosition mapPosition, Viewport viewport) {
    _mapPosition = mapPosition;
    _viewport = viewport;
    _setupVectorsForViewport();
  }

  @override
  void doTabCheck(GeoPoint clickedPosition, Offset screenPos) {

  }

  void _vectorUpdated(GeomBase vector) {

  }

  void _setupVectorsForViewport() {
    for (GeomBase vector in _vectors) {
      vector.CalculatePixelPosition(_viewport, _mapPosition);
    }
  }

  MapPosition _mapPosition;
  Viewport _viewport;

}