import 'dart:math';
import 'dart:ui';
import 'package:geometric_utils/mercator_utils.dart'  as MercatorProjection;

class Tile extends Point{
  int z;
  Tile(num x, num y, num z) : super(x, y)
  {
    this.z = z;
    tileId = MercatorProjection.getTileId(x, y, z);
  }

  Tile.fromTile(Tile source) : super(source.x, source.y) {
    this.z = source.z;
    this.tileId = source.tileId;
  }

  Image image;
  Rect drawRect;
  String tileId;
}