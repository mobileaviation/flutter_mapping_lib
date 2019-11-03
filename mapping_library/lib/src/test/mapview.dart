import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/core/mapviewport.dart';
import 'package:mapping_library/src/test/layer.dart';
import 'package:mapping_library/src/test/layers.dart';
import 'package:mapping_library/src/utils/mapposition.dart';


class Mapview extends StatefulWidget {
  Mapview({Key, key, Layers layers, MapPosition mapPosition}): super(key: key) {
    _layers = layers;
    _layers.updatedLayer = _layerUpdated;
    _mapPosition = mapPosition;
  }
  @override
  _MapviewState createState() => _MapviewState();

  Layers _layers;
  MapPosition _mapPosition;
  MapViewport _mapViewport;

  void _layerUpdated(Layer updatedLayer) {
    log("Layer Updated");
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
