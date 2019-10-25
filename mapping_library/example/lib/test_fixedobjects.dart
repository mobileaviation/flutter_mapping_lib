import 'dart:ui';
import 'package:mapping_library/mapping_library.dart';

void addTestFixedObject(MapView mapView) {
  FixedObjectsLayer fixedObjectsLayer = FixedObjectsLayer();
  mapView.addLayer(fixedObjectsLayer);

  // At this point in time the only Fixed object is the ScaleBar
  ScaleBar testObject = ScaleBar(FixedObjectPosition.lefttop, Offset(10,10));
  fixedObjectsLayer.addObjects(testObject);

  // You can create your own fixed object by extending the FixedObject class
  // and overriding the calculate and paint methods
}