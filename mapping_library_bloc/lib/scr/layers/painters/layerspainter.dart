import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:mapping_library_bloc/scr/layers/layer.dart';
import 'package:mapping_library_bloc/scr/layers/layers.dart';

class LayersPainter extends CustomPainter {
  LayersPainter({Key key, this.layers});

  final Layers layers;

  @override
  void paint(Canvas canvas, Size size) {
    // prepare Tiles for location, zoom and size
    // Test data
    // start async download of tiles
    // await the streams and redraw the canvas
    log("LayersPainter paint()");
    for (Layer layer in layers)
      layer.paint(canvas);
  }

  @override 
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}