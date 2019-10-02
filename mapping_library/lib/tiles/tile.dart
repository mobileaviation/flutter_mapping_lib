import 'dart:ui';
import '../core/viewport.dart';
import '../tiles/tilesource.dart';
import '../utils/geopoint.dart';
import '../utils/mapposition.dart';
import '../utils/boundingbox.dart';
import '../core/values.dart';
import '../utils/mercatorprojection.dart' as MercatorProjection;
import 'dart:math' as math;

class ScreenTile extends Tile {
  ScreenTile(int tileX, int tileY, MapPosition mapPosition) : super(tileX, tileY, mapPosition ) {
    getOrigin();
    tileId = MercatorProjection.getTileId(tileX, tileY, zoomLevel.floor());
  }

  void CalcScreenPosition(Viewport viewport, MapPosition centerPosition)
  {
    Size screensize = viewport.GetScreenSize();
    math.Point centerPixels =  MercatorProjection.getPixel(centerPosition.getGeoPoint(), this.mapSize);
    ScreenPosX = origin.x - (centerPixels.x - (screensize.width/2));
    ScreenPosY = origin.y - (centerPixels.y - (screensize.height/2));
    math.Point drawPoint = viewport.projectScreenPositionByReferenceAndScale(new math.Point(ScreenPosX, ScreenPosY),
        new math.Point(screensize.width/2, screensize.height/2),
        centerPosition.getZoomFraction() + 1);
    DrawPosX = drawPoint.x;
    DrawPosY = drawPoint.y;
  }

  Future<Image> RetrieveImage(TileSource source) async
  {
    if (!_retrieving) {
      _retrieving = (_tileImage == null);
      if (_tileImage == null)
        _tileImage = await source.GetTileImage(this);
    }
    _retrieving = (_tileImage == null);
    return await _tileImage;
  }

  Image _tileImage;
  get tileImage { return _tileImage; }

  math.Point _absPixels;
  double ScreenPosX;
  double ScreenPosY;
  double DrawPosX;
  double DrawPosY;
  String tileId;

  bool _retrieving = false;
}

class Tile {
  int mapSize;
  int tileX;
  int tileY;
  int zoomLevel;

  BoundingBox boundingBox;
  math.Point origin;

  Tile(int tileX, int tileY, MapPosition mapPosition)
  {
    this.tileX = tileX;
    this.tileY = tileY;
    this.zoomLevel = mapPosition.getZoom().floor();
    this.mapSize = MercatorProjection.getMapSize(this.zoomLevel);
  }

  Tile.fromGeopoint(GeoPoint geoPoint, MapPosition mapPosition) {
    this.zoomLevel = mapPosition.getZoom().floor();
    this.tileX = MercatorProjection.longitudeToTileX(geoPoint.getLongitude(), this.zoomLevel.floor());
    this.tileY = MercatorProjection.latitudeToTileY(geoPoint.getLatitude(), this.zoomLevel.floor());
    this.mapSize = MercatorProjection.getMapSize(this.zoomLevel);
  }

  BoundingBox getBoundingBox() {
    if (this.boundingBox == null) {
      double minLatitude = math.max(LATITUDE_MIN, MercatorProjection.tileYToLatitude(tileY + 1, zoomLevel.floor()));
      double minLongitude = math.max(-180, MercatorProjection.tileXToLongitude(this.tileX, zoomLevel.floor()));
      double maxLatitude = math.min(LATITUDE_MAX, MercatorProjection.tileYToLatitude(this.tileY, zoomLevel.floor()));
      double maxLongitude = math.min(180, MercatorProjection.tileXToLongitude(tileX + 1, zoomLevel.floor()));
      if (maxLongitude == -180) {
        // fix for dateline crossing, where the right tile starts at -180 and causes an invalid bbox
        maxLongitude = 180;
      }
      this.boundingBox = new BoundingBox.fromDeg(minLatitude, minLongitude, maxLatitude, maxLongitude);
    }
    return this.boundingBox;
  }

  BoundingBox getBoundingBoxFromTiles(Tile upperLeft, Tile lowerRight) {
    BoundingBox ul = upperLeft.getBoundingBox();
    BoundingBox lr = lowerRight.getBoundingBox();
    return ul.extendBoundingBox(lr);
  }

  int getMaxTileNumber(int zoomLevel) {
    if (zoomLevel == 0) {
      return 0;
    }
    return (2 << zoomLevel - 1) - 1;
  }

  math.Point getOrigin() {
    if (this.origin == null) {
      int x = MercatorProjection.tileToPixel(this.tileX);
      int y = MercatorProjection.tileToPixel(this.tileY);
      this.origin = new math.Point(x.toDouble(), y.toDouble());
    }
    return this.origin;
  }
}