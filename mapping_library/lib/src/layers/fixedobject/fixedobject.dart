import 'dart:ui';

import 'package:mapping_library/src/core/mapviewport.dart';
import 'package:mapping_library/src/utils/mapposition.dart';

class FixedObject {
  FixedObjectPosition position;

  Offset leftTopObjectPos;
  Offset margin;
  Size size;

  /// calculate
  ///
  /// Override this method for further calculations of your own implementation
  /// of the FixedObject class. See the "ScaleBar" class for an example
  void calculate(MapPosition mapPosition, MapViewport viewport) {
    Size drawSize = viewport.getScreenSize();
    switch(position) {
      case FixedObjectPosition.lefttop : {
        leftTopObjectPos = Offset(margin.dx, margin.dy);
        break;
      }
      case FixedObjectPosition.centertop : {
        leftTopObjectPos = Offset(
            (drawSize.width/2) - (size.width/2),
            margin.dy);
        break;
      }
      case FixedObjectPosition.righttop : {
        leftTopObjectPos = Offset(
          drawSize.width - size.width - margin.dx,
          margin.dy);
        break;
      }
      case FixedObjectPosition.rightcenter : {
        leftTopObjectPos = Offset(
            drawSize.width - size.width - margin.dx,
            (drawSize.height/2) - (size.height/2));
        break;
      }
      case FixedObjectPosition.rightbottom : {
        leftTopObjectPos = Offset(
            drawSize.width - size.width - margin.dx,
            drawSize.height - size.height - margin.dy);
        break;
      }
      case FixedObjectPosition.centerbottom : {
        leftTopObjectPos = Offset(
            (drawSize.width/2) - (size.width/2),
            drawSize.height - size.height - margin.dy);
        break;
      }
      case FixedObjectPosition.leftbottom : {
        leftTopObjectPos = Offset(margin.dx,
            drawSize.height - size.height - margin.dy);
        break;
      }
      case FixedObjectPosition.leftcenter : {
        leftTopObjectPos = Offset(margin.dx,
            (drawSize.height/2) - (size.height/2));
        break;
      }
      case FixedObjectPosition.center : {
        leftTopObjectPos = Offset(
            (drawSize.width/2) - (size.width/2),
            (drawSize.height/2) - (size.height/2));
        break;
      }
    }
  }

  /// paint
  ///
  /// Override this method to do the actual painting on the canvas using the
  /// calculated values in calculate
  void paint(Canvas canvas) { }

  void setUpdateListener(Function listener) {
    _objectUpdated = listener;
  }

  Function(FixedObject object) _objectUpdated;

  void fireUpdatedObject() {
    if (_objectUpdated != null) {
      _objectUpdated(this);
    }
  }
}

enum FixedObjectPosition {
  lefttop,
  centertop,
  righttop,
  rightcenter,
  rightbottom,
  centerbottom,
  leftbottom,
  leftcenter,
  center
}