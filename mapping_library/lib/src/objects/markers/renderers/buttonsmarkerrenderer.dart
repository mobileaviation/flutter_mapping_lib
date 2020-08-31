import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'markerrenderer.dart';

class ButtonsMarkerRenderer extends MarkerRenderer {

  ButtonsMarkerRendererData _data;

  @override
  void setup(dynamic data) {
    if (data is ButtonsMarkerRendererData) _data = data;
  }

  @override
  Picture draw(Size size) {
    if (_data != null) {
      PictureRecorder drawerRec = PictureRecorder();
      Canvas drawerCanvas = Canvas(drawerRec);
      Point p = Point(0, 0);
      for(ButtonMarker buttonMarker : _data.buttons) {
        buttonMarker.paint(drawerCanvas, p);
        p.y = p.y + buttonMarker.height + buttonMarker.margin;
      }

      return drawerRec.endRecording();
    } else throw new Exception("No ButtonsMarkerRendererData data supplied!!");
  }
}

class ButtonsMarkerRendererData {
  ButtonsMarkerRendererData() {
    buttons = List<ButtonMarker>();
  }
  List<ButtonMarker> buttons;
}

class ButtonMarker {
  ButtonMarker() {
    width = 20.0;
    height = 20.0;
    margin = 5.0;
    radius = 5.0;
    color = Colors.amberAccent;
  }
  double width;
  double height;
  double margin;
  double radius;
  Color color;
  String text;

  void paint(Canvas canvas, Point origin) {
    Radius r = Radius.circular(radius);
    RRect drawrect = RRect.fromLTRBR(origin.x, origin.y, 
      origin.x + width, origin.y + height, r);

    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    canvas.drawRRect(drawrect, paint);
  }
}