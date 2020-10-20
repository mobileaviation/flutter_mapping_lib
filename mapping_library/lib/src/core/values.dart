///**
/// * The circumference of the earth at the equator in meters.
/// */
final double earthCircumference = 40075016.686;
///**
/// * Maximum possible latitude coordinate of the map.
/// */
final double latitudeMax = 85.05112877980659;
///**
/// * Minimum possible latitude coordinate of the map.
/// */
final double latitudeMin = -latitudeMax;
///**
/// * Maximum possible longitude coordinate of the map.
/// */
final double longitudeMax = 180;
///**
/// * Minimum possible longitude coordinate of the map.
/// */
final double longitudeMin = -longitudeMax;

final double equatorialRadius = 6378137.0;

class Tile {
  static final int defaultTileSize = 256;

  static final int size = 256;

  static final int tileSizeMultiple = 64;
}