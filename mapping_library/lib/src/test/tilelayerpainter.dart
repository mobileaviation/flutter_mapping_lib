import 'dart:ui';
import 'package:mapping_library/src/test/layerpainter.dart';

class TileLayerPainter extends LayerPainter {
  set backgroundColor(value) { _backgroundColor = value; }
  get backgroundColor { return _backgroundColor; }
  Color _backgroundColor;

  paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    Paint paint = Paint()
      ..color = _backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    layer.updatedLayer(size);
  }

  @override
  void addListener(listener) {
    super.addListener(listener);
  }

  @override
  void removeListener(listener) {
    super.removeListener(listener);
  }
}