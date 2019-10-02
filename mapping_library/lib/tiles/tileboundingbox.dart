class TilesBoundingBox {
  TilesBoundingBox(int minTileX, int minTileY, int maxTileX, int maxTileY) {
    _mintilex = minTileX;
    _mintiley = minTileY;
    _maxtilex = maxTileX;
    _maxtiley = maxTileY;
  }

  int _mintilex;
  get MinTileX { return _mintilex; }
  int _mintiley;
  get MinTileY { return _mintiley; }
  int _maxtilex;
  get MaxTileX { return _maxtilex; }
  int _maxtiley;
  get MaxTileY { return _maxtiley; }
}