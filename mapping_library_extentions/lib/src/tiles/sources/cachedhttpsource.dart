import 'dart:developer';
import 'dart:io';
import 'dart:core';
import 'dart:typed_data';
import 'package:mapping_library/mapping_library.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CachedHttpTileSource extends HttpTileSource {
  CachedHttpTileSource(String urlTemplate, String name) : super(urlTemplate) {
    // Create and open the cache database for this urlTemplate
    _name = '$name.db';
  }

  String _name;
  Database _db;
  int _dbversion = 1;
  bool _databaseOpen = false;

  get databaseOpen {
    return _databaseOpen;
  }

  void openCachedTileSource(Function onSourceOpened) {
    _onDBOpened = onSourceOpened;
    _getDatabasePath(_name).then((path) {
      log("Path to the tilescache database: $path");
      _openDatabase(path);
    });
  }

  Function _onDBOpened;

  Future<Database> _openDatabase(String path) async {
    return await openDatabase(path,
        version: _dbversion,
        onCreate: _onCreate,
        onOpen: _onOpen,
        onUpgrade: _onUpgrade);
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE tiles (TileX INTEGER, TileY INTEGER, TileZ INTEGER, Timestamp REAL, TileBytes BLOB)");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Database version is updated, alter the table
    //await db.execute("ALTER TABLE Test ADD name TEXT");
  }

  _onOpen(Database db) {
    _db = db;
    _databaseOpen = true;
    _onDBOpened();
    log("Tilescache Database opened");
  }

  Future<String> _getDatabasePath(String dbname) async {
    String path = await getDatabasesPath();
    try {
      await Directory(path).create(recursive: true);
      path = join(path, dbname);
    } catch (e) {
      log(e.toString());
    }

    return path;
  }

  Future<TileImage> _getImageFromCache(Tile tile) async {
    List<Map> result = await _db.query("tiles",
        columns: ['TileBytes'],
        where: 'TileX = ? AND TileY = ? AND TileZ = ?',
        whereArgs: [tile.tileX, tile.tileY, tile.zoomLevel]);
    if (result.isNotEmpty) {
      Uint8List _tileBlob = result.first["TileBytes"];
      return TileImage((await getImageFromBytes(_tileBlob)).image, _tileBlob);
    } else
      return null;
  }

  Future<void> _insertImageInCache(Tile tile, TileImage tileImage) async {
    // We are using the "execute" method instead of "insert" because we can not
    // use specific sqlite functions (like julianday) in the "insert" method
    String sql =
        "INSERT INTO tiles (TileX, TileY, TileZ, TileBytes, Timestamp) ";
    sql = sql + "VALUES(?, ?, ?, ?, julianday('now'))";
    return await _db
        .execute(sql, [tile.tileX, tile.tileY, tile.zoomLevel, tileImage.data]);
  }

  @override
  Future<TileImage> getTileImage(Tile tile) async {
    if (_databaseOpen) {
      var dbimage = await _getImageFromCache(tile);
      if (dbimage != null) {
        return TileImage(dbimage.image, dbimage.data);
      } else {
        TileImage image = await super.getTileImage(tile);
        _insertImageInCache(tile, image);
        return image;
      }
    }
    return await null;
  }
}
