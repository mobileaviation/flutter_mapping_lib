import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geometric_utils/geometric_utils.dart';

import 'markerrenderer.dart';

class ButtonsMarkerRenderer extends MarkerRenderer {

  ButtonsMarkerData _data;
  Size get size => _data.size;

  @override
  void setup(dynamic data) {
    if (data is ButtonsMarkerData) {
      _data = data;
    }
  }

  @override
  Picture draw(Size size) {
    if (_data != null) {
      PictureRecorder drawerRec = PictureRecorder();
      Canvas drawerCanvas = Canvas(drawerRec);
      Point p = Point(0.0, 0.0);
      for(PolylineEditButton buttonMarker in _data.buttons) {
        _paintButton(drawerCanvas, p, buttonMarker);
        p = Point(0.0, p.y + buttonMarker.height + buttonMarker.margin);
      }

      return drawerRec.endRecording();
    } else throw new Exception("No ButtonsMarkerRendererData data supplied!!");
  }

    void _paintButton(Canvas canvas, Point origin, PolylineEditButton button) {
    Radius r = Radius.circular(button.radius);
    RRect drawrect = RRect.fromLTRBR(origin.x, origin.y, 
      origin.x + button.width, origin.y + button.height, r);
    button.rRect = drawrect;

    Paint paint = Paint()
      ..color = button.color
      ..strokeWidth = 2
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    canvas.drawRRect(drawrect, paint);

    paint = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 2
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(drawrect, paint);

    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.blue[800], fontSize: 20), text: button.text);
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout(minWidth: button.width, maxWidth: button.width);
    tp.paint(canvas, new Offset(origin.x, origin.y + 5.0));
  }
}

class ButtonsMarkerData {
  ButtonsMarkerData() {
    buttons = List<PolylineEditButton>();
  }
  List<PolylineEditButton> buttons;

  GeoPoint location;

  Size get size {
    double h = 0;
    double w = 0;
    for (PolylineEditButton b in buttons) {
      h = h + b.height + b.margin;
      if (b.width>w) w = b.width;
    }
    return Size(w,h);
  } 

  PolylineEditButton checkButtonClicked(Point position) {
    for (PolylineEditButton button in buttons)
      if (button.hitTestP(position)) 
        return button;
    return null;
  }
}

class PolylineEditButton {
  PolylineEditButton() {
    width = 70.0;
    height = 50.0;
    margin = 10.0;
    radius = 10.0;
    color = Colors.amberAccent;
  }
  double width;
  double height;
  double margin;
  double radius;
  Color color;
  String text;
  Object tag;
  RRect rRect;

  bool hitTestP(Point p) {
    return hitTestO(Offset(p.x, p.y));
  }

  bool hitTestO(Offset p) {
    if (rRect == null) 
      return false; 
    else
      return rRect.contains(p);
  }
}