import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/core/mapviewport.dart';
import 'package:mapping_library/src/test/layerpainter.dart';
import 'package:mapping_library/src/test/testlayerpainter.dart';

class TestLayer extends Layer {
  TestLayer({Key key, Color backgroundColor,
      Size backgroundSize,
      Offset backgroundOffset,
      String name}) : super(key) {
    layerPainter = TestLayerPainter();
    layerPainter.layer = this;
    bgColor = backgroundColor;
    bgSize = backgroundSize;
    bgPosition = backgroundOffset;
    _name = (name == null) ? "TileLayer" : name;
  }

  get _layerPainter {
    return (layerPainter as TestLayerPainter);
  }

  set bgColor(value) {
    _layerPainter.backgroundColor = value;
  }
  set bgSize(value) {
    _layerPainter.blockSize = value;
  }
  set bgPosition(value) {
    _layerPainter.blockPosition = value;
  }


  @override
  mapTap(TapUpDetails tapUpdetails) {
    log(tapUpdetails.localPosition.toString());
    layerPainter.redraw();
    return super.mapTap(tapUpdetails);
  }

  @override
  notifyLayer(MapViewport viewport) {
    super.notifyLayer(viewport);
  }
}

class Layer extends StatelessWidget {
  Layer(Key key) : super(key: key);

  LayerPainter layerPainter;

  String _name;
  set name(value) {_name = name; }
  String get name => _name;

  Size _size;
  set size(value) {_size = value; }
  get size { return _size; }

  MapViewport _mapViewport;
  MapViewport get mapViewPort => _mapViewport;
  set mapViewPort(value) {
    _mapViewport = value;
  }

  set layerUpdated(value) { _layerUpdated = value; }
  Function(Layer layer) get layerUpdated => _layerUpdated;
  Function(Layer layer) _layerUpdated;

  mapTap(TapUpDetails tapUpdetails) {}

  notifyLayer(MapViewport viewport) {
    _mapViewport = viewport;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: CustomPaint(
          painter: layerPainter,
        ),
        onTapUp: mapTap,
        behavior: HitTestBehavior.translucent,
      ),
      height: double.infinity,
      width: double.infinity,
    );
  }
}
