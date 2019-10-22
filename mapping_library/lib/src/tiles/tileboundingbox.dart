class TilesBoundingBox {
  TilesBoundingBox(int minTileX, int minTileY, int maxTileX, int maxTileY) {
    _mintilex = minTileX;
    _mintiley = minTileY;
    _maxtilex = maxTileX;
    _maxtiley = maxTileY;
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
