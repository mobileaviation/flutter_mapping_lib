import 'dart:ui';
import 'package:mapping_library/mapping_library.dart';

void addDefaultMarker(MarkersLayer markersLayer) {
  GeoPoint t = new GeoPoint(52.383063, 5.556776);
  DefaultMarkerRenderer defaultMarkerRenderer = new DefaultMarkerRenderer();
  defaultMarkerRenderer.markerType = DefaultMarkerType.Red;
  DefaultMarker marker2 =
      new DefaultMarker(defaultMarkerRenderer, new Size(35, 50), t);
  marker2.name = "Marker2";
  markersLayer.addMarker(marker2);
}

void addSimpleMarker(MarkersLayer markersLayer) {
  GeoPoint s = new GeoPoint(52.45657243868931, 5.52041338863477);
  SimpleMarkerRenderer drawer = new SimpleMarkerRenderer();
  SimpleMarker marker = new SimpleMarker(drawer, Size(100, 100), s);
  marker.name = "Marker1";
  markersLayer.addMarker(marker);
}
