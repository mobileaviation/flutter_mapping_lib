import 'dart:typed_data';
import 'dart:ui' as ui;
import 'tile.dart';

class TileSource {

  Future<TileImage> getTileImage(Tile tile) async {}

  Future<TileImage> getImageFromBytes(Uint8List data) async {
    var codec = await ui.instantiateImageCodec(data);
    var f = await codec.getNextFrame();
    return TileImage(f.image, data);
  }
}

class TileImage {
  TileImage(this.image, this.data);
  ui.Image image;
  Uint8List data;
}