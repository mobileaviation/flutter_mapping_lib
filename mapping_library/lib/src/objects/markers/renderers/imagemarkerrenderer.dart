import 'dart:ui';
import 'markerrenderer.dart';

class ImageMarkerRenderer extends MarkerRenderer {
  Image image;

  @override
  Picture draw(Size size) {
    if (image == null)
      throw new Exception("For an ImageMarkerRenderer the image may not be NULL, error!!");

    PictureRecorder drawerRec = PictureRecorder();
    Canvas drawerCanvas = Canvas(drawerRec);

    Rect s = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    drawerCanvas.drawImageRect(image, s,
        new Rect.fromLTWH(0, 0, size.width, size.height), new Paint());

    return drawerRec.endRecording();
  }
}