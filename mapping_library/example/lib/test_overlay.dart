import 'package:mapping_library/mapping_library.dart';
import 'dart:io';

/// Add an overlay bound by its corners to the map
void setupTestOverlay(MapView mapView){
  // to add a overlay to the map you need the coordinates of the outmost corners
  // of the overlay image
  // In development is the use of rotation..
  double north = 52.58651688434567;
  double south = 52.27448205017151;
  double east = 5.717278709730119;
  double west = 5.378079539513956;

  String path = "/sdcard/Download";
  String fileEHLE = path + "/" + "EH-AD-2.EHLE-VAC.png";
  OverlayImage ehleImage = OverlayImage(File(fileEHLE));
  ehleImage.setImageBox(north, south, west, east);

  OverlayLayer overlayLayer = OverlayLayer();
  overlayLayer.addImage(ehleImage);
  mapView.addLayer(overlayLayer);
}