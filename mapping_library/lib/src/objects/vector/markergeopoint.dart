import '../../objects/markers/pointmarker.dart';
import 'package:geometric_utils/geometric_utils.dart';

class MarkerGeopoint extends GeoPoint {
  MarkerGeopoint.fromGeopoint(GeoPoint geoPoint) : super.fromGeopoint(geoPoint);

  PointMarker marker;
}