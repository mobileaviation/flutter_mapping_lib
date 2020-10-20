import 'dart:developer';

class TilesBoundingBox {
  TilesBoundingBox(int minTileX, int minTileY, int maxTileX, int maxTileY) {
    _mintilex = minTileX;
    _mintiley = minTileY;
    _maxtilex = maxTileX;
    _maxtiley = maxTileY;
  }

  List<TileXY> getBoxedTiles() {
    List<TileXY> l = [];
    for (int x = minTileX; x <= maxTileX; x++) {
      for (int y = minTileY; y <= maxTileY; y++) {
        l.add(TileXY(x, y));
      }
    }
    return l;
  }

  int _mintilex;

  get minTileX {
    return _mintilex;
  }

  int _mintiley;

  get minTileY {
    return _mintiley;
  }

  int _maxtilex;

  get maxTileX {
    return _maxtilex;
  }

  int _maxtiley;

  get maxTileY {
    return _maxtiley;
  }
}

class TileXY {
  TileXY(this.x, this.y);
  int x;
  int y;
}
