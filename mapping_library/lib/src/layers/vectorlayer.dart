import 'dart:developer';
import 'dart:ui';
import 'dart:math' as math;
import '../layers/vector/markergeopoint.dart';
import '../layers/vector/polyline.dart';
import '../layers/vector/geombase.dart';
import '../utils/geopoint.dart';
import '../core/mapviewport.dart';
import 'markers/markerbase.dart';
import 'vector/vectors.dart';
import '../utils/mapposition.dart';
import 'layer.dart';

class VectorLayer extends Layer {
  VectorLayer() {
    _vectors = Vectors();
  }

  Vectors _vectors;
  MarkerGeopoint _dragginPoint;
  Offset _dragginOffset;
  GeomBase _draggingVector;

  void addVectors(GeomBase vector) {
    _vectors.add(vector);
    vector.setUpdateListener(_vectorUpdated);
    fireUpdatedLayer();
  }

  void paint(Canvas canvas, Size size) {
    for (GeomBase vector in _vectors) {
      if (vector.withinViewport(_viewport)) {
        vector.paint(canvas);
      }
    }
  }

  @override
  void notifyLayer(MapPosition mapPosition, MapViewport viewport) {
    _mapPosition = mapPosition;
    _viewport = viewport;
    _setupVectorsForViewport();
  }

  @override
  void doTabCheck(GeoPoint clickedPosition, Offset screenPos) {
    for (GeomBase vector in _vectors) {
      if (_checkVector(vector, clickedPosition, screenPos)) {
        _fireVectorSelected(vector, clickedPosition);
      }
    }
  }

  bool _checkVector(GeomBase vector, GeoPoint clickedPosition, Offset screenPos) {
    if (vector.withinViewport(_viewport)) {
      if (vector.withinPolygon(clickedPosition, screenPos)) {
        return true;
      } else return false;
    } else return false;
  }

  @override
  void dragStart(GeoPoint clickedPosition, Offset screenPos) {
    for (GeomBase vector in _vectors) {
      if (_checkVector(vector, clickedPosition, screenPos)) {
        if (vector is Polyline) {
          // Found a polyline, Now check for markers on this line
          _draggingVector = vector;
          for (MarkerGeopoint point in (vector as Polyline).points) {
            if (point.marker.dragable) {
              if (point.marker.markerSelectedByScreenPos(screenPos)) {
                point.marker.selected = true;
                _dragginPoint = point;
                _dragginOffset = Offset(screenPos.dx - point.marker.drawingPoint.x,
                    screenPos.dy - point.marker.drawingPoint.y);
                if (pointDragStart != null) pointDragStart(
                    point, clickedPosition);
                fireUpdatedLayer();
                break;
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
      log("draggin polyline marker");
      Offset s = Offset(screenPos.dx - _dragginOffset.dx,
          screenPos.dy - _dragginOffset.dy);
      GeoPoint tp =
      _viewport.getGeopointForScreenPosition(math.Point(s.dx, s.dy));
      _dragginPoint.marker.location = tp;
      _dragginPoint.copyFrom(tp);
      _draggingVector.calculatePixelPosition(_viewport, _mapPosition);
      fireUpdatedLayer();
      if (pointDrag != null) pointDrag(_dragginPoint, tp);
    }
  }

  @override
  void dragEnd(GeoPoint clickedPosition, Offset screenPos) {
    if (_dragginPoint != null) {
      if (pointDragEnd != null) pointDragEnd(_dragginPoint, clickedPosition);
      _dragginPoint.marker.selected = false;
      _dragginOffset = null;
      _dragginPoint = null;
      fireUpdatedLayer();
    }
  }


  void _vectorUpdated(GeomBase vector) {
    _setupVectorsForViewport();
    fireUpdatedLayer();
  }

  void _setupVectorsForViewport() {
    for (GeomBase vector in _vectors) {
      vector.calculatePixelPosition(_viewport, _mapPosition);
    }
  }

  Function(GeomBase vector, GeoPoint clickedPosition) vectorSelected;
  Function(MarkerGeopoint marker_point, GeoPoint startPosition) pointDragStart;
  Function(MarkerGeopoint marker_point, GeoPoint dragToPosition) pointDrag;
  Function(MarkerGeopoint marker_point, GeoPoint endPosition) pointDragEnd;

  void _fireVectorSelected(GeomBase vector, GeoPoint clickedPosition) {
    if (vectorSelected != null) {
      vectorSelected(vector, clickedPosition);
    }
  }

  MapPosition _mapPosition;
  MapViewport _viewport;
}
