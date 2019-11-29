import 'dart:ui';
import 'renderers/pointmarkerrenderer.dart';
import 'renderers/markerrenderer.dart';
import 'package:geometric_utils/geometric_utils.dart';
import 'markerbase.dart';

class PointMarker extends MarkerBase {
  PointMarker(MarkerRenderer drawerBase, Size size, GeoPoint location)
      : super(drawerBase, size, location);

  PointMarkerRendererData pointSetupData;

  @override
  Future<Image> doDraw() async {
    if (markerImage == null) {
      if (markerDrawer != null) {
        markerDrawer.setup(pointSetupData);
        Picture _pointMarkerPicture = markerDrawer.draw(markerSize);
        markerImage = await _pointMarkerPicture.toImage(
            markerSize.width.floor(), markerSize.height.floor());
      }

      if (markerDrawer == null) {
        new Exception(
            "The Drawer for this Marker is not set, please use SetDrawer!");
      }
    }

    return super.doDraw();
  }
}