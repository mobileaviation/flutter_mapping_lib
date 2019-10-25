import 'dart:ui';
import 'renderers/markerrenderer.dart';
import '../../utils/geopoint.dart';
import 'markerbase.dart';

class SimpleMarker extends MarkerBase {
  SimpleMarker(MarkerRenderer drawerBase, Size size, GeoPoint location)
      : super(drawerBase, size, location);

  @override
  Future<Image> doDraw() async {
    if (markerImage != null) return await markerImage;

    if (markerDrawer != null) {
      Picture _simpleMarkerPicture = markerDrawer.draw(markerSize);
      markerImage = await _simpleMarkerPicture.toImage(
          markerSize.width.floor(), markerSize.height.floor());
      return await markerImage;
    }

    if (markerDrawer == null) {
      new Exception(
          "The Drawer for this Marker is not set, please use SetDrawer!");
      return null;
    }
  }
}
