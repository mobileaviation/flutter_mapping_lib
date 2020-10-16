import 'dart:developer';
import 'dart:ui';
import 'package:mapping_library_bloc/scr/layers/layer.dart';
import 'package:mapping_library_bloc/scr/layers/layer_bloc.dart';
import 'package:mapping_library_bloc/scr/tiles/sources/httptilesource.dart';
import 'package:mapping_library_bloc/scr/tiles/sources/tilesource.dart';
import 'package:mapping_library_bloc/scr/tiles/tile.dart';

class TileLayer extends Layer {
  TileLayer(this.source) {
    tiles = Map();
    _prepareTestTiles();
  }

  final TileSource source;

  void startRetrieveTiles(LayerBloc bloc, TileLayerEventsData data) {
    for (Tile t in tiles.values) {
      if (t.image == null) {
        (source as HttpTileSource).retrieveTile(t).then(
          (value) {
            TileLayerEventsData responseData = TileLayerEventsData(TileLayerEvents.tileRecieved, null);
            bloc.add(responseData);
          },
        );
      }
    }
  }

  void paint(Canvas canvas) {
    for (Tile tile in tiles.values) {
      log("Paint Tile: ${tile.tileId}");
      if (tile.image != null)
        canvas.drawImageRect(
            tile.image, Rect.fromLTWH(0, 0, 255, 255), tile.drawRect, Paint());
    }
  }

  Map<String, Tile> tiles;

  void _prepareTestTiles() {
    num zoom = 10;
    num startx = 525;
    num endx = 528;
    num starty = 334;
    num endy = 337;

    num drawx = 0;
    num drawy = 0;
    for (int x = startx; x < endx; x++) {
      drawy = 0;
      for (int y = starty; y < endy; y++) {
        Tile t = Tile(x, y, zoom);
        t.drawRect = Rect.fromLTWH(drawx.toDouble(), drawy.toDouble(), 255.0, 255.0);
        drawy = drawy + 255;
        tiles[t.tileId] = t;
      }
      drawx = drawx + 255;
    }
    log ("Test Tiles prepared..");
  }
}
