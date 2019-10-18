import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapping_library/layers/vectorlayer.dart';
import 'package:mapping_library/layers/Vector/polyline.dart';
import 'package:mapping_library/utils/geopoint.dart';

void TestPolyLineUpdate(VectorLayer layer) {
  List<GeoPoint> points = [
    GeoPoint(52.373893, 5.232694),
    GeoPoint(52.389645 , 5.298114),
    GeoPoint(52.402879 , 5.366541),
    GeoPoint(52.435251 , 5.39869),
    GeoPoint(52.470789 , 5.423742),
    GeoPoint(52.499938 , 5.46374),
    GeoPoint(52.514271 , 5.535888),
    GeoPoint(52.494923 , 5.574778),
    GeoPoint(52.463048 , 5.57739),
    GeoPoint(52.437308 , 5.573274),
    GeoPoint(52.406982 , 5.561691),
    GeoPoint(52.3901 , 5.516074),
    GeoPoint(52.358604 , 5.495889),
    GeoPoint(52.331196 , 5.520941)
  ];

  int counter = 0;

  Polyline l = new Polyline();
  l.geomPaint.color = Colors.redAccent;
  l.BorderColor = Colors.black;
  l.BorderWidth = 2;

  layer.AddVectors(l);

  Timer.periodic(new Duration(seconds: 1), (Timer t) {
    l.AddPoint(points[counter]);
    counter++;
    if (counter==points.length) {
      t.cancel();
      //l.Visible = false;
    }
  });
}