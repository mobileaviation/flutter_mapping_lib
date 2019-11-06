import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:mapping_library/mapping_library.dart';
import '../utils/geopoint.dart';
import '../utils/mapposition.dart';
import '../core/mapviewport.dart' as viewPort;
import 'layer.dart';
import 'layers.dart';
import 'markerslayer.dart';
import 'vectorlayer.dart';

class LayerPainter extends ChangeNotifier implements CustomPainter {
  LayerPainter() {
    _layers = Layers();
    _startPaintFps();
  }

  Layers _layers;
  bool _repaint = false;

  void addLayer(Layer layer) {
    layer.setUpdateListener(_layerUpdated);
    _layers.add(layer);
  }

  void notifyLayers(MapPosition mapPosition, viewPort.MapViewport viewport) {
    for (Layer l in _layers) {
      l.notifyLayer(mapPosition, viewport);
    }
  }

  void doLayerTabCheck(GeoPoint clickedPosition, Offset screenPos) {
    for (Layer l in _layers) {
      l.doTabCheck(clickedPosition, screenPos);
    }
  }

  void dragStart(GeoPoint clickedPosition, Offset screenPos) {
    for (Layer l in _layers) {
      if ((l is MarkersLayer)||(l is VectorLayer)) {
        l.dragStart(clickedPosition, screenPos);
      }
    }
  }
  void drag(GeoPoint clickedPosition, Offset screenPos) {
    for (Layer l in _layers) {
      if ((l is MarkersLayer)||(l is VectorLayer)) {
        l.drag(clickedPosition, screenPos);
      }
    }
  }
  void dragEnd(GeoPoint clickedPosition, Offset screenPos) {
    for (Layer l in _layers) {
      if ((l is MarkersLayer)||(l is VectorLayer)) {
        l.dragEnd(clickedPosition, screenPos);
      }
    }
  }

  void _layerUpdated(Layer layer) {
    _repaint = true;
  }

  void _startPaintFps() {
    Timer.periodic(new Duration(milliseconds: 20), _frameDraw);
  }

  void _frameDraw(Timer timer) {
    if (_repaint) {
      _repaint = false;
      notifyListeners();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (Layer l in _layers) {
      l.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool hitTest(Offset position) {
    return null;
  }

  @override
  get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return true;
  }
}
