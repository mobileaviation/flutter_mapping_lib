import 'dart:ui';
import '../tiles/tilesource.dart';
import '../core/mapviewport.dart';
import '../tiles/tile.dart';
import '../utils/mapposition.dart';
import 'layer.dart';
import '../utils/mercatorprojection.dart' as MercatorProjection;
import '../tiles/tileboundingbox.dart';
import '../core/values.dart' as values;
import '../utils/geopoint.dart';

class TilesLayer extends Layer {



  TilesLayer(TileSource source) {
    _tiles = new Map();
    _source = source;
  }

  void paint(Canvas canvas, Size size) {
    if (_mapPosition != null) {
      for (int x = _tilesBoundingBox.minTileX;
          x <= _tilesBoundingBox.maxTileX;
          x++) {
        for (int y = _tilesBoundingBox.minTileY;
            y <= _tilesBoundingBox.maxTileY;
            y++) {
          ScreenTile t = _tiles[
              MercatorProjection.getTileId(x, y, _mapPosition.zoomLevel)];
          double tilesize = values.Tile.SIZE.toDouble() *
              (1 + _mapPosition.getZoomFraction());
          if (t.tileImage != null) {
            canvas.drawImageRect(
                t.tileImage,
                Rect.fromLTWH(0, 0, values.Tile.SIZE.toDouble(),
                    values.Tile.SIZE.toDouble()),
                Rect.fromLTWH(t.drawPosX, t.drawPosY, tilesize, tilesize),
                Paint());
          }
        }
      }
    }
  }

  @override
  void notifyLayer(MapPosition mapPosition, MapViewport viewport) {
    _mapPosition = mapPosition;
    _setupTilesArray(_mapPosition, viewport);
  }

  @override
  void doTabCheck(GeoPoint clickedPosition, Offset screenPos) {}

  void _setupTilesArray(MapPosition mapPosition, MapViewport viewport) {
    _tilesBoundingBox = TilesBoundingBox(
        MercatorProjection.pixelXToTileX(
            viewport.topLeftAbsPixels.x, mapPosition.zoomLevel),
        MercatorProjection.pixelYToTileY(
            viewport.topLeftAbsPixels.y, mapPosition.zoomLevel),
        MercatorProjection.pixelXToTileX(
            viewport.bottomRightAbsPixels.x, mapPosition.zoomLevel),
        MercatorProjection.pixelYToTileY(
            viewport.bottomRightAbsPixels.y, mapPosition.zoomLevel));

    for (int x = _tilesBoundingBox.minTileX;
        x <= _tilesBoundingBox.maxTileX;
        x++) {
      for (int y = _tilesBoundingBox.minTileY;
          y <= _tilesBoundingBox.maxTileY;
          y++) {
        String tileId =
            MercatorProjection.getTileId(x, y, mapPosition.zoomLevel);
        ScreenTile t = _tiles[tileId];
        if (t == null) t = ScreenTile(x, y, mapPosition);
        t.calcScreenPosition(viewport, mapPosition);
        t.retrieveImage(_source).then((i) {
          fireUpdatedLayer();
        });
        _tiles[t.tileId] = t;
      }
    }
  }

  Map<String, Tile> _tiles;
  TilesBoundingBox _tilesBoundingBox;
  MapPosition _mapPosition;
  TileSource _source;
}
