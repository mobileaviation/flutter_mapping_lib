import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/utils/mapposition.dart';
import 'package:mapping_library/src/core/mapviewport.dart';
import 'package:mapping_library/src/test/layerpainter.dart';
import 'package:mapping_library/src/test/tilelayerpainter.dart';

class TileLayer extends Layer {
  TileLayer({Key key, Color backgroundColor}) : super(key) {
    layerPainter = TileLayerPainter();
    layerPainter.layer = this;
    bgColor = backgroundColor;

  }

  get _layerPainter {
    return (layerPainter as TileLayerPainter);
  }

  set bgColor(value) {
    _bgColor = value;
    _layerPainter.backgroundColor = _bgColor;
  }

  Color _bgColor;

  @override
  mapTap(TapUpDetails tapUpdetails) {
    log(tapUpdetails.localPosition.toString());
    return super.mapTap(tapUpdetails);
  }

  @override
  notifyLayer(MapPosition mapPosition, MapViewport viewport) {
    super.notifyLayer(mapPosition, viewport);
  }
}

class Layer extends StatefulWidget {
  Layer(Key key) : super(key: key);

  LayerPainter layerPainter;
  Size _size;
  set size(value) {_size = value; }
  get size { return _size; }

  set layerUpdated(value) { _layerUpdated = value; }
  Function(Layer layer) _layerUpdated;

  void updatedLayer(Size size) {
    _size = size;
    if (_layerUpdated != null) _layerUpdated(this);
  }

  mapTap(TapUpDetails tapUpdetails) {}

  notifyLayer(MapPosition mapPosition, MapViewport viewport) {}

  @override
  _LayerState createState() => _LayerState();
}

class _LayerState extends State<Layer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: CustomPaint(
          foregroundPainter: widget.layerPainter,
        ),
        onTapUp: widget.mapTap,
        behavior: HitTestBehavior.translucent,
      ),
      height: double.infinity,
      width: double.infinity,
    );
  }
}
