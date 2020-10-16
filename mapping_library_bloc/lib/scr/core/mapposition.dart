import 'package:flutter/widgets.dart';
import 'package:geometric_utils/fastmath_utils.dart' as FastMath;
import 'dart:math' as math;
import 'package:geometric_utils/geometric_utils.dart';
import 'package:geometric_utils/mercator_utils.dart' as MercatorProjection;
import '../core/values.dart';

/// MapPosition Class
/// This class holds variables and functions to manage the position,
/// zoomlevel, bearing, tilt and roll of a map
class MapPosition {
  double _x;
  double _y;
  double _scale;
  double _bearing;
  double _tilt;
  double _roll;

  /// Zoomlevel of the map, normally this will be the Z value of
  /// a tile. Values between 2-20
  int zoomLevel;

  /// MapPosition Defailt contructor
  /// Sets the map to the center of the world at a zoomlever of 5
  MapPosition() {
    this._scale = 1;
    this._x = 0.5;
    this._y = 0.5;
    this.zoomLevel = 0;
    this._bearing = 0;
    this._tilt = 0;
    this._roll = 0;
  }

  /// MapPosition default constructor with Key fields
  /// @param geopoint is the location the map will display when created
  /// @param zoomLevel is the zoom level the map will be displated at.
  MapPosition.create({Key key, GeoPoint geoPoint, int zoomLevel}) {
    setPositionDeg(geoPoint.getLatitude(), geoPoint.getLongitude());
    setZoomLevel(zoomLevel);
  }

  /// MapPosition.fromDegScale constructor
  /// Contructs a map using degrees latitude and longitude values and the scale value
  /// @param latitude value in degrees (double)
  /// @param longitude value in degrees (double)
  /// @para, scale value (double)
  MapPosition.fromDegScale(double latitude, double longitude, double scale) {
    setPositionDeg(latitude, longitude);
    setScale(scale);
  }

  /// MapPosition.fromGeopointScale constructor
  /// Contructs a map using degrees latitude and longitude values and the scale value
  /// @param GeoPoint of the location
  /// @para, scale value (double)
  MapPosition.fromGeopointScale(GeoPoint geoPoint, double scale) {
    setPositionDeg(geoPoint.getLatitude(), geoPoint.getLongitude());
    setScale(scale);
  }

  /// MapPosition.fromGeopointZoom constructor
  /// Contructs a map using degrees latitude and longitude values and the scale value
  /// @param GeoPoint of the location
  /// @param zoom value (int)
  MapPosition.fromGeopointZoom(GeoPoint geoPoint, int zoomLevel) {
    setPositionDeg(geoPoint.getLatitude(), geoPoint.getLongitude());
    setZoomLevel(zoomLevel);
  }

  /// MapPosition.fromDegZoom constructor
  /// Contructs a map using degrees latitude and longitude values and the scale value
  /// @param latitude value in degrees (double)
  /// @param longitude value in degrees (double)
  /// @para, zoom value (int)
  MapPosition.fromDegZoom(double latitude, double longitude, int zoomLevel) {
    setPositionDeg(latitude, longitude);
    setZoomLevel(zoomLevel);
  }

  /// Retrieve the
  double getX() {
    return _x;
  }

  MapPosition setX(double x) {
    this._x = x;
    return this;
  }

  double getY() {
    return _y;
  }

  MapPosition setY(double y) {
    this._y = y;
    return this;
  }

  double getBearing() {
    return _bearing;
  }

  MapPosition setBearing(double bearing) {
    this._bearing = FastMath.clampDegree(bearing);
    return this;
  }

  double getRoll() {
    return _roll;
  }

  MapPosition setRoll(double roll) {
    this._roll = FastMath.clampDegree(roll);
    return this;
  }

  double getTilt() {
    return _tilt;
  }

  MapPosition setTilt(double tilt) {
    this._tilt = tilt;
    return this;
  }

  double getScale() {
    return _scale;
  }

  MapPosition setScale(double scale) {
    this.zoomLevel = FastMath.log2(scale.floor());
    this._scale = scale;
    return this;
  }

  double getZoom() {
    return math.log(_scale) / math.log(2);
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
    this._scale = (1 << zoomLevel).toDouble();
    return this;
  }

  setPosition(GeoPoint geoPoint) {
    setPositionDeg(geoPoint.getLatitude(), geoPoint.getLongitude());
  }

  setPositionDeg(double latitude, double longitude) {
    latitude = MercatorProjection.limitLatitude(latitude);
    longitude = MercatorProjection.limitLongitude(longitude);
    this._x = MercatorProjection.longitudeToX(longitude);
    this._y = MercatorProjection.latitudeToY(latitude);
  }

  void copy(MapPosition other) {
    this._x = other._x;
    this._y = other._y;

    this._bearing = other._bearing;
    this._scale = other._scale;
    this._tilt = other._tilt;
    this.zoomLevel = other.zoomLevel;
    this._roll = other._roll;
  }

  void set(double x, double y, double scale, double bearing, double tilt) {
    this._x = x;
    this._y = y;
    this._scale = scale;

    this._bearing = FastMath.clampDegree(bearing);
    this._tilt = tilt;
    this.zoomLevel = FastMath.log2(scale.floor());
  }

  setR(double x, double y, double scale, double bearing, double tilt,
      double roll) {
    set(x, y, scale, bearing, tilt);
    this._roll = FastMath.clampDegree(roll);
  }

  double getZoomScale() {
    return _scale / (1 << zoomLevel);
  }

  GeoPoint getGeoPoint() {
    return new GeoPoint(
        MercatorProjection.toLatitude(_y), MercatorProjection.toLongitude(_x));
  }

  double getLatitude() {
    return MercatorProjection.toLatitude(_y);
  }

  double getLongitude() {
    return MercatorProjection.toLongitude(_x);
  }

  setByBoundingBox(BoundingBox bbox, int viewWidth, int viewHeight) {
    double minx = MercatorProjection.longitudeToX(bbox.getMinLongitude());
    double miny = MercatorProjection.latitudeToY(bbox.getMaxLatitude());

    double dx =
        (MercatorProjection.longitudeToX(bbox.getMaxLongitude()) - minx).abs();
    double dy =
        (MercatorProjection.latitudeToY(bbox.getMinLatitude()) - miny).abs();
    double zx = viewWidth / (dx * TileValues.SIZE);
    double zy = viewHeight / (dy * TileValues.SIZE);

    _scale = math.min(zx, zy);
    zoomLevel = FastMath.log2(_scale.floor());
    _x = minx + dx / 2;
    _y = miny + dy / 2;
    _bearing = 0;
    _tilt = 0;
    _roll = 0;
  }
}
