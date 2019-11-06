import '../../objects/markers/pointmarker.dart';
import '../../../mapping_library.dart';

class MarkerGeopoint extends GeoPoint {
  MarkerGeopoint.fromGeopoint(GeoPoint geoPoint) : super.fromGeopoint(geoPoint);

  PointMarker marker;
}