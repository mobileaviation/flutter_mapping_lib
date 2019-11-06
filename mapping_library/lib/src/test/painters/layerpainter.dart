import 'dart:ui';

import 'package:flutter/widgets.dart';
import '../layer.dart';

class LayerPainter extends ChangeNotifier implements CustomPainter {
  Layer layer;

  @override
  bool hitTest(Offset position) {
    return null;
  }

  @override
  void paint(Canvas canvas, Size size) {
    layer.size = size;
    layer.mapViewPort.setMapSize(size);
    layer.layerUpdated(layer);
  }

  void redraw() {
    notifyListeners();
  }

  bool _doRedraw = true;
  bool get doRedraw => _doRedraw;
  set doRedraw(bool value) { _doRedraw = value; }

  Picture _layerPicture;
  Picture get layerPicture => _layerPicture;
  set layerPicture(Picture value) { _layerPicture = value; }

  @override
  // TODO: implement semanticsBuilder
  get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    // TODO: implement shouldRebuildSemantics
    return false;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }


}