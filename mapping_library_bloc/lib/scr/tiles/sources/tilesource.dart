import 'dart:typed_data';
import 'dart:ui';
import 'package:mapping_library_bloc/scr/tiles/tile.dart';

abstract class TileSource {
  Future<Tile> retrieveTile(Tile source);

  Future<Image> getImageFromBytes(Uint8List data);
}