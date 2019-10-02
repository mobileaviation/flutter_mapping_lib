import 'dart:ui';
import 'Renderers/markerrenderer.dart';
import '../../utils/geopoint.dart';
import 'markerbase.dart';

class SimpleMarker extends MarkerBase {
  SimpleMarker(MarkerRenderer drawerBase, Size size, GeoPoint location) : super(drawerBase, size, location);

  @override
  Future<Image> doDraw() async {
    if (MarkerImage != null) return await MarkerImage;

    if (MarkerDrawer != null) {
      Picture _simpleMarkerPicture = MarkerDrawer.Draw(MarkerSize);
      MarkerImage = await _simpleMarkerPicture.toImage(MarkerSize.width.floor(), MarkerSize.height.floor());
      return await MarkerImage;
    }

    if (MarkerDrawer == null)
    {
      new Exception("The Drawer for this Marker is not set, please use SetDrawer!");
      return null;
    }
  }
}