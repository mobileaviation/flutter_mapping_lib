import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/mapviewport.dart';
import 'fixedobject.dart';
import '../../utils/mapposition.dart';

class ScaleBar extends FixedObject {
  ScaleBar(FixedObjectPosition fixedObjectPosition, Offset objectMargin) {
    margin = objectMargin;
    position = fixedObjectPosition;
  }

  double _scaleDistance;

  @override
  void calculate(MapPosition mapPosition, MapViewport viewport) {
    double horDistanceM = viewport.getBoundingBox().getLongitudeDistance();
    double horDistanceMroundedKm =
        (horDistanceM / 10000).roundToDouble() * 10000;

    double roundedScaleFactor = horDistanceMroundedKm / horDistanceM;

    _scaleDistance = (horDistanceMroundedKm / 5);
    double horWidth = viewport.getScreenSize().width;
    double scaleWidth = (horWidth / 5) * roundedScaleFactor;

    size = Size(scaleWidth, 36);

    super.calculate(mapPosition, viewport);
  }

  @override
  void paint(Canvas canvas) {
    Paint p = Paint()
      ..strokeWidth = 1
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    Rect r = Rect.fromLTWH(
        leftTopObjectPos.dx, leftTopObjectPos.dy + 12, size.width, 6);
    canvas.drawRect(r, p);
    r = Rect.fromLTWH(
        leftTopObjectPos.dx, leftTopObjectPos.dy + 18, size.width, 6);
    canvas.drawRect(r, p);

    double kmparts = 5;
    double kmwidth = size.width / kmparts;

    p.style = PaintingStyle.fill;
    r = Rect.fromLTWH(
        leftTopObjectPos.dx + kmwidth, leftTopObjectPos.dy + 12, kmwidth, 6);
    canvas.drawRect(r, p);
    r = Rect.fromLTWH(leftTopObjectPos.dx + (kmwidth * 3),
        leftTopObjectPos.dy + 12, kmwidth, 6);
    canvas.drawRect(r, p);

    double milesScale = 0.6214;
    double mwidth = size.width / (kmparts * milesScale);
    r = Rect.fromLTWH(leftTopObjectPos.dx, leftTopObjectPos.dy + 18, mwidth, 6);
    canvas.drawRect(r, p);
    r = Rect.fromLTWH(leftTopObjectPos.dx + (mwidth * 2),
        leftTopObjectPos.dy + 18, mwidth, 6);
    canvas.drawRect(r, p);

    TextPainter tp = _getTextPainter(_getTextSpan("0"));
    tp.layout();
    tp.paint(canvas, Offset(leftTopObjectPos.dx, leftTopObjectPos.dy));
    tp.paint(canvas, Offset(leftTopObjectPos.dx, leftTopObjectPos.dy + 24));

    tp = _getTextPainter(_getTextSpan("(km)"));
    tp.layout();
    tp.paint(
        canvas,
        Offset(leftTopObjectPos.dx + (size.width / 2) - (tp.width / 2),
            leftTopObjectPos.dy));

    tp = _getTextPainter(_getTextSpan("(mi)"));
    tp.layout();
    tp.paint(
        canvas,
        Offset(leftTopObjectPos.dx + (size.width / 2) - (tp.width / 2),
            leftTopObjectPos.dy + 24));

    int km = (_scaleDistance / 1000).round();
    tp = _getTextPainter(_getTextSpan("$km"));
    tp.layout();
    tp.paint(
        canvas,
        Offset(
            leftTopObjectPos.dx + size.width - tp.width, leftTopObjectPos.dy));

    int mi = (km.toDouble() * milesScale).round();
    tp = _getTextPainter(_getTextSpan("$mi"));
    tp.layout();
    tp.paint(
        canvas,
        Offset(leftTopObjectPos.dx + size.width - tp.width,
            leftTopObjectPos.dy + 24));
  }

  TextSpan _getTextSpan(String text) {
    return TextSpan(
        style: TextStyle(
            color: Colors.grey[900],
            fontFamily: 'Verdana',
            fontWeight: FontWeight.bold,
            fontSize: 12),
        text: text);
  }

  TextPainter _getTextPainter(TextSpan text) {
    return TextPainter(
        text: text,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
  }
}
