import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../../objects/markers/markerbase.dart';
import '../markerslayer.dart';
import 'layerpainter.dart';

class MarkersLayerPainter extends LayerPainter {

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    MarkersLayer markersLayer = layer as MarkersLayer;

    for (MarkerBase markerBase in markersLayer.markers) {
      if (markerBase.withinViewport(markersLayer.mapViewPort)) {
        markerBase.paint(canvas);
      }
    }
  }

  @override
  void redraw() {
    super.redraw();
  }
}