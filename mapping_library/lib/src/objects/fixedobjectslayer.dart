import 'dart:ui';
import 'package:mapping_library/mapping_library.dart';
import './fixedobject/fixedobject.dart';
import './fixedobject/fixedobjects.dart';
import 'layer.dart';

class FixedObjectsLayer extends Layer {
  FixedObjectsLayer() {
    _objects = FixedObjects();
  }

  FixedObjects _objects;

  void addObjects(FixedObject object) {
    _objects.add(object);
    object.setUpdateListener(_objectUpdated);
    fireUpdatedLayer();
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (FixedObject object in _objects) {
      object.paint(canvas);
    }
  }

  @override
  void notifyLayer(MapPosition mapPosition, MapViewport viewport) {
    _mapPosition = mapPosition;
    _viewport = viewport;
    _setupObjectsForViewport();
  }

  void _objectUpdated(FixedObject object) {
    _setupObjectsForViewport();
    fireUpdatedLayer();
  }

  void _setupObjectsForViewport() {
    for (FixedObject object in _objects) {
      object.calculate(_mapPosition, _viewport);
    }
  }

  MapPosition _mapPosition;
  MapViewport _viewport;
}