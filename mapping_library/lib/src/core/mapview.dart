import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'mapviewgestures.dart';
import 'package:mapping_library/src/core/mapviewport.dart';
import '../layers/layer.dart';
import '../layers/layers.dart';
import 'package:mapping_library/src/utils/mapposition.dart';

class Mapview extends StatefulWidget {
  Mapview({Key, key, Layers layers, MapPosition mapPosition})
      : super(key: key) {
    _layers = layers;
    _layers.updatedLayer = _layerUpdated;
    _mapPosition = mapPosition;
    _size = Size.square(1000);
    _mapViewport = MapViewport(_size, _mapPosition);
    _gestures = MapViewGestures(this, _layers);
    _layers.mapViewPort = _mapViewport;
    _layers.notifyChildren(true);
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
    _mapViewport.setMapPosition(_mapPosition);
    _layers.mapViewPort = _mapViewport;
    _layers.notifyChildren(true);
  }

  MapViewport _mapViewport;
  MapViewport get mapViewport => _mapViewport;

  MapViewGestures _gestures;

  void _layerUpdated(Layer updatedLayer) {
    //log("Layer (${updatedLayer.name}) Updated ${updatedLayer.size.toString()}");
    _changeSize(updatedLayer.size);
  }

  void _changeSize(Size size) {
    if ((size.width != _size.width) || (size.height != _size.height)) {
      _size = size;
      _mapViewport.setMapSize(_size);
      _layers.notifyChildren(true);
    }
  }
}

class _MapviewState extends State<Mapview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector (
        child: widget._layers,
        behavior: HitTestBehavior.translucent,
        onTapUp: widget._gestures.mapTap,
        onScaleStart: widget._gestures.mapScaleStart,
        onScaleUpdate: widget._gestures.mapScaleUpdate,
        onLongPressStart: widget._gestures.mapLongPressStart,
        onLongPressMoveUpdate: widget._gestures.mapLongPressMoveUpdate,
        onLongPressEnd: widget._gestures.mapLongPressEnd,
      ),
    );
  }
}
