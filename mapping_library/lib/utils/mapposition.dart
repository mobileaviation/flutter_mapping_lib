import 'package:flutter/widgets.dart';

import 'boundingbox.dart';
import 'fastmath.dart' as FastMath;
import 'dart:math' as math;
import 'geopoint.dart';
import 'mercatorprojection.dart' as MercatorProjection;
import '../core/values.dart';

class MapPosition {
  double x;
  double y;
  double scale;
  double bearing;
  double tilt;
  double roll;

  int zoomLevel;

  MapPosition() {
    this.scale = 1;
    this.x = 0.5;
    this.y = 0.5;
    this.zoomLevel = 0;
    this.bearing = 0;
    this.tilt = 0;
    this.roll = 0;
  }

  MapPosition.Create({Key key, GeoPoint geoPoint, int zoomLevel}) {
    setPositionDeg(geoPoint.getLatitude(), geoPoint.getLongitude());
    setZoomLevel(zoomLevel);
  }

  MapPosition.fromDegScale(double latitude, double longitude, double scale) {
    setPositionDeg(latitude, longitude);
    setScale(scale);
  }

  MapPosition.fromGeopointScale(GeoPoint geoPoint, double scale) {
    setPositionDeg(geoPoint.getLatitude(), geoPoint.getLongitude());
    setScale(scale);
  }

  MapPosition.fromGeopointZoom(GeoPoint geoPoint, int zoomLevel) {
    setPositionDeg(geoPoint.getLatitude(), geoPoint.getLongitude());
    setZoomLevel(zoomLevel);
  }

  MapPosition.fromDegZoom(double latitude, double longitude, int zoomLevel)
  {
    setPositionDeg(latitude, longitude);
    setZoomLevel(zoomLevel);
  }

  double getX() {
    return x;
  }

  MapPosition setX(double x) {
    this.x = x;
    return this;
  }

  double getY() {
    return y;
  }

  MapPosition setY(double y) {
    this.y = y;
    return this;
  }

  double getBearing() {
    return bearing;
  }

  MapPosition setBearing(double bearing) {
    this.bearing = FastMath.clampDegree(bearing);
    return this;
  }

  double getRoll() {
    return roll;
  }

  MapPosition setRoll(double roll) {
    this.roll = FastMath.clampDegree(roll);
    return this;
  }

  double getTilt() {
    return tilt;
  }

  MapPosition setTilt(double tilt) {
    this.tilt = tilt;
    return this;
  }

  double getScale() {
    return scale;
  }

  MapPosition setScale(double scale) {
    this.zoomLevel = FastMath.log2(scale.floor());
    this.scale = scale;
    return this;
  }

  double getZoom() {
    return math.log(scale) / math.log(2);
  }

  double getZoomFraction() {
    return getZoom() - zoomLevel.toDouble();
  }

  setZoom(double zoom) {
    setScale(math.pow(2, zoom));
  }

  int getZoomLevel() {
    return zoomLevel;
  }

  MapPosition setZoomLevel(int zoomLevel) {
    this.zoomLevel = zoomLevel;
    this.scale = (1 << zoomLevel).toDouble();
    return this;
  }

  setPosition(GeoPoint geoPoint) {
    setPositionDeg(geoPoint.getLatitude(), geoPoint.getLongitude());
  }

  setPositionDeg(double latitude, double longitude) {
    latitude = MercatorProjection.limitLatitude(latitude);
    longitude = MercatorProjection.limitLongitude(longitude);
    this.x = MercatorProjection.longitudeToX(longitude);
    this.y = MercatorProjection.latitudeToY(latitude);
  }

  void copy(MapPosition other) {
    this.x = other.x;
    this.y = other.y;

    this.bearing = other.bearing;
    this.scale = other.scale;
    this.tilt = other.tilt;
    this.zoomLevel = other.zoomLevel;
    this.roll = other.roll;
  }

  void set(double x, double y, double scale, double bearing, double tilt) {
    this.x = x;
    this.y = y;
    this.scale = scale;

    this.bearing = FastMath.clampDegree(bearing);
    this.tilt = tilt;
    this.zoomLevel = FastMath.log2(scale.floor());
  }

  setR(double x, double y, double scale, double bearing, double tilt, double roll) {
    set(x, y, scale, bearing, tilt);
    this.roll = FastMath.clampDegree(roll);
  }

  double getZoomScale() {
    return scale / (1 << zoomLevel);
  }

  GeoPoint getGeoPoint() {
    return new GeoPoint(MercatorProjection.toLatitude(y),
        MercatorProjection.toLongitude(x));
  }

  double getLatitude() {
    return MercatorProjection.toLatitude(y);
  }

  double getLongitude() {
    return MercatorProjection.toLongitude(x);
  }

  setByBoundingBox(BoundingBox bbox, int viewWidth, int viewHeight) {
    double minx = MercatorProjection.longitudeToX(bbox.getMinLongitude());
    double miny = MercatorProjection.latitudeToY(bbox.getMaxLatitude());

    double dx = (MercatorProjection.longitudeToX(bbox.getMaxLongitude()) - minx).abs();
    double dy = (MercatorProjection.latitudeToY(bbox.getMinLatitude()) - miny).abs();
    double zx = viewWidth / (dx * Tile.SIZE);
    double zy = viewHeight / (dy * Tile.SIZE);

    scale = math.min(zx, zy);
    zoomLevel = FastMath.log2(scale.floor());
    x = minx + dx / 2;
    y = miny + dy / 2;
    bearing = 0;
    tilt = 0;
    roll = 0;
  }
}