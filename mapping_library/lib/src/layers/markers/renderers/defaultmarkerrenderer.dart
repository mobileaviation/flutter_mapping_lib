import 'dart:ui';
import 'defaultmarkers.dart';

import 'markerrenderer.dart';

class DefaultMarkerRenderer extends MarkerRenderer {
  Image image;
  DefaultMarkerType markerType = DefaultMarkerType.Red;

  final double _width = 6;
  final double _height = 2;

  @override
  Picture draw(Size size) {
    PictureRecorder drawerRec = PictureRecorder();
    Canvas drawerCanvas = Canvas(drawerRec);

    List lt = defaultMarkers[markerType];
    double l = lt[0];
    double r = lt[1];

    double mwidth = image.width.toDouble() / _width;
    double mheight = image.height.toDouble() / _height;

    Rect s = Rect.fromLTWH(mwidth * l, mheight * r, mwidth, mheight);
    drawerCanvas.drawImageRect(image, s,
        new Rect.fromLTWH(0, 0, size.width, size.height), new Paint());

    return drawerRec.endRecording();
  }
}
