import 'dart:ui';
import 'package:mapping_library/layers/markerslayer.dart';
import 'package:mapping_library/layers/Markers/Renderers/simplemarkerrenderer.dart';
import 'package:mapping_library/layers/Markers/Renderers/defaultmarkerrenderer.dart';
import 'package:mapping_library/layers/Markers/Renderers/defaultmarkers.dart';
import 'package:mapping_library/layers/Markers/simplemarker.dart';
import 'package:mapping_library/layers/Markers/defaultimagemarker.dart';
import 'package:mapping_library/utils/geopoint.dart';

void AddDefaultMarker(MarkersLayer markersLayer) {
  GeoPoint t = new GeoPoint(52.383063, 5.556776);
  DefaultMarkerRenderer defaultMarkerRenderer = new DefaultMarkerRenderer();
  defaultMarkerRenderer.markerType = DefaultMarkerType.Red;
  DefaultMarker marker2 = new DefaultMarker(defaultMarkerRenderer, new Size(35,50), t);
  marker2.Name = "Marker2";
  markersLayer.AddMarker(marker2);
}

void AddSimpleMarker(MarkersLayer markersLayer) {
  GeoPoint s = new GeoPoint(52.45657243868931, 5.52041338863477);
  SimpleMarkerRenderer drawer = new SimpleMarkerRenderer();
  SimpleMarker marker = new SimpleMarker(drawer, Size(100,100), s);
  marker.Name = "Marker1";
  markersLayer.AddMarker(marker);
}