import 'dart:ui';
import 'package:flutter/services.dart';
import 'Renderers/defaultmarkerrenderer.dart';
import 'Renderers/markerrenderer.dart';
import '../../utils/geopoint.dart';
import 'markerbase.dart';

class DefaultMarker extends MarkerBase {
  DefaultMarker(MarkerRenderer drawerBase, Size size, GeoPoint location) : super(drawerBase, size, location);

  @override
  Future<Image> doDraw() async {
    if (MarkerImage != null) return await MarkerImage;

    if (MarkerDrawer != null) {
      if (MarkerDrawer is DefaultMarkerRenderer) {
        ByteData data = await rootBundle.load('packages/mapping_library/assets/markers/marker_icons.png');
        var codec = await instantiateImageCodec(data.buffer.asUint8List());
        var f = await codec.getNextFrame();
        (MarkerDrawer as DefaultMarkerRenderer).image = f.image;

        Picture _simpleMarkerPicture = MarkerDrawer.Draw(MarkerSize);
        MarkerImage = await _simpleMarkerPicture.toImage(MarkerSize.width.floor(), MarkerSize.height.floor());
        return await MarkerImage;
      }
      else
      {
        throw new Exception("You need to assign an DefaultMarkerRenderer!");
        return null;
      }
    }

    if (MarkerDrawer == null)
    {
      throw new Exception("The Drawer for this Marker is not set, please use SetDrawer!");
      return null;
    }
  }

}