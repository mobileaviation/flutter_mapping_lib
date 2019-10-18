import 'dart:developer';
import 'dart:typed_data';
import 'package:mapping_library/tiles/tilesource.dart' as ts;
import 'package:mapping_library/tiles/tile.dart' as tile;
import 'package:mapping_library/utils/boundingbox.dart';
import 'dart:ui' as ui;
import 'package:sqflite/sqflite.dart';
import 'dart:math' as math;

class MBTilesSource extends ts.TileSource {
  MBTilesSource() {

  }

  int _minzoom;
  int _maxzoom;
  BoundingBox _boundingBox;

  Future<bool> _openMbTilesFile(String mbTilesFile) async {
    if (mbTilesDatabase == null) {
      mbTilesDatabase = await openDatabase(mbTilesFile, readOnly: true);
      if (mbTilesDatabase != null) return await mbTilesDatabase.isOpen;
      else return await false;
    } else
      return await mbTilesDatabase.isOpen;
  }

  Future<bool> OpenMbTilesFile(String mbTilesFile) async {
    if (await _openMbTilesFile(mbTilesFile)) {
      await _calculateZoomContrains();
      await _calculateBounds();
      return true;
    } else return false;
  }

  void CloseMbTilesFile() {
    mbTilesDatabase.close();
  }

  String _mbTilesFile;
  Database mbTilesDatabase;

  @override
  Future<ts.TileImage> GetTileImage(tile.Tile tile) async {
    if (tile.getBoundingBox().intersects(_boundingBox)) {
      MBTilesSourceTile _tile = MBTilesSourceTile(tile);
      List<Map> result = await mbTilesDatabase.query("tiles",
          columns: ['tile_data'],
          where: 'tile_row = ? AND tile_column = ? AND zoom_level = ?',
          whereArgs: [
            _tile.tile_row.floor(),
            _tile.tile_column.floor(),
            _tile.zoom_level.floor()
          ]);
      if (result.isNotEmpty) {
        Uint8List _tileBlob = result.first["tile_data"];
        return await getImageFromBytes(_tileBlob);
      } else
        return await null;
    } else return await null;
  }

  void _calculateZoomContrains() async {
    var minzoom_result = await mbTilesDatabase.query("metadata",
        columns:['value'],
        where: 'name = ?',
        whereArgs: ['minzoom']);
    _minzoom = int.parse(minzoom_result.first['value'].toString());
    var maxzoom_result = await mbTilesDatabase.query("metadata",
        columns:['value'],
        where: 'name = ?',
        whereArgs: ['maxzoom']);
    _maxzoom = int.parse(maxzoom_result.first['value'].toString());
  }

  void _calculateBounds() async {
    var bounds_result = await mbTilesDatabase.query("metadata",
        columns: ['value'],
        where: "name = ?",
        whereArgs: ['bounds']);

    List<String> bb = bounds_result.first["value"].toString().split(",");

    double w = double.parse(bb[0]);
    double s = double.parse(bb[1]);
    double e = double.parse(bb[2]);
    double n = double.parse(bb[3]);

    _boundingBox = BoundingBox.fromDeg(s, w, n, e);
  }
}

class MBTilesSourceTile {
  MBTilesSourceTile(tile.Tile tile) {
    tile_row = ((math.pow(2, tile.zoomLevel.toDouble()) - tile.tileY.toDouble()) - 1);
    tile_column = tile.tileX.toDouble();
    zoom_level = tile.zoomLevel.toDouble();
  }

  double tile_row;
  double tile_column;
  double zoom_level;

}