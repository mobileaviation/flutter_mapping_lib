import 'dart:ui';
import '../tiles/tilesource.dart';
import '../core/viewport.dart';
import '../tiles/tile.dart';
import '../utils/mapposition.dart';
import 'layer.dart';
import '../utils/mercatorprojection.dart' as MercatorProjection;
import '../tiles/tileboundingbox.dart';
import '../core/values.dart' as values;
import '../utils/geopoint.dart';

class TileLayer extends Layer {
  TileLayer(TileSource source) {
    _tiles = new Map();
    _source = source;
  }

  void paint(Canvas canvas, Size size) {
    if (_mapPosition != null) {
      for (int x = _tilesBoundingBox.MinTileX; x <=
          _tilesBoundingBox.MaxTileX; x++) {
        for (int y = _tilesBoundingBox.MinTileY; y <=
            _tilesBoundingBox.MaxTileY; y++) {
          ScreenTile t = _tiles[MercatorProjection.getTileId(
              x, y, _mapPosition.zoomLevel)];
          Offset p = Offset(t.DrawPosX, t.DrawPosY);
          double tilesize = values.Tile.SIZE.toDouble() * (1 + _mapPosition.getZoomFraction());
          if (t.tileImage != null) {
            canvas.drawImageRect(t.tileImage, Rect.fromLTWH(0, 0, values.Tile.SIZE.toDouble(), values.Tile.SIZE.toDouble()),
                Rect.fromLTWH(t.DrawPosX, t.DrawPosY, tilesize, tilesize),
                new Paint());
          }
        }
      }
    }
  }

  @override
  void notifyLayer(MapPosition mapPosition, Viewport viewport) {
    _mapPosition = mapPosition;
    _setupTilesArray(_mapPosition, viewport);
  }

  @override
  void doTabCheck(GeoPoint clickedPosition, Offset screenPos) {

  }

  void _setupTilesArray(MapPosition mapPosition, Viewport viewport)
  {
    _tilesBoundingBox = new TilesBoundingBox(
        MercatorProjection.pixelXToTileX(viewport.TopLeftAbsPixels.x, mapPosition.zoomLevel),
        MercatorProjection.pixelYToTileY(viewport.TopLeftAbsPixels.y, mapPosition.zoomLevel),
        MercatorProjection.pixelXToTileX(viewport.BottomRightAbsPixels.x, mapPosition.zoomLevel),
        MercatorProjection.pixelYToTileY(viewport.BottomRightAbsPixels.y, mapPosition.zoomLevel));

    for (int x = _tilesBoundingBox.MinTileX; x<=_tilesBoundingBox.MaxTileX; x++) {
      for (int y = _tilesBoundingBox.MinTileY; y<=_tilesBoundingBox.MaxTileY; y++) {
        String tileId = MercatorProjection.getTileId(x, y, mapPosition.zoomLevel);
        ScreenTile t = _tiles[tileId];
        if (t == null) t = ScreenTile(x, y, mapPosition);
        t.CalcScreenPosition(viewport, mapPosition);
        t.RetrieveImage(_source).then((i) {
          fireUpdatedLayer();
        });
        _tiles[t.tileId] = t;
      }
    }
  }

  Map<String,Tile> _tiles;
  TilesBoundingBox _tilesBoundingBox;
  MapPosition _mapPosition;
  TileSource _source;
}