import '../../objects/markers/markerbase.dart';
import 'package:geometric_utils/geometric_utils.dart';

class MarkerGeopoint extends GeoPoint {
  MarkerGeopoint.fromGeopoint(GeoPoint geoPoint) : super.fromGeopoint(geoPoint);

  Object data;
  MarkerBase marker;
}