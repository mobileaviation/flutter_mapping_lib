import 'dart:ui';
import 'markerrenderer.dart';

/// SimpleMarkerRenderer is a test render class
///
/// This class gives an example of how to build a marker renderer
class SimpleMarkerRenderer extends MarkerRenderer {
  @override
  Picture draw(Size size) {
    PictureRecorder drawerRec = PictureRecorder();

    Canvas drawerCanvas = Canvas(drawerRec);
    Paint p = new Paint();
    p.color = const Color.fromARGB(128, 255, 0, 255);
    p.isAntiAlias = true;
    drawerCanvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, p);

    p.color = const Color.fromARGB(128, 100, 0, 100);
    drawerCanvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 3, p);

    return drawerRec.endRecording();
  }
}
