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
    if (markerImage != null) return await markerImage;

    if (markerDrawer != null) {
      if (markerDrawer is DefaultMarkerRenderer) {
        ByteData data = await rootBundle.load('packages/mapping_library/assets/markers/marker_icons.png');
        var codec = await instantiateImageCodec(data.buffer.asUint8List());
        var f = await codec.getNextFrame();
        (markerDrawer as DefaultMarkerRenderer).image = f.image;

        Picture _simpleMarkerPicture = markerDrawer.draw(markerSize);
        markerImage = await _simpleMarkerPicture.toImage(markerSize.width.floor(), markerSize.height.floor());
        return await markerImage;
      }
      else
      {
        throw new Exception("You need to assign an DefaultMarkerRenderer!");
      }
    }

    if (markerDrawer == null)
    {
      throw new Exception("The Drawer for this Marker is not set, please use SetDrawer!");
    }
    return null;
  }

}