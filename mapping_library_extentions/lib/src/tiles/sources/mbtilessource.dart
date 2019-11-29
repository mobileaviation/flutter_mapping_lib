import 'dart:typed_data';
import 'package:mapping_library/mapping_library.dart';
import 'package:geometric_utils/geometric_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math' as math;

class MBTilesSource extends TileSource {
  MBTilesSource();

  int _minzoom;

  get minZoom {
    return _minzoom;
  }

  int _maxzoom;

  get maxZoom {
    return _maxzoom;
  }

  BoundingBox _boundingBox;

  Future<bool> _openMbTilesFile(String mbTilesFile) async {
    if (mbTilesDatabase == null) {
      mbTilesDatabase = await openDatabase(mbTilesFile, readOnly: true);
      if (mbTilesDatabase != null)
        return mbTilesDatabase.isOpen;
      else
        return false;
    } else
      return mbTilesDatabase.isOpen;
  }

  Future<bool> openMbTilesFile(String mbTilesFile) async {
    if (await _openMbTilesFile(mbTilesFile)) {
      _calculateZoomContrains();
      _calculateBounds();
      return true;
    } else
      return false;
  }

  void closeMbTilesFile() {
    mbTilesDatabase.close();
  }

  Database mbTilesDatabase;

  @override
  Future<TileImage> getTileImage(Tile tile) async {
    if (_boundingBox != null) {
      if (tile.getBoundingBox().intersects(_boundingBox)) {
        MBTilesSourceTile _tile = MBTilesSourceTile(tile);
        List<Map> result = await mbTilesDatabase.query("tiles",
            columns: ['tile_data'],
            where: 'tile_row = ? AND tile_column = ? AND zoom_level = ?',
            whereArgs: [
              _tile.tileRow.floor(),
              _tile.tileColumn.floor(),
              _tile.zoomLevel.floor()
            ]);
        if (result.isNotEmpty) {
          Uint8List _tileBlob = result.first["tile_data"];
          return await getImageFromBytes(_tileBlob);
        } else
          return await null;
      } else
        return await null;
    } else
      return await null;
  }

  void _calculateZoomContrains() async {
    var minzoomResult = await mbTilesDatabase.query("metadata",
        columns: ['value'], where: 'name = ?', whereArgs: ['minzoom']);
    _minzoom = int.parse(minzoomResult.first['value'].toString());
    var maxzoomResult = await mbTilesDatabase.query("metadata",
        columns: ['value'], where: 'name = ?', whereArgs: ['maxzoom']);
    _maxzoom = int.parse(maxzoomResult.first['value'].toString());
  }

  void _calculateBounds() async {
    var boundsResult = await mbTilesDatabase.query("metadata",
        columns: ['value'], where: "name = ?", whereArgs: ['bounds']);

    List<String> bb = boundsResult.first["value"].toString().split(",");

    double w = double.parse(bb[0]);
    double s = double.parse(bb[1]);
    double e = double.parse(bb[2]);
    double n = double.parse(bb[3]);

    _boundingBox = BoundingBox.fromDeg(s, w, n, e);
  }
}

class MBTilesSourceTile {
  MBTilesSourceTile(Tile tile) {
    tileRow =
        ((math.pow(2, tile.zoomLevel.toDouble()) - tile.tileY.toDouble()) - 1);
    tileColumn = tile.tileX.toDouble();
    zoomLevel = tile.zoomLevel.toDouble();
  }

  double tileRow;
  double tileColumn;
  double zoomLevel;
}
