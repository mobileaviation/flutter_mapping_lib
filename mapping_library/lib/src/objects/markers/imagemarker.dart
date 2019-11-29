import 'dart:io';
import 'dart:ui';
import 'renderers/imagemarkerrenderer.dart';
import 'renderers/markerrenderer.dart';
import 'package:geometric_utils/geometric_utils.dart';
import 'markerbase.dart';

class ImageMarker extends MarkerBase {
  ImageMarker(MarkerRenderer drawerBase, Size size, GeoPoint location, File imageFile)
      : super(drawerBase, size, location) {
    _imageFile = imageFile;
  }

  File _imageFile;

  @override
  Future<Image> doDraw() async {
    if (markerImage == null) {
      if (_imageFile == null)
        throw new Exception("No image file assigned!");

      if (markerDrawer != null) {
        if (markerDrawer is ImageMarkerRenderer) {
          var data = await _imageFile.readAsBytes();
          var codec = await instantiateImageCodec(data);
          var f = await codec.getNextFrame();
          (markerDrawer as ImageMarkerRenderer).image = f.image;

          if (markerSize == null) markerSize = Size(f.image.width.toDouble(),
              f.image.height.toDouble());

          Picture _imageMarkerPicture = markerDrawer.draw(markerSize);
          markerImage = await _imageMarkerPicture.toImage(
              markerSize.width.floor(), markerSize.height.floor());
        } else {
          throw new Exception("You need to assign an ImagedMarkerRenderer!");
        }
      } else {
        throw new Exception(
            "The Drawer for this Marker is not set, please use SetDrawer!");
      }
    }

    return super.doDraw();
  }
}