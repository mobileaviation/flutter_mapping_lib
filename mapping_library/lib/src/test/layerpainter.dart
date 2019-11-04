import 'package:flutter/widgets.dart';
import 'layer.dart';

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

  @override
  // TODO: implement semanticsBuilder
  get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}