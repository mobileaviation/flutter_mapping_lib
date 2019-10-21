import 'dart:ui';
import 'markerrenderer.dart';

class SimpleMarkerRenderer extends MarkerRenderer {
  @override
  Picture draw(Size size) {
    PictureRecorder drawerRec = new PictureRecorder();

    Canvas drawerCanvas = new Canvas(drawerRec);
    Paint p = new Paint();
    p.color = const Color.fromARGB(128, 255, 0, 255);
    p.isAntiAlias = true;
    drawerCanvas.drawCircle(new Offset(size.width/2, size.height/2), size.width/2, p);

    p.color = const Color.fromARGB(128, 100, 0, 100);
    drawerCanvas.drawCircle(new Offset(size.width/2, size.height/2), size.width/3, p);

    return drawerRec.endRecording();
  }
}