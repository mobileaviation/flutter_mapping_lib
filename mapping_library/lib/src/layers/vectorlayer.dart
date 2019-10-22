import 'dart:ui';
import '../layers/vector/geombase.dart';
import '../utils/geopoint.dart';
import '../core/mapviewport.dart';
import 'vector/vectors.dart';
import '../utils/mapposition.dart';
import 'layer.dart';

class VectorLayer extends Layer {
  VectorLayer() {
    _vectors = Vectors();
  }

  Vectors _vectors;

  void addVectors(GeomBase vector) {
    _vectors.add(vector);
    vector.setUpdateListener(_vectorUpdated);
    fireUpdatedLayer();
  }

  void paint(Canvas canvas, Size size) {
    for (GeomBase vector in _vectors) {
      if (vector.withinViewport(_viewport)) {
        vector.paint(canvas);
      }
    }
  }

  @override
  void notifyLayer(MapPosition mapPosition, MapViewport viewport) {
    _mapPosition = mapPosition;
    _viewport = viewport;
    _setupVectorsForViewport();
  }

  @override
  void doTabCheck(GeoPoint clickedPosition, Offset screenPos) {
    for (GeomBase vector in _vectors) {
      if (vector.withinViewport(_viewport)) {
        if (vector.withinPolygon(clickedPosition, screenPos)) {
          _fireVectorSelected(vector, clickedPosition);
        }
      }
    }
  }

  void _vectorUpdated(GeomBase vector) {
    _setupVectorsForViewport();
    fireUpdatedLayer();
  }

  void _setupVectorsForViewport() {
    for (GeomBase vector in _vectors) {
      vector.calculatePixelPosition(_viewport, _mapPosition);
    }
  }

  Function(GeomBase vector, GeoPoint clickedPosition) vectorSelected;

  void _fireVectorSelected(GeomBase vector, GeoPoint clickedPosition) {
    if (vectorSelected != null) {
      vectorSelected(vector, clickedPosition);
    }
  }

  MapPosition _mapPosition;
  MapViewport _viewport;
}
