import 'dart:developer';

import 'geopoint.dart';
import 'dart:math' as math;
import 'fastmath.dart' as FastMath;
import 'values.dart';

///
/// An implementation of the spherical Mercator projection.
/// * <p/>
/// * There are generally two methods for each operation: one taking a byte zoom level and
/// * a parallel one taking a double scale. The scale is Math.pow(2, zoomLevel)
/// * for a given zoom level, but the operations take intermediate values as well.
/// * The zoom level operation is a little faster as it can make use of shift operations,
/// * the scale operation offers greater flexibility in computing the values for
/// * intermediate zoom levels.
/// */

///**
/// * Get GeoPoint from Pixels.
/// */
GeoPoint fromPixelsWithScale(double pixelX, double pixelY, double scale) {
  return new GeoPoint(pixelYToLatitudeWithScale(pixelY, scale),
      pixelXToLongitudeWithScale(pixelX, scale));
}

///**
/// * Get GeoPoint from Pixels.
/// */
GeoPoint fromPixels(double pixelX, double pixelY, int mapSize) {
  return new GeoPoint(
      pixelYToLatitude(pixelY, mapSize), pixelXToLongitude(pixelX, mapSize));
}

///**
/// * @param scale the scale factor for which the size of the world map should be returned.
/// * @return the horizontal and vertical size of the map in pixel at the given scale.
/// * @throws IllegalArgumentException if the given scale factor is < 1
/// */
int getMapSizeWithScale(double scale) {
  return (Tile.SIZE.toDouble() * (math.pow(2, scaleToZoomLevel(scale))))
      .floor();
}

///**
/// * @param zoomLevel the zoom level for which the size of the world map should be returned.
/// * @return the horizontal and vertical size of the map in pixel at the given zoom level.
/// * @throws IllegalArgumentException if the given zoom level is negative.
/// */
int getMapSize(int zoomLevel) {
  return Tile.SIZE << zoomLevel;
}

math.Point getPixelWithScale(GeoPoint geoPoint, double scale) {
  double pixelX = longitudeToPixelXWithScale(geoPoint.getLongitude(), scale);
  double pixelY = latitudeToPixelYWithScale(geoPoint.getLatitude(), scale);
  return new math.Point(pixelX, pixelY);
}

math.Point getPixel(GeoPoint geoPoint, int mapSize) {
  double pixelX = longitudeToPixelXMapSize(geoPoint.getLongitude(), mapSize);
  double pixelY = latitudeToPixelYMapSize(geoPoint.getLatitude(), mapSize);
  return new math.Point(pixelX, pixelY);
}

///**
/// * Calculates the absolute pixel position for a map size and tile size
/// *
/// * @param geoPoint the geographic position.
/// * @param mapSize  precomputed size of map.
/// * @return the absolute pixel coordinates (for world)
/// */
math.Point getPixelAbsolute(GeoPoint geoPoint, int mapSize) {
  return getPixelRelative(geoPoint, mapSize, 0, 0);
}

///**
/// * Calculates the absolute pixel position for a map size and tile size relative to origin
/// *
/// * @param geoPoint the geographic position.
/// * @param mapSize  precomputed size of map.
/// * @return the relative pixel position to the origin values (e.g. for a tile)
/// */
math.Point getPixelRelative(
    GeoPoint geoPoint, int mapSize, double x, double y) {
  double pixelX =
      longitudeToPixelXMapSize(geoPoint.getLongitude(), mapSize) - x;
  double pixelY = latitudeToPixelYMapSize(geoPoint.getLatitude(), mapSize) - y;
  return new math.Point(pixelX, pixelY);
}

///**
/// * Calculates the absolute pixel position for a map size and tile size relative to origin
/// *
/// * @param geoPoint the geographic position.
/// * @param mapSize  precomputed size of map.
/// * @return the relative pixel position to the origin values (e.g. for a tile)
/// */
math.Point getPixelRelativeByPoint(
    GeoPoint geoPoint, int mapSize, math.Point origin) {
  return getPixelRelative(geoPoint, mapSize, origin.x, origin.y);
}

///**
/// * Calculates the distance on the ground that is represented by a single
/// * pixel on the map.
/// *
/// * @param latitude the latitude coordinate at which the resolution should be
/// *                 calculated.
/// * @param scale    the map scale at which the resolution should be calculated.
/// * @return the ground resolution at the given latitude and scale.
/// */
double groundResolutionWithScale(double latitude, double scale) {
  return math.cos(latitude * (math.pi / 180)) *
      EARTH_CIRCUMFERENCE /
      (Tile.SIZE * scale);
}

///**
/// * Calculates the distance on the ground that is represented by a single pixel on the map.
/// *
/// * @param latitude the latitude coordinate at which the resolution should be calculated.
/// * @param mapSize  precomputed size of map.
/// * @return the ground resolution at the given latitude and map size.
/// */
double groundResolution(double latitude, int mapSize) {
  return math.cos(latitude * (math.pi / 180)) * EARTH_CIRCUMFERENCE / mapSize;
}

///**
/// * Converts a latitude coordinate (in degrees) to a pixel Y coordinate at a certain scale.
/// *
/// * @param latitude the latitude coordinate that should be converted.
/// * @param scale    the scale factor at which the coordinate should be converted.
/// * @return the pixel Y coordinate of the latitude value.
/// */
double latitudeToPixelYWithScale(double latitude, double scale) {
  double sinLatitude = math.sin(latitude * (math.pi / 180));
  double mapSize = getMapSizeWithScale(scale).toDouble();
  // FIXME improve this formula so that it works correctly without the clipping
  double pixelY =
      (0.5 - math.log((1 + sinLatitude) / (1 - sinLatitude)) / (4 * math.pi)) *
          mapSize;
  return math.min(math.max(0, pixelY), mapSize);
}

///**
/// * Converts a latitude coordinate (in degrees) to a pixel Y coordinate at a certain zoom level.
/// *
/// * @param latitude  the latitude coordinate that should be converted.
/// * @param zoomLevel the zoom level at which the coordinate should be converted.
/// * @return the pixel Y coordinate of the latitude value.
/// */
double latitudeToPixelYZoomLevel(double latitude, int zoomLevel) {
  double sinLatitude = math.sin(latitude * (math.pi / 180));
  int mapSize = getMapSize(zoomLevel);
  // FIXME improve this formula so that it works correctly without the clipping
  double pixelY =
      (0.5 - math.log((1 + sinLatitude) / (1 - sinLatitude)) / (4 * math.pi)) *
          mapSize;
  return math.min(math.max(0, pixelY), mapSize.toDouble());
}

///**
/// * Converts a latitude coordinate (in degrees) to a pixel Y coordinate at a certain map size.
/// *
/// * @param latitude the latitude coordinate that should be converted.
/// * @param mapSize  precomputed size of map.
/// * @return the pixel Y coordinate of the latitude value.
/// */
double latitudeToPixelYMapSize(double latitude, int mapSize) {
  double sinLatitude = math.sin(latitude * (math.pi / 180));
  // FIXME improve this formula so that it works correctly without the clipping
  double pixelY =
      (0.5 - math.log((1 + sinLatitude) / (1 - sinLatitude)) / (4 * math.pi)) *
          mapSize;
  return math.min(math.max(0, pixelY), mapSize.toDouble());
}

///**
/// * Converts a latitude coordinate (in degrees) to a tile Y number at a certain scale.
/// *
/// * @param latitude the latitude coordinate that should be converted.
/// * @param scale    the scale factor at which the coordinate should be converted.
/// * @return the tile Y number of the latitude value.
/// */
int latitudeToTileYWithScale(double latitude, double scale) {
  return pixelYToTileYWithScale(
      latitudeToPixelYWithScale(latitude, scale), scale);
}

///**
/// * Converts a latitude coordinate (in degrees) to a tile Y number at a certain zoom level.
/// *
/// * @param latitude  the latitude coordinate that should be converted.
/// * @param zoomLevel the zoom level at which the coordinate should be converted.
/// * @return the tile Y number of the latitude value.
/// */
int latitudeToTileY(double latitude, int zoomLevel) {
  return pixelYToTileY(
      latitudeToPixelYZoomLevel(latitude, zoomLevel), zoomLevel);
}

///**
/// * Projects a latitude coordinate (in degrees) to the range [0.0,1.0]
/// *
/// * @param latitude the latitude coordinate that should be converted.
/// * @return the position.
/// */
double latitudeToY(double latitude) {
  double sinLatitude = math.sin(latitude * (math.pi / 180));
  return FastMath.clamp(
      0.5 - math.log((1 + sinLatitude) / (1 - sinLatitude)) / (4 * math.pi),
      0.0,
      1.0);
}

///**
/// * @param latitude the latitude value which should be checked.
/// * @return the given latitude value, limited to the possible latitude range.
/// */
double limitLatitude(double latitude) {
  return math.max(math.min(latitude, LATITUDE_MAX), LATITUDE_MIN);
}

///**
/// * @param longitude the longitude value which should be checked.
/// * @return the given longitude value, limited to the possible longitude
/// * range.
/// */
double limitLongitude(double longitude) {
  return math.max(math.min(longitude, LONGITUDE_MAX), LONGITUDE_MIN);
}

/// Converts a longitude coordinate (in degrees) to a pixel X coordinate at a certain scale factor.
///
/// @param longitude the longitude coordinate that should be converted.
/// @param scale     the scale factor at which the coordinate should be converted.
/// @return the pixel X coordinate of the longitude value.
double longitudeToPixelXWithScale(double longitude, double scale) {
  int mapSize = getMapSizeWithScale(scale);
  return (longitude + 180) / 360 * mapSize;
}

/// Converts a longitude coordinate (in degrees) to a pixel X coordinate at a certain zoom level.
///
/// @param longitude the longitude coordinate that should be converted.
/// @param zoomLevel the zoom level at which the coordinate should be converted.
/// @return the pixel X coordinate of the longitude value.
double longitudeToPixelXZoomLevel(double longitude, int zoomLevel) {
  double mapSize = getMapSize(zoomLevel).toDouble();
  return ((longitude + 180) / 360) * mapSize;
}

/// Converts a longitude coordinate (in degrees) to a pixel X coordinate at a certain map size.
///
/// @param longitude the longitude coordinate that should be converted.
/// @param mapSize   precomputed size of map.
/// @return the pixel X coordinate of the longitude value.
double longitudeToPixelXMapSize(double longitude, int mapSize) {
  return ((longitude + 180) / 360) * mapSize;
}

/// Converts a longitude coordinate (in degrees) to the tile X number at a certain scale factor.
///
/// @param longitude the longitude coordinate that should be converted.
/// @param scale     the scale factor at which the coordinate should be converted.
/// @return the tile X number of the longitude value.
int longitudeToTileXWithScale(double longitude, double scale) {
  return pixelXToTileXWithScale(
      longitudeToPixelXWithScale(longitude, scale), scale);
}

/// Converts a longitude coordinate (in degrees) to the tile X number at a certain zoom level.
///
/// @param longitude the longitude coordinate that should be converted.
/// @param zoomLevel the zoom level at which the coordinate should be converted.
/// @return the tile X number of the longitude value.
int longitudeToTileX(double longitude, int zoomLevel) {
  return pixelXToTileX(
      longitudeToPixelXZoomLevel(longitude, zoomLevel), zoomLevel);
}

/// Projects a longitude coordinate (in degrees) to the range [0.0,1.0]
///
/// @param longitude the longitude coordinate that should be converted.
/// @return the position.
double longitudeToX(double longitude) {
  return (longitude + 180.0) / 360.0;
}

/// Converts meters to pixels at latitude for zoom-level.
///
/// @param meters   the meters to convert
/// @param latitude the latitude for the conversion.
/// @param scale    the scale factor for the conversion.
/// @return pixels that represent the meters at the given zoom-level and latitude.
double metersToPixelsWithScale(double meters, double latitude, double scale) {
  return meters / groundResolutionWithScale(latitude, scale);
}

/// Converts meters to pixels at latitude for zoom-level.
///
/// @param meters   the meters to convert
/// @param latitude the latitude for the conversion.
/// @param mapSize  precomputed size of map.
/// @return pixels that represent the meters at the given zoom-level and latitude.
double metersToPixels(double meters, double latitude, int mapSize) {
  return meters / groundResolution(latitude, mapSize);
}

/// Converts a pixel X coordinate at a certain scale to a longitude coordinate.
///
/// @param pixelX the pixel X coordinate that should be converted.
/// @param scale  the scale factor at which the coordinate should be converted.
/// @return the longitude value of the pixel X coordinate.
/// @throws IllegalArgumentException if the given pixelX coordinate is invalid.
double pixelXToLongitudeWithScale(double pixelX, double scale) {
  int mapSize = getMapSizeWithScale(scale);
  return 360 * ((pixelX / mapSize) - 0.5);
}

/// Converts a pixel X coordinate at a certain map size to a longitude coordinate.
///
/// @param pixelX  the pixel X coordinate that should be converted.
/// @param mapSize precomputed size of map.
/// @return the longitude value of the pixel X coordinate.
/// @throws IllegalArgumentException if the given pixelX coordinate is invalid.
double pixelXToLongitude(double pixelX, int mapSize) {
  return 360 * ((pixelX / mapSize) - 0.5);
}

/// Converts a pixel X coordinate to the tile X number.
///
/// @param pixelX the pixel X coordinate that should be converted.
/// @param scale  the scale factor at which the coordinate should be converted.
/// @return the tile X number.
int pixelXToTileXWithScale(double pixelX, double scale) {
  return math.min(math.max(pixelX / Tile.SIZE, 0), scale - 1).floor();
}

/// Converts a pixel X coordinate to the tile X number.
///
/// @param pixelX    the pixel X coordinate that should be converted.
/// @param zoomLevel the zoom level at which the coordinate should be converted.
/// @return the tile X number.
int pixelXToTileX(double pixelX, int zoomLevel) {
  return math.min(
      math.max(pixelX / Tile.SIZE, 0).floor(), math.pow(2, zoomLevel) - 1);
}

/// Converts a pixel Y coordinate at a certain scale to a latitude coordinate.
///
/// @param pixelY the pixel Y coordinate that should be converted.
/// @param scale  the scale factor at which the coordinate should be converted.
/// @return the latitude value of the pixel Y coordinate.
/// @throws IllegalArgumentException if the given pixelY coordinate is invalid.
double pixelYToLatitudeWithScale(double pixelY, double scale) {
  int mapSize = getMapSizeWithScale(scale);
  double y = 0.5 - (pixelY / mapSize);
  return 90 - 360 * math.atan(math.exp(-y * (2 * math.pi))) / math.pi;
}

/// Converts a pixel Y coordinate at a certain map size to a latitude coordinate.
///
/// @param pixelY  the pixel Y coordinate that should be converted.
/// @param mapSize precomputed size of map.
/// @return the latitude value of the pixel Y coordinate.
/// @throws IllegalArgumentException if the given pixelY coordinate is invalid.
double pixelYToLatitude(double pixelY, int mapSize) {
  double y = 0.5 - (pixelY / mapSize);
  //log("PixelY: ${pixelY.toString()} mapSize: ${mapSize.toString()}");
  return 90 - 360 * math.atan(math.exp(-y * (2 * math.pi))) / math.pi;
  //log("pixelToLatitude: ${conv.toString()}");
  //return conv;
}

/// Converts a pixel Y coordinate to the tile Y number.
///
/// @param pixelY the pixel Y coordinate that should be converted.
/// @param scale  the scale factor at which the coordinate should be converted.
/// @return the tile Y number.
int pixelYToTileYWithScale(double pixelY, double scale) {
  return math.min(math.max(pixelY / Tile.SIZE, 0), scale - 1).floor();
}

/// Converts a pixel Y coordinate to the tile Y number.
///
/// @param pixelY    the pixel Y coordinate that should be converted.
/// @param zoomLevel the zoom level at which the coordinate should be converted.
/// @return the tile Y number.
int pixelYToTileY(double pixelY, int zoomLevel) {
  return math.min(
      math.max(pixelY / Tile.SIZE, 0).floor(), math.pow(2, zoomLevel) - 1);
}

math.Point getPixelsPosition(GeoPoint location, int zoomLevel) {
  double x = longitudeToPixelXZoomLevel(location.getLongitude(), zoomLevel);
  double y = latitudeToPixelYZoomLevel(location.getLatitude(), zoomLevel);
  return new math.Point(x, y);
}

/// Converts a scale factor to a zoomLevel.
/// Note that this will return a double, as the scale factors cover the
/// intermediate zoom levels as well.
///
/// @param scale the scale factor to convert to a zoom level.
/// @return the zoom level.
double scaleToZoomLevel(double scale) {
  return FastMath.log2(scale.round()).toDouble();
}

/// @param tileNumber the tile number that should be converted.
/// @return the pixel coordinate for the given tile number.
int tileToPixel(int tileNumber) {
  return tileNumber * Tile.SIZE;
}

/// Converts a tile X number at a certain scale to a longitude coordinate.
///
/// @param tileX the tile X number that should be converted.
/// @param scale the scale factor at which the number should be converted.
/// @return the longitude value of the tile X number.
double tileXToLongitudeWithScale(int tileX, double scale) {
  return pixelXToLongitudeWithScale((tileX * Tile.SIZE).toDouble(), scale);
}

/// Converts a tile X number at a certain zoom level to a longitude coordinate.
///
/// @param tileX     the tile X number that should be converted.
/// @param zoomLevel the zoom level at which the number should be converted.
/// @return the longitude value of the tile X number.
double tileXToLongitude(int tileX, int zoomLevel) {
  return pixelXToLongitude(
      (tileX * Tile.SIZE).toDouble(), getMapSize(zoomLevel));
}

/// Converts a tile Y number at a certain scale to a latitude coordinate.
///
/// @param tileY the tile Y number that should be converted.
/// @param scale the scale factor at which the number should be converted.
/// @return the latitude value of the tile Y number.
double tileYToLatitudeWithScale(int tileY, double scale) {
  return pixelYToLatitudeWithScale((tileY * Tile.SIZE).toDouble(), scale);
}

/// Converts a tile Y number at a certain zoom level to a latitude coordinate.
///
/// @param tileY     the tile Y number that should be converted.
/// @param zoomLevel the zoom level at which the number should be converted.
/// @return the latitude value of the tile Y number.
double tileYToLatitude(int tileY, int zoomLevel) {
  return pixelYToLatitude(
      (tileY * Tile.SIZE).toDouble(), getMapSize(zoomLevel));
}

/// Converts a tile Y number at a certain zoom level to TMS notation.
///
/// @param tileY     the tile Y number that should be converted.
/// @param zoomLevel the zoom level at which the number should be converted.
/// @return the TMS value of the tile Y number.
int tileYToTMS(int tileY, int zoomLevel) {
  return (zoomLevelToScale(zoomLevel) - tileY - 1).round();
}

/// Converts y map position to latitude in degrees.
///
/// @param y the map position {@link MapPosition#getY() y}.
/// @return the latitude in degrees.
double toLatitude(double y) {
  return 90 - 360 * math.atan(math.exp((y - 0.5) * (2 * math.pi))) / math.pi;
}

/// Converts x map position to longitude in degrees.
///
/// @param x the map position {@link MapPosition#getX() x}.
/// @return the longitude in degrees.
double toLongitude(double x) {
  return 360.0 * (x - 0.5);
}

/// Return a longitude wrapped by LONGUTUDE_MIN and LONGITUDE_MAX
///
/// @param the longitude in degrees
/// @return the wrapped longitude in degrees
double wrapLongitude(double longitude) {
  if (longitude < -180)
    return math.max(math.min(360 + longitude, LONGITUDE_MAX), LONGITUDE_MIN);
  else if (longitude > 180)
    return math.max(math.min(longitude - 360, LONGITUDE_MAX), LONGITUDE_MIN);

  return longitude;
}

/// Convert from zoomlevel (int) to scale via a bitshift function
/// in general this is a power of 2 function
/// note: only for integer values
///
/// @param the zoomlevel (integer)
/// @return the bitshifted power of 2 scale value
double zoomLevelToScale(int zoomLevel) {
  return (1 << zoomLevel).toDouble();
}

/// Convert from zoomlevel (double) to scale via math.pow function
///
/// @param the zoomlevel (double)
/// @return the power of 2 scale value
double zoomLevelToScaleD(double zoomlevel) {
  return math.pow(2, zoomlevel);
}

/// Generate a TileID based on its X., Y en Z values
///
/// @param x coordinate of the tile
/// @param y coordinate of the tile
/// @param z coordinate of the tile
/// @return the ID string created from the tile coordinate values
String getTileId(int x, int y, int z) {
  return x.toString() + ":" + y.toString() + ":" + z.toString();
}
