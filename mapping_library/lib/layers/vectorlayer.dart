import 'dart:developer';
import 'dart:ui';
import '../layers/Vector/polygon.dart';
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
      if (vector.WithinViewport(_viewport)) {
        vector.paint(canvas);
      }
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
    for (GeomBase vector in _vectors) {
      if (vector.WithinViewport(_viewport)) {
        if (vector.WithinPolygon(clickedPosition, screenPos)) {
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
      vector.CalculatePixelPosition(_viewport, _mapPosition);
    }
  }

  Function(GeomBase vector, GeoPoint clickedPosition) VectorSelected;
  void _fireVectorSelected(GeomBase vector, GeoPoint clickedPosition) {
    if (VectorSelected != null) {
      VectorSelected(vector, clickedPosition);
    }
  }

  MapPosition _mapPosition;
  Viewport _viewport;


}