import 'geopoint.dart';
import 'dart:math' as math;
import '../core/values.dart';

final double CONVERSION_FACTOR = 1000000;

class BoundingBox {
  int maxLatitudeE6;
  int maxLongitudeE6;
  int minLatitudeE6;
  int minLongitudeE6;

  BoundingBox.fromE6(int minLatitudeE6, int minLongitudeE6, int maxLatitudeE6,
      int maxLongitudeE6) {
    this.minLatitudeE6 = minLatitudeE6;
    this.minLongitudeE6 = minLongitudeE6;
    this.maxLatitudeE6 = maxLatitudeE6;
    this.maxLongitudeE6 = maxLongitudeE6;
  }

  BoundingBox.fromDeg(double minLatitude, double minLongitude,
      double maxLatitude, double maxLongitude) {
    this.minLatitudeE6 = (minLatitude * 1E6).round();
    this.minLongitudeE6 = (minLongitude * 1E6).round();
    this.maxLatitudeE6 = (maxLatitude * 1E6).round();
    this.maxLongitudeE6 = (maxLongitude * 1E6).round();
  }

  BoundingBox.fromGeoPoints(List<GeoPoint> geoPoints) {
    int minLat = 200000000;
    int minLon = 200000000;
    int maxLat = 0;
    int maxLon = 0;
    for (GeoPoint geoPoint in geoPoints) {
      minLat = math.min(minLat, geoPoint.latitudeE6);
      minLon = math.min(minLon, geoPoint.longitudeE6);
      maxLat = math.max(maxLat, geoPoint.latitudeE6);
      maxLon = math.max(maxLon, geoPoint.longitudeE6);
    }
    this.minLatitudeE6 = minLat;
    this.minLongitudeE6 = minLon;
    this.maxLatitudeE6 = maxLat;
    this.maxLongitudeE6 = maxLon;
  }

  GeoPoint getNorthWestPoint() {
    return GeoPoint.fromE6(maxLatitudeE6, minLongitudeE6);
  }

  GeoPoint getSouthEastPoint() {
    return GeoPoint.fromE6(minLatitudeE6, maxLongitudeE6);
  }

  bool contains(GeoPoint geoPoint) {
    return geoPoint.latitudeE6 <= maxLatitudeE6 &&
        geoPoint.latitudeE6 >= minLatitudeE6 &&
        geoPoint.longitudeE6 <= maxLongitudeE6 &&
        geoPoint.longitudeE6 >= minLongitudeE6;
  }

  BoundingBox extendBoundingBox(BoundingBox boundingBox) {
    return new BoundingBox.fromE6(
        math.min(this.minLatitudeE6, boundingBox.minLatitudeE6),
        math.min(this.minLongitudeE6, boundingBox.minLongitudeE6),
        math.max(this.maxLatitudeE6, boundingBox.maxLatitudeE6),
        math.max(this.maxLongitudeE6, boundingBox.maxLongitudeE6));
  }

  BoundingBox extendCoordinates(GeoPoint geoPoint) {
    if (contains(geoPoint)) {
      return this;
    }

    double minLat = math.max(
        LATITUDE_MIN, math.min(getMinLatitude(), geoPoint.getLatitude()));
    double minLon = math.max(
        LONGITUDE_MIN, math.min(getMinLongitude(), geoPoint.getLongitude()));
    double maxLat = math.min(
        LATITUDE_MAX, math.max(getMaxLatitude(), geoPoint.getLatitude()));
    double maxLon = math.min(
        LONGITUDE_MAX, math.max(getMaxLongitude(), geoPoint.getLongitude()));

    return BoundingBox.fromDeg(minLat, minLon, maxLat, maxLon);
  }

  BoundingBox extendDegrees(
      double verticalExpansion, double horizontalExpansion) {
    if (verticalExpansion == 0 && horizontalExpansion == 0) {
      return this;
    }

    double minLat =
        math.max(LATITUDE_MIN, getMinLatitude() - verticalExpansion);
    double minLon =
        math.max(LONGITUDE_MIN, getMinLongitude() - horizontalExpansion);
    double maxLat =
        math.min(LATITUDE_MAX, getMaxLatitude() + verticalExpansion);
    double maxLon =
        math.min(LONGITUDE_MAX, getMaxLongitude() + horizontalExpansion);

    return BoundingBox.fromDeg(minLat, minLon, maxLat, maxLon);
  }

  BoundingBox extendMargin(double margin) {
    if (margin == 1) {
      return this;
    }

    double verticalExpansion =
        (getLatitudeSpan() * margin - getLatitudeSpan()) * 0.5;
    double horizontalExpansion =
        (getLongitudeSpan() * margin - getLongitudeSpan()) * 0.5;

    double minLat =
        math.max(LATITUDE_MIN, getMinLatitude() - verticalExpansion);
    double minLon =
        math.max(LONGITUDE_MIN, getMinLongitude() - horizontalExpansion);
    double maxLat =
        math.min(LATITUDE_MAX, getMaxLatitude() + verticalExpansion);
    double maxLon =
        math.min(LONGITUDE_MAX, getMaxLongitude() + horizontalExpansion);

    return BoundingBox.fromDeg(minLat, minLon, maxLat, maxLon);
  }

  BoundingBox extendMeters(int meters) {
    if (meters == 0) {
      return this;
    }

    double verticalExpansion = latitudeDistance(meters);
    double horizontalExpansion = longitudeDistance(
        meters, math.max(getMinLatitude().abs(), getMaxLatitude().abs()));

    double minLat =
        math.max(LATITUDE_MIN, getMinLatitude() - verticalExpansion);
    double minLon =
        math.max(LONGITUDE_MIN, getMinLongitude() - horizontalExpansion);
    double maxLat =
        math.min(LATITUDE_MAX, getMaxLatitude() + verticalExpansion);
    double maxLon =
        math.min(LONGITUDE_MAX, getMaxLongitude() + horizontalExpansion);

    return BoundingBox.fromDeg(minLat, minLon, maxLat, maxLon);
  }

  GeoPoint getCenterPoint() {
    int latitudeOffset = ((maxLatitudeE6 - minLatitudeE6) / 2).round();
    int longitudeOffset = ((maxLongitudeE6 - minLongitudeE6) / 2).round();
    return GeoPoint.fromE6(
        minLatitudeE6 + latitudeOffset, minLongitudeE6 + longitudeOffset);
  }

  double getLatitudeSpan() {
    return getMaxLatitude() - getMinLatitude();
  }

  double getLongitudeSpan() {
    return getMaxLongitude() - getMinLongitude();
  }

  double getMaxLatitude() {
    return maxLatitudeE6 / CONVERSION_FACTOR;
  }

  double getMaxLongitude() {
    return maxLongitudeE6 / CONVERSION_FACTOR;
  }

  double getMinLatitude() {
    return minLatitudeE6 / CONVERSION_FACTOR;
  }

  double getMinLongitude() {
    return minLongitudeE6 / CONVERSION_FACTOR;
  }

  bool intersects(BoundingBox boundingBox) {
    if (this == boundingBox) {
      return true;
    }

    return getMaxLatitude() >= boundingBox.getMinLatitude() &&
        getMaxLongitude() >= boundingBox.getMinLongitude() &&
        getMinLatitude() <= boundingBox.getMaxLatitude() &&
        getMinLongitude() <= boundingBox.getMaxLongitude();
  }

  String toString() {
    return "LeftTop.Lat: $getMaxLatitude()" +
        " LeftTop.Lon: $getMinLongitude()" +
        " BottomRight.Lat: $getMinLatitude()" +
        " BottomRight.lon: $getMaxLongitude()";
  }
}
