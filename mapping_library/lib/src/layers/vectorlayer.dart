import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../../mapping_library.dart';
import '../core/mapviewport.dart';
import '../objects/vector/geombase.dart';
import '../objects/vector/markergeopoint.dart';
import '../objects/vector/polyline.dart';
import '../objects/vector/vectors.dart';
import 'package:geometric_utils/geometric_utils.dart';
import 'layer.dart';
import 'painters/vectorlayerpainter.dart';

class VectorLayer extends Layer {
  VectorLayer({Key key,
    Vectors vectors,
    Function(GeomBase vector, GeoPoint clickedPosition, Offset screenPos) vectorSelected,
    Function(GeomBase vector, MarkerGeopoint marker_point, GeoPoint startPosition, Offset screenPos) pointDragStart,
    Function(GeomBase vector, MarkerGeopoint marker_point, GeoPoint dragToPosition, Offset screenPos) pointDrag,
    Function(GeomBase vector, MarkerGeopoint marker_point, GeoPoint endPosition, Offset screenPos) pointDragEnd,
    String name}) //: super(key)
  {
    layerPainter = VectorLayerPainter();
    layerPainter.layer = this;

    this.vectorSelected = vectorSelected;
    this.pointDragStart = pointDragStart;
    this.pointDrag = pointDrag;
    this.pointDragEnd = pointDragEnd;

    this.vectors = vectors;
    _setVectorsUpdateListener();

    this.name = (name == null) ? "VectorLayer" : name;
  }

  Vectors vectors;
  MarkerGeopoint _dragginPoint;
  Offset _dragginOffset;
  GeomBase _draggingVector;

  _setVectorsUpdateListener() {
    for (GeomBase vector in vectors) {
      vector.setUpdateListener(_vectorUpdated);
    }
  }

  _setup(MapViewport viewport) {
    for (GeomBase vector in vectors) {
      vector.calculatePixelPosition(mapViewPort, mapViewPort.mapPosition);
    }
  }

  void _vectorUpdated(GeomBase vector) {
    notifyLayer(mapViewPort, true);
    redrawPainter();
  }

  @override
  notifyLayer(MapViewport viewport, bool mapChanged) {
    super.notifyLayer(viewport, mapChanged);
    _setup(viewport);
  }

  void addVectors(GeomBase vector) {
    vectors.add(vector);
    vector.setUpdateListener(_vectorUpdated);
    _setup(mapViewPort);
  }

  @override
  void doTabCheck(GeoPoint clickedPosition, Offset screenPos) {
    for (GeomBase vector in vectors) {
      if (_checkVector(vector, clickedPosition, screenPos)) {
        _fireVectorSelected(vector, clickedPosition, screenPos);
      }
    }
  }

  bool _checkVector(GeomBase vector, GeoPoint clickedPosition, Offset screenPos) {
    if (vector.withinViewport(mapViewPort)) {
      if (vector.withinPolygon(clickedPosition, screenPos)) {
        return true;
      } else return false;
    } else return false;
  }

  @override
  void dragStart(GeoPoint clickedPosition, Offset screenPos) {
    for (GeomBase vector in vectors) {
      if (_checkVector(vector, clickedPosition, screenPos)) {
        if (vector is Polyline) {
          if ((vector as Polyline).drawMarkers) {
            // Found a polyline, Now check for markers on this line
            _draggingVector = vector;
            for (MarkerGeopoint point in (vector as Polyline).points) {
              if (point.marker.dragable) {
                if (point.marker.markerSelectedByScreenPos(screenPos)) {
                  point.marker.selected = true;
                  _dragginPoint = point;
                  _dragginOffset =
                      Offset(screenPos.dx - point.marker.drawingPoint.x,
                          screenPos.dy - point.marker.drawingPoint.y);
                  if (pointDragStart != null) pointDragStart(
                     _draggingVector, point, clickedPosition, screenPos);
                  _fireVectorSelected(vector, clickedPosition, screenPos);
                  notifyLayer(mapViewPort, true);
                  redrawPainter();
                  break;
                }
              }
            }
          }
        }
      }
    }
  }

  @override
  void drag(GeoPoint clickedPosition, Offset screenPos) {
    if (_dragginPoint != null) {
      Offset s = Offset(screenPos.dx - _dragginOffset.dx,
          screenPos.dy - _dragginOffset.dy);
      GeoPoint tp =
      mapViewPort.getGeopointForScreenPosition(math.Point(s.dx, s.dy));
      _dragginPoint.marker.location = tp;
      _dragginPoint.copyFrom(tp);
      _draggingVector.calculatePixelPosition(mapViewPort, mapViewPort.mapPosition);
      if (pointDrag != null) pointDrag(_draggingVector, _dragginPoint, tp, screenPos);
      notifyLayer(mapViewPort, true);
      redrawPainter();
    }
  }

  @override
  void dragEnd(GeoPoint clickedPosition, Offset screenPos) {
    if (_dragginPoint != null) {
      if (pointDragEnd != null) pointDragEnd(_draggingVector, _dragginPoint, clickedPosition, screenPos);
      _dragginPoint.marker.selected = false;
      _dragginOffset = null;
      _dragginPoint = null;
      notifyLayer(mapViewPort, true);
      redrawPainter();
    }
  }

  Function(GeomBase vector, GeoPoint clickedPosition, Offset screenPos) vectorSelected;
  Function(GeomBase vector, MarkerGeopoint marker_point, GeoPoint startPosition, Offset screenPos) pointDragStart;
  Function(GeomBase vector, MarkerGeopoint marker_point, GeoPoint dragToPosition, Offset screenPos) pointDrag;
  Function(GeomBase vector, MarkerGeopoint marker_point, GeoPoint endPosition, Offset screenPos) pointDragEnd;

  void _fireVectorSelected(GeomBase vector, GeoPoint clickedPosition, Offset screenPos) {
    if (vectorSelected != null) {
      vectorSelected(vector, clickedPosition, screenPos);
    }
  }
}