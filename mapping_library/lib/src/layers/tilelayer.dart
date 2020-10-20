import 'package:flutter/widgets.dart';
import '../core/mapviewport.dart';
import '../tiles/tile.dart';
import '../tiles/tileboundingbox.dart';
import '../tiles/tilesource.dart';
import 'package:geometric_utils/mercator_utils.dart'  as MercatorProjection;
import 'layer.dart';
import 'painters/tilelayerpainter.dart';

class TilesLayer extends Layer {
  TilesLayer({Key key,
    TileSource tileSource,
    String name})// : super(key)
  {
    source = tileSource;
    layerPainter = TileLayerPainter();
    layerPainter.layer = this;
    _tiles = Map();
    this.name = (name == null) ? "TileLayer" : name;
  }


  void _setupTilesArray(MapViewport viewport) {
    _tilesBoundingBox = TilesBoundingBox(
        MercatorProjection.pixelXToTileX(
            viewport.topLeftAbsPixels.x, viewport.mapPosition.zoomLevel),
        MercatorProjection.pixelYToTileY(
            viewport.topLeftAbsPixels.y, viewport.mapPosition.zoomLevel),
        MercatorProjection.pixelXToTileX(
            viewport.bottomRightAbsPixels.x, viewport.mapPosition.zoomLevel),
        MercatorProjection.pixelYToTileY(
            viewport.bottomRightAbsPixels.y, viewport.mapPosition.zoomLevel));

    for (TileXY e in _tilesBoundingBox.getBoxedTiles()) {
        String tileId =
        MercatorProjection.getTileId(e.x, e.y, viewport.mapPosition.zoomLevel);
        ScreenTile t = _tiles[tileId];
        if (t == null) t = ScreenTile(e.x, e.y, viewport.mapPosition);
        t.calcScreenPosition(viewport, viewport.mapPosition);
        t.retrieveImage(source).then((i) {
          layerPainter.doRedraw = true;
          redrawPainter();

        });
        _tiles[t.tileId] = t;
      }
  }

  @override
  notifyLayer(MapViewport viewport, bool mapChanged) {
    super.notifyLayer(viewport, mapChanged);
    layerPainter.doRedraw = true;
    _setupTilesArray(viewport);
  }

  Map<String, Tile> _tiles;
  Map<String, Tile> get tiles => _tiles;

  TilesBoundingBox _tilesBoundingBox;
  TilesBoundingBox get tilesBoundingbox => _tilesBoundingBox;

  TileSource source;
}