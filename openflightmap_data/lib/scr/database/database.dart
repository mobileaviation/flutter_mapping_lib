import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as db;

class AixmDatabase {
  AixmDatabase(String dbName) {
    _name = dbName;
  }
  String _name;
  db.Database _db;
  int _dbversion = 1;

  void openDatabase() {
    _getDatabasePath(_name).then((path) {
      _openDatabase(path);
    });
  }


  Future<db.Database> _openDatabase(String path) async {
    _db = await db.openDatabase(path,
        version: _dbversion,
        onCreate: _onCreate,
        onOpen: _onOpen,
        onUpgrade: _onUpgrade);
    return await _db;
  }

  _onCreate(db.Database db, int version) async {
    await db.execute("pragma foreign_keys = ON");
    await db.execute(
        "CREATE TABLE aixm (Id INTEGER PRIMARY KEY AUTOINCREMENT, version TEXT, effective INTEGER, origin TEXT, created INTEGER, filename TEXT)");
    await db.execute(
        "CREATE TABLE airports (Id INTEGER PRIMARY KEY AUTOINCREMENT, aixmId INTEGER REFERENCES aixm ON DELETE CASCADE, "
            "txtName TEXT, txtNameCitySer TEXT, "
            "codeIcao TEXT, codeType TEXT, geoLongE6 INTEGER, geoLatE6 INTEGER, xml TEXT)");
    await db.execute(
        "CREATE INDEX airport_location ON airports (geoLongE6, geoLatE6)");
    await db.execute(
        "CREATE TABLE runways (Id INTEGER PRIMARY KEY AUTOINCREMENT, ahpId INTEGER REFERENCES airports ON DELETE CASCADE, "
            "txtDesig TEXT, xml TEXT)");
    await db.execute(
        "CREATE TABLE runwayDirections (Id INTEGER PRIMARY KEY AUTOINCREMENT, rwyId INTEGER REFERENCES runways ON DELETE CASCADE, "
            "txtDesig TEXT, xml TEXT)");
    await db.execute(
        "CREATE TABLE units (Id INTEGER PRIMARY KEY AUTOINCREMENT, ahpId INTEGER REFERENCES airports ON DELETE CASCADE, "
            "txtName TEXT, codeType TEXT, xml TEXT)");
    await db.execute(
        "CREATE TABLE serviceTypes (Id INTEGER PRIMARY KEY AUTOINCREMENT, uniId INTEGER REFERENCES units ON DELETE CASCADE, xml TEXT)");
    await db.execute(
        "CREATE TABLE frequencies (Id INTEGER PRIMARY KEY AUTOINCREMENT, serId INTEGER REFERENCES serviceTypes ON DELETE CASCADE, txtCallSign TEXT, xml TEXT)");
    await db.execute(
        "CREATE TABLE designatedPoints (Id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "aixmId INTEGER REFERENCES aixm ON DELETE CASCADE, txtName TEXT, "
            "ahpId INTEGER REFERENCES airports ON DELETE CASCADE, AhpUid_codeId TEXT, geoLongE6 INTEGER, geoLatE6 INTEGER, xml TEXT)");
    await db.execute(
        "CREATE INDEX designatedPoint_location ON designatedPoints (geoLongE6, geoLatE6)");
    await db.execute(
        "CREATE TABLE gmlPositions (Id INTEGER PRIMARY KEY AUTOINCREMENT, latMinE6 INTEGER, latMaxE6 INTEGER, lonMinE6 INTEGER, lonMaxE6, gmlPostList TEXT)");
    await db.execute(
        "CREATE INDEX gmlPositions_location ON gmlPositions (latMinE6, latMaxE6, lonMinE6, lonMaxE6)");
    await db.execute(
        "CREATE TABLE procedures (Id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "aixmId INTEGER REFERENCES aixm ON DELETE CASCADE, txtName TEXT, "
            "ahpId INTEGER REFERENCES airports ON DELETE CASCADE, codeType TEXT, "
            "beztrajectoryId INTEGER REFERENCES gmlPositions ON DELETE CASCADE, "
            "beztrajectoryAlternateId INTEGER REFERENCES gmlPositions ON DELETE CASCADE, "
            "sceletonPathId INTEGER REFERENCES gmlPositions ON DELETE CASCADE, "
            "tfc_shapePointsId INTEGER REFERENCES gmlPositions ON DELETE CASCADE, xml TEXT)");
    await db.execute(
        "CREATE TABLE airspaces (Id INTEGER PRIMARY KEY AUTOINCREMENT, aixmId INTEGER, "
            "txtName TEXT, codeType TEXT, codeClass TEXT, "
            "gmlPosListId INTEGER REFERENCES gmlPositions ON DELETE CASCADE, codeDistVerUpper TEXT, "
            "valDistVerUpper INTEGER, uomDistVerUpper TEXT, codeDistVerLower TEXT, "
            "valDistVerLower INTEGER, uomDistVerLower TEXT, xml TEXT)");

  }

  _onUpgrade(db.Database db, int oldVersion, int newVersion) async {

  }

  _onOpen(db.Database db) async {
    await db.execute("pragma foreign_keys = ON");
    if (databaseOpened != null) databaseOpened(db);
  }

  Function(db.Database) databaseOpened;

  Future<String> _getDatabasePath(String dbname) async {
    String path = await db.getDatabasesPath();
    try {
      await Directory(path).create(recursive: true);
      path = join(path, dbname);
    } catch (e) {
      log(e.toString());
    }

    return path;
  }
}