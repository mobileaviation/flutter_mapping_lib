import 'dart:ui';
import 'renderers/buttonsmarkerrenderer.dart';
import 'renderers/markerrenderer.dart';
import 'package:geometric_utils/geometric_utils.dart';
import 'markerbase.dart';

class ButtonsMarker extends MarkerBase {
  ButtonsMarker(MarkerRenderer drawerBase, Size size, GeoPoint location)
      : super(drawerBase, size, location);

  ButtonsMarkerData buttonsSetupData;

  @override
  Future<Image> doDraw() async {
    if (markerImage == null) {
      if (markerDrawer != null) {
        markerDrawer.setup(buttonsSetupData);
        Picture _buttonMarkerPicture = markerDrawer.draw(markerSize);
        markerImage = await _buttonMarkerPicture.toImage(
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