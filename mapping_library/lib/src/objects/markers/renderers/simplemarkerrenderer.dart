import 'dart:ui';
import 'package:flutter/material.dart';
import 'markerrenderer.dart';

/// SimpleMarkerRenderer is a test render class
///
/// This class gives an example of how to build a marker renderer
class SimpleMarkerRenderer extends MarkerRenderer {
  SimpleMarkerRenderer() : super() {
    _rotation = 0;
  }
  @override
  void setup(dynamic data) {
    if (data is double) _rotation = data;
  }

  double _rotation;

  @override
  Picture draw(Size size) {
    PictureRecorder drawerRec = PictureRecorder();

    Canvas drawerCanvas = Canvas(drawerRec);
    Paint p = new Paint();
    p.color = const Color.fromARGB(128, 255, 0, 255);
    p.isAntiAlias = true;
    drawerCanvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, p);

    p.color = const Color.fromARGB(128, 100, 0, 100);
    drawerCanvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 3, p);

    p.color = Colors.black;
    p.strokeWidth = 2;
    p.style = PaintingStyle.stroke;

    Path path = Path();
    List<Offset> offsets = [
      Offset(size.width/2, 2),
      Offset((size.width/2) + 5, 7),
      Offset((size.width/2) + 5, size.height-2),
      Offset((size.width/2) - 5, size.height-2),
      Offset((size.width/2) - 5, 7),
      Offset(size.width/2, 2)
    ];
    path.addPolygon(offsets, true);
    drawerCanvas.drawPath(path, p);

    TextPainter tp = _getTextPainter(_getTextSpan("${_rotation.floor()}"));
    tp.layout();
    tp.paint(
        drawerCanvas,
        Offset((size.width / 2) - (tp.width / 2),
        (size.height/2) - (tp.height/2)));

    return drawerRec.endRecording();
  }

  TextSpan _getTextSpan(String text) {
    return TextSpan(
        style: TextStyle(
            color: Colors.grey[400],
            fontFamily: 'Verdana',
            fontWeight: FontWeight.bold,
            fontSize: 20),
        text: text);
  }

  TextPainter _getTextPainter(TextSpan text) {
    return TextPainter(
        text: text,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
  }
}
