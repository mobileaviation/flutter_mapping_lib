import 'dart:io';
import 'dart:ui';
import 'package:mapping_library/mapping_library.dart';

/// Add a default marker to the map. The location is in the middle of the
/// Netherlands near the town of Harderwijk
void addDefaultMarker(MarkersLayer markersLayer) {
  GeoPoint t = new GeoPoint(52.383063, 5.556776);
  // The default marker implementation will show a "Default" droplet marker icon
  // in different custom choseable colors
  //
  // A Marker consists of two classes an extent from Marker (which is
  // DefaultMarker here and a extend of MarkerRenderer which in this case is
  // DefaultMarkerRenderer.
  // In the renderer there is one method called 'draw' that needs to be
  // overridden for custom draw implementation
  DefaultMarkerRenderer defaultMarkerRenderer = new DefaultMarkerRenderer();
  defaultMarkerRenderer.markerType = DefaultMarkerType.Red;
  DefaultMarker marker2 =
      new DefaultMarker(defaultMarkerRenderer, Size(35, 50), t);
  // Always give a marker a name!! otherwise an exception is thrown
  marker2.name = "Marker2";
  // draw order of the markers is the order they are added to the layer. First
  // added is bottom. Last added is top.
  markersLayer.addMarker(marker2);
}

/// Add the custom rendered marker (two purple circles) to the map
/// The location is in the middle of the Netherlands, on top of
/// Lelystad airport.
void addSimpleMarker(MarkersLayer markersLayer) {
  GeoPoint s = new GeoPoint(52.45657243868931, 5.52041338863477);
  SimpleMarkerRenderer drawer = new SimpleMarkerRenderer();
  SimpleMarker marker = new SimpleMarker(drawer, Size(100, 100), s);
  marker.dragable = true;
  // Checkout the implementation of SimpleMarker and SimpleMarkerRenderer to
  // create your own custom marker implementation..
  marker.name = "Marker1";
  marker.rotation = 45;
  markersLayer.addMarker(marker);
}

/// Add a image Marker to the map.
/// The image is loaded (png) from the local storage of the device
void addImageMarker(MarkersLayer markersLayer) {
  // This location is in the Netherlands above the Markermeer
  GeoPoint s = new GeoPoint(52.571921, 5.123513);
  // Create the ImageMarkerRenderer
  ImageMarkerRenderer drawer = new ImageMarkerRenderer();
  // Supply the image file from the local storage of the device
  String path = "/sdcard/Download";
  String file = path + "/" + "airplane_top.png";
  // Create the marker
  // We've set the Size of the imageMarker to 'null', this will set the
  // size of the marker to the size of the loaded image file
  ImageMarker marker = ImageMarker(drawer, null, s, File(file));
  marker.name = "ImageMarker1";
  marker.dragable = true;
  marker.rotation = 90;
  markersLayer.addMarker(marker);
}
