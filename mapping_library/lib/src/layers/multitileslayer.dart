import 'package:flutter/widgets.dart';
import '../core/mapviewport.dart';
import '../tiles/tile.dart';
import '../tiles/tileboundingbox.dart';
import '../tiles/tilesource.dart';
import 'package:geometric_utils/mercator_utils.dart'  as MercatorProjection;
import 'layer.dart';
import 'painters/tilelayerpainter.dart';

class MultiTilesLayer extends Layer {
  MultiTilesLayer({Key key,
    List<TileSource> tileSources,
    String name})// : super(key)
  {
    sources = tileSources;
    layerPainter = TileLayerPainter();
    layerPainter.layer = this;
    _tiles = Map();
    this.name = (name == null) ? "MultiTileLayer" : name;
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

    for (int x = _tilesBoundingBox.minTileX;
    x <= _tilesBoundingBox.maxTileX;
    x++) {
      for (int y = _tilesBoundingBox.minTileY;
      y <= _tilesBoundingBox.maxTileY;
      y++) {
        int sourceIndex = 0;
        for (TileSource source in sources) {
          sourceIndex++;
          String tileId = MercatorProjection.getTileId(x, y, viewport.mapPosition.zoomLevel) + "-" + sourceIndex.toString();
          ScreenTile t = _tiles[tileId];
          if (t == null) t = ScreenTile(x, y, viewport.mapPosition);
          t.calcScreenPosition(viewport, viewport.mapPosition);
          t.retrieveImage(source).then((i) {
            layerPainter.doRedraw = true;
            redrawPainter();
          });
          _tiles[t.tileId  + "-" + sourceIndex.toString()] = t;
        }
      }
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

  List<TileSource> sources;
}