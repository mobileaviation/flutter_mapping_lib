import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../../core/values.dart' as values;
import 'layerpainterbase.dart';
import '../tilelayer.dart';
import '../../tiles/tile.dart';
import 'package:geometric_utils/mercator_utils.dart'  as MercatorProjection;

class TileLayerPainter extends LayerPainterBase {

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    TilesLayer tilesLayer = layer as TilesLayer;

    if (doRedraw || (layerPicture==null)) {
      PictureRecorder rec = PictureRecorder();
      Canvas drawerCanvas = Canvas(rec);

      for (int x = tilesLayer.tilesBoundingbox.minTileX;
      x <= tilesLayer.tilesBoundingbox.maxTileX;
      x++) {
        for (int y = tilesLayer.tilesBoundingbox.minTileY;
        y <= tilesLayer.tilesBoundingbox.maxTileY;
        y++) {
          ScreenTile t = tilesLayer.tiles[
          MercatorProjection.getTileId(
              x, y, tilesLayer.mapViewPort.mapPosition.zoomLevel)];
          double tilesize = values.Tile.SIZE.toDouble() *
              (1 + tilesLayer.mapViewPort.mapPosition.getZoomFraction());
          tilesize = tilesize.roundToDouble() + 1;
          if (t.tileImage != null) {
            drawerCanvas.drawImageRect(
                t.tileImage,
                Rect.fromLTWH(0, 0, values.Tile.SIZE.toDouble(),
                    values.Tile.SIZE.toDouble()),
                Rect.fromLTWH(t.drawPosX, t.drawPosY, tilesize, tilesize),
                Paint());
          }
        }
      }
      doRedraw = false;
      layerPicture = rec.endRecording();
    }

    canvas.drawPicture(layerPicture);
    // layerPicture.toImage(size.width.floor(), size.height.floor()).then((value) => {
    //   canvas.drawImage(value, Offset(0,0), Paint())
    // });
  }
}