import 'dart:ui';
import 'markerrenderer.dart';

class PointMarkerRenderer extends MarkerRenderer {
  PointMarkerRendererData _data;

  @override
  void setup(dynamic data) {
    if (data is PointMarkerRendererData) _data = data;
  }

  @override
  Picture draw(Size size) {
    if (_data != null) {
      PictureRecorder drawerRec = PictureRecorder();
      Canvas drawerCanvas = Canvas(drawerRec);

      Paint p = new Paint();
      p.isAntiAlias = true;
      p.color = _data.backgroundColor;
      p.style = PaintingStyle.fill;
      drawerCanvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          ((size.width / 2) - (_data.borderWidth/2)), p);

      p.color = _data.borderColor;
      p.strokeWidth = _data.borderWidth;
      p.style = PaintingStyle.stroke;
      drawerCanvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          ((size.width / 2) - (_data.borderWidth/2)), p);

      return drawerRec.endRecording();
    } else throw new Exception("No PointMarkerRenderer data supplied!!");
  }
}

class PointMarkerRendererData {
  Color backgroundColor;
  Color borderColor;
  double borderWidth;
}