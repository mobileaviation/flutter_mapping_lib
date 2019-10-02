/**
 * The circumference of the earth at the equator in meters.
 */
final double EARTH_CIRCUMFERENCE = 40075016.686;
/**
 * Maximum possible latitude coordinate of the map.
 */
final double LATITUDE_MAX = 85.05112877980659;
/**
 * Minimum possible latitude coordinate of the map.
 */
final double LATITUDE_MIN = -LATITUDE_MAX;
/**
 * Maximum possible longitude coordinate of the map.
 */
final double LONGITUDE_MAX = 180;
/**
 * Minimum possible longitude coordinate of the map.
 */
final double LONGITUDE_MIN = -LONGITUDE_MAX;

final double EQUATORIAL_RADIUS = 6378137.0;

class Tile {
  static final int DEFAULT_TILE_SIZE = 256;

  static final int SIZE = 256;

  static final int TILE_SIZE_MULTIPLE = 64;
}