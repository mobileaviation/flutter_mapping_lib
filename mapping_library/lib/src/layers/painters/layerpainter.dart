import 'dart:async';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/layers/layers.dart';
import '../layer.dart';

class LayerPainter extends ChangeNotifier implements CustomPainter {
  LayerPainter() : super() {
    _setupFrameTimer();
  }

  _setupFrameTimer() {
    _notifyTimer = Timer.periodic(Duration(milliseconds: 40), _notifyListeners);
  }

  Layers layers;
  Timer _notifyTimer;

  @override
  bool hitTest(Offset position) {
    return null;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _doRedraw = false;
    for (Layer l in layers.layers) {
      l.painter = this;
      l.layerPainter.paint(canvas, size);
    }
    layers.mapViewPort.setMapSize(size);
    layers.size = size;
  }

  bool _doRedraw = false;
  void redraw() {
    _doRedraw = true;
  }

  void _notifyListeners(Timer t) {
    if (_doRedraw) {
      notifyListeners();
    }
  }

  @override
  // TODO: implement semanticsBuilder
  get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    // TODO: implement shouldRebuildSemantics
    return true;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }


}