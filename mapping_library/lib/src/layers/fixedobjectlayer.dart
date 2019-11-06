import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/core/mapviewport.dart';
import '../objects/fixedobject/fixedobject.dart';
import 'layer.dart';
import 'painters/fixedobjectlayerpainter.dart';

class FixedObjectLayer extends Layer {
  FixedObjectLayer({Key key,
    FixedObject fixedObject,
    String name}) : super(key) {

    this.fixedObject = fixedObject;
    layerPainter = FixedObjectLayerPainter();
    layerPainter.layer = this;

    this.name = (name == null) ? "FixedObjectLayer" : name;
  }

  FixedObject fixedObject;

  _setup(MapViewport viewport) {
    fixedObject.calculate(viewport.mapPosition, viewport);
  }

  @override
  notifyLayer(MapViewport viewport, bool mapChanged) {
    super.notifyLayer(viewport, mapChanged);
    _setup(viewport);
  }

}