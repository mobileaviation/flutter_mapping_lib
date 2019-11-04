import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/core/mapviewport.dart';
import 'package:mapping_library/src/test/layer.dart';
import 'package:mapping_library/src/test/layers.dart';
import 'package:mapping_library/src/utils/mapposition.dart';

class Mapview extends StatefulWidget {
  Mapview({Key, key, Layers layers, MapPosition mapPosition})
      : super(key: key) {
    _layers = layers;
    _layers.updatedLayer = _layerUpdated;
    _mapPosition = mapPosition;
    _size = Size.square(1000);
    _mapViewport = MapViewport(_size, _mapPosition);
    _layers.mapViewPort = _mapViewport;
    _layers.notifyChildren();
  }

  @override
  _MapviewState createState() => _MapviewState();

  Layers _layers;

  Size _size;
  Size get size => _size;

  MapPosition _mapPosition;
  MapPosition get mapPosition => _mapPosition;
  set mapPosition(value) {
    _mapPosition = value;
    _layers.notifyChildren();
  }

  MapViewport _mapViewport;
  MapViewport get mapViewport => _mapViewport;

  void _layerUpdated(Layer updatedLayer) {
    log("Layer (${updatedLayer.name}) Updated ${updatedLayer.size.toString()}");
  }
}

class _MapviewState extends State<Mapview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget._layers,
    );
  }
}
