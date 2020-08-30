import 'dart:developer';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/layers/multitileslayer.dart';
import 'package:mapping_library/src/tiles/tilesource.dart';
import '../../core/values.dart' as values;
import 'layerpainterbase.dart';
import '../tilelayer.dart';
import '../../tiles/tile.dart';
import 'package:geometric_utils/mercator_utils.dart'  as MercatorProjection;

class TileLayerPainter extends LayerPainterBase {

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    var tilesLayer = null;
    if (layer is TilesLayer) tilesLayer = layer as TilesLayer;
    if (layer is MultiTilesLayer) tilesLayer = layer as MultiTilesLayer;

    if (doRedraw || (layerPicture==null)) {
      //try {
        for (int x = tilesLayer.tilesBoundingbox.minTileX;
        x <= tilesLayer.tilesBoundingbox.maxTileX;
        x++) {
          for (int y = tilesLayer.tilesBoundingbox.minTileY;
          y <= tilesLayer.tilesBoundingbox.maxTileY;
          y++) {

            if (tilesLayer is TilesLayer) drawTilesLayer(tilesLayer, canvas, x, y);
            if (tilesLayer is MultiTilesLayer) drawMultiTilesLayer(tilesLayer, canvas, x, y);

          }
        }
      //}
      //catch (e) {
      //  log(e.toString());
      //}
      //finally {
        doRedraw = false;
      //}
    }
  }

  void drawMultiTilesLayer(MultiTilesLayer tilesLayer, Canvas canvas, int x, int y) {
    int sourceIndex = 0;
    for (TileSource source in tilesLayer.sources) {
      sourceIndex++;
      String tileId = MercatorProjection.getTileId(
          x, y, tilesLayer.mapViewPort.mapPosition.zoomLevel) + "-" + sourceIndex.toString();
      ScreenTile t = tilesLayer.tiles[tileId];
      double tilesize = getTilesize(tilesLayer);

      drawTile(t, canvas, tilesize);
    }
  }

  void drawTilesLayer(TilesLayer tilesLayer, Canvas canvas, int x, int y) {
    ScreenTile t = tilesLayer.tiles[
    MercatorProjection.getTileId(
        x, y, tilesLayer.mapViewPort.mapPosition.zoomLevel)];
    double tilesize = getTilesize(tilesLayer);

    drawTile(t, canvas, tilesize);
  }

  double getTilesize(var tilesLayer) {
    double tilesize = values.Tile.SIZE.toDouble() *
        (1 + tilesLayer.mapViewPort.mapPosition.getZoomFraction());
    tilesize = tilesize.roundToDouble() + 1;
    return tilesize;
  }

  void drawTile(ScreenTile t, Canvas canvas, double tilesize) {
    if (t != null) {
      if (t.tileImage != null) {
        canvas.drawImageRect(
            t.tileImage,
            Rect.fromLTWH(0, 0, t.tileImage.width.toDouble(),
                t.tileImage.height.toDouble()),
            Rect.fromLTWH(t.drawPosX, t.drawPosY, tilesize, tilesize),
            Paint());
      }
    }
  }
}