import 'dart:ui';
import 'layerpainterbase.dart';

class TestLayerPainter extends LayerPainterBase {

  Color backgroundColor;
  Size blockSize;
  Offset blockPosition;

  @override
  paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    Paint paint = Paint()
      ..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(
        blockPosition.dx,
        blockPosition.dy,
        blockSize.width,
        blockSize.height), paint);


  }
}