import 'dart:io';
import 'package:sqflite/sqlite_api.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart' as path;
import '../utils/helpers.dart' as hp;

class Aixm {
  Aixm(XmlElement e, String filename) {
    this.filename = path.Context().basenameWithoutExtension(filename);
    _parse(e);
  }

  int Id;
  String version;
  DateTime effective;
  String origin;
  DateTime created;
  String filename;

  void _parse(XmlElement e) {
    version = e.getAttribute("version");
    origin = e.getAttribute("origin");
    effective = DateTime.tryParse(e.getAttribute("effective"));
    created = DateTime.tryParse(e.getAttribute("created"));
  }

  Future<AixmStatus> insertDatabase(Database db) async {
    AixmStatus s = AixmStatus();
    s.update = await _checkDoUpdate(db);

    if (s.update) {
      await db.delete('aixm', where: 'filename=?', whereArgs: [filename]);
      Map<String, dynamic> values = Map();
      values["version"] = this.version;
      values["effective"] = this.effective.millisecondsSinceEpoch;
      values["origin"] = this.origin;
      values["created"] = this.created.millisecondsSinceEpoch;
      values["filename"] = filename;
      Id = await db.insert("aixm", values);
      s.aixmId = Id;
    }

    return await s;
  }

  Future<bool> _checkDoUpdate(Database db) async {
    String q = "SELECT Id FROM aixm WHERE effective>="
        "? AND filename=?";
    List<Map<String, dynamic>> res =
      await db.rawQuery(q, [this.effective.millisecondsSinceEpoch, this.filename]);
    return await true; //(res.length==0);
  }
}

class AixmStatus {
  int aixmId;
  bool update;
}