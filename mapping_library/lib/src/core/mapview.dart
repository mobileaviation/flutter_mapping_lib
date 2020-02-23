import 'package:flutter/widgets.dart';
import 'mapviewgestures.dart';
import 'mapviewport.dart';
import '../layers/layers.dart';
import '../utils/mapposition.dart';

class Mapview extends StatefulWidget {
  Mapview({Key, key, Layers layers, MapPosition mapPosition})
      : super(key: key) {
    _layers = layers;
    _mapPosition = mapPosition;
    _size = Size.square(1000);
    _mapViewport = MapViewport(_size, _mapPosition);
    _gestures = MapViewGestures(this, _layers);
    _layers.mapViewPort = _mapViewport;
    _layers.notifyLayers(true);
  }

  @override
  _MapviewState createState() => _MapviewState();

  Layers _layers;
  AnimationController controller;

  Size _size;
  Size get size => _size;

  MapPosition _mapPosition;
  MapPosition get mapPosition => _mapPosition;
  set mapPosition(value) {
    _mapPosition = value;
    _mapViewport.setMapPosition(_mapPosition);
    _layers.mapViewPort = _mapViewport;
    _layers.notifyLayers(true);
  }

  MapViewport _mapViewport;
  MapViewport get mapViewport => _mapViewport;

  MapViewGestures _gestures;
}

class _MapviewState extends State<Mapview> with TickerProviderStateMixin  {
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    widget._gestures.controller = AnimationController(vsync: this,  duration: Duration(milliseconds: 300));
//    log("InitState");
//  }

//  _MapviewState() {
//    widget._gestures.controller = AnimationController(vsync: this,  duration: Duration(milliseconds: 300));
//  }

  @override
  Widget build(BuildContext context) {
    widget._gestures.controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500));
    return Container(
      child: GestureDetector (
        child: widget._layers,
        behavior: HitTestBehavior.translucent,
        onTapUp: widget._gestures.mapTap,
        onScaleStart: widget._gestures.mapScaleStart,
        onScaleUpdate: widget._gestures.mapScaleUpdate,
        onScaleEnd: widget._gestures.mapScaleEnd,
        onLongPressStart: widget._gestures.mapLongPressStart,
        onLongPressMoveUpdate: widget._gestures.mapLongPressMoveUpdate,
        onLongPressEnd: widget._gestures.mapLongPressEnd,
      ),
    );
  }
}
