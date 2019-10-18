import 'package:mapping_library/core/mapview.dart';
import 'package:mapping_library/layers/overlaylayer.dart';
import 'package:mapping_library/layers/Overlay/overlayimage.dart';
import 'dart:io';

void SetupTestOverlay(MapView mapView){
  double north = 52.58651688434567;
  double south = 52.27448205017151;
  double east = 5.717278709730119;
  double west = 5.378079539513956;

  String path = "/sdcard/Download";
  String fileEHLE = path + "/" + "EH-AD-2.EHLE-VAC.png";
  OverlayImage ehleImage = OverlayImage(File(fileEHLE));
  ehleImage.setImageBox(north, south, west, east);

  OverlayLayer overlayLayer = OverlayLayer();
  overlayLayer.AddImage(ehleImage);
  mapView.AddLayer(overlayLayer);
}