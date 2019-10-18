import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';

import 'tile.dart';

class TileSource {
  Future<TileImage> GetTileImage(Tile tile) async {}

  Future<TileImage> getImageFromBytes(Uint8List data) async {
    var codec = await ui.instantiateImageCodec(data);
    var f = await codec.getNextFrame();
    return await TileImage(f.image, data);
  }
}

class TileImage {
  TileImage(this.image, this.data);
  ui.Image image;
  Uint8List data;
}