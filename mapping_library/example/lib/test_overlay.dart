import 'package:mapping_library/mapping_library.dart';
import 'dart:io';

void setupTestOverlay(MapView mapView){
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