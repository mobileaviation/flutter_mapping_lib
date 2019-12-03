import 'dart:developer';
import 'package:openflightmap_data/scr/models/airport/procudures.dart';
import 'package:openflightmap_data/scr/models/airspace/airspaces.dart';
import 'package:openflightmap_data/scr/models/aixm.dart';

import '../database/database.dart';
import '../models/airport/airports.dart';
import '../models/airport/frequencies.dart';
import '../models/airport/reporting_points.dart';
import '../models/airport/runways.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart' as xml;


class OFMImport {
  OFMImport(String xml_str, String aseXml_str) {
    document = xml.parse(xml_str);
    aseDocument = xml.parse(aseXml_str);
  }

  xml.XmlDocument document;
  xml.XmlDocument aseDocument;
  List<Ahp> airports = [];
  List<Rwy> runways = [];
  List<Rdn> runwayDirections = [];
  List<Uni> unis = [];
  List<Ser> sers = [];
  List<Fqy> frequencies = [];
  List<Dpn> repPoints = [];
  List<Prc> procedures = [];
  List<Ase> airspaces = [];
  List<AseShape> airspaceShapes = [];

  ImportStatus _importStatus;

  void readAixm(String filename, String aseFilename) {
    AixmDatabase database = AixmDatabase("ofmTest.db");
    database.databaseOpened = ((db) async {
      var aixmEl = document.findElements("AIXM-Snapshot");
      Aixm aixm = Aixm(aixmEl.first, filename);
      AixmStatus aixmStatus = await aixm.checkStatus(db);

      if (aixmStatus.update) {
        _doUpdateFromAixmXMLdata(aixmStatus, db);
      }
      else {
        log("Update was not nessesary.");
      }
    });

    database.openDatabase();
  }

  void _doUpdateFromAixmXMLdata(AixmStatus aixmStatus, Database db) async {
    _importStatus = ImportStatus.airports;
    int progress = 0;

    for (ImportStatus s in ImportStatus.values) {
      progress = ((ImportStatus.values.indexOf(s) / ImportStatus.values.length) * 100).floor();
      log("Step ${s.toString()} Progress: ${progress}%");
      switch (s) {
        case ImportStatus.airports:
          {
            _readAirports(aixmStatus);
            break;
          }
        case ImportStatus.runways:
          {
            _readRunways(aixmStatus);
            break;
          }
        case ImportStatus.runways_directions:
          {
            await _readRunwayDirections(aixmStatus);
            break;
          }
        case ImportStatus.frequencies:
          {
            _readFrequencies(aixmStatus);
            break;
          }
        case ImportStatus.reporting_points:
          {
            _readReportingPoints(aixmStatus);
            break;
          }
        case ImportStatus.combine_runways:
          {
            _combineRunways();
            break;
          }
        case ImportStatus.combine_frequencies:
          {
            _combineFrequencies();
            break;
          }
        case ImportStatus.combine_airports:
          {
            await _combineAirports();
            break;
          }
        case ImportStatus.procedures:
          {
            _readProcedures(aixmStatus);
            break;
          }
        case ImportStatus.airspaces:
          {
            _readAirspaces(aixmStatus);
            break;
          }
        case ImportStatus.airspaces_polygons:
          {
            _readAirspaceShapes();
            break;
          }
        case ImportStatus.combine_airspace_polygons:
          {
            _combineAirspaces();
            break;
          }
        case ImportStatus.insert_db_airports:
          {
            await _insertAirports(db);
            break;
          }
        case ImportStatus.insert_db_reporting_points:
          {
            await _insertReportingPoints(db);
            break;
          }
        case ImportStatus.insert_db_procedures:
          {
            await _insertProcedures(db);
            break;
          }
        case ImportStatus.insert_db_airpaces:
          {
            await _insertAirspaces(db);
            break;
          }
      }
    }
    progress = 100;
    log("Finished Progress: ${progress}%");
  }

  void _readAirports(AixmStatus aixmStatus) {
    var ahps = document.findAllElements("Ahp");
    for (xml.XmlElement e in ahps) {
      Ahp ahp = Ahp(e, aixmStatus.aixmId);
      airports.add(ahp);
    }
    log("Ahp");
  }

  void _readRunways(AixmStatus aixmStatus) {
    var rwys = document.findAllElements("Rwy");
    for (xml.XmlElement r in rwys) {
      Rwy rwy = Rwy(r);
      runways.add(rwy);
    }
    log("Rwy");
  }

  void _readRunwayDirections(AixmStatus aixmStatus) {
    var rdns = document.findAllElements("Rdn");
    for (xml.XmlElement d in rdns) {
      Rdn rdn = Rdn(d);
      runwayDirections.add(rdn);
    }
    log("Rdn");
  }

  void _readFrequencies(AixmStatus aixmStatus) {
    var fqys = document.findAllElements("Fqy");
    for (xml.XmlElement d in fqys) {
      Fqy fqy = Fqy(d);
      frequencies.add(fqy);
    }
    log("Fqy");

    var ser = document.findAllElements("Ser");
    for (xml.XmlElement d in ser) {
      Ser s = Ser(d);
      sers.add(s);
    }
    log("Ser");

    var uni = document.findAllElements("Uni");
    for (xml.XmlElement d in uni) {
      Uni u = Uni(d);
      unis.add(u);
    }
    log("Uni");
  }

  void _readReportingPoints(AixmStatus aixmStatus) {
    var dpn = document.findAllElements("Dpn");
    for (xml.XmlElement d in dpn) {
      Dpn dp = Dpn(d, aixmStatus.aixmId);
      repPoints.add(dp);
    }
    log("Dpn");
  }

  void _combineFrequencies() {
    for (Uni u in unis) {
      var ss = sers.where((s) => s.UniUid == u.UniUid.mid);
      u.ser = ss.first;
      var ff = frequencies.where((f) => f.SerUid == u.ser.SerUid.mid);
      u.ser.fqys.addAll(ff);
    }
  }

  void _combineRunways() {
    for (Rwy r in runways) {
      var rdns = runwayDirections.where((d) => d.RwyUid == r.RwyUid.mid);
      if (rdns.length == 2) {
        r.rdnH = rdns.elementAt(0);
        r.rdnL = rdns.elementAt(1);
      }
    }
  }

  void _combineAirports() {
    for (Ahp a in airports) {
      var rwys = runways.where((r) => r.AhpUid == a.AhpUid.mid);
      a.runways.addAll(rwys);
      var us = unis.where((u) => u.AhpUid.mid == a.AhpUid.mid);
      a.frequencies.addAll(us);
    }
  }

  void _readProcedures(AixmStatus aixmStatus) {
    var prc = document.findAllElements("Prc");
    for (xml.XmlElement d in prc) {
      Prc pc = Prc(d, airports, aixmStatus.aixmId);
      procedures.add(pc);
    }
    log("Prc");
  }

  void _readAirspaces(AixmStatus aixmStatus) {
    var ase = document.findAllElements("Ase");
    for (xml.XmlElement a in ase) {
      Ase as = Ase(a, aixmStatus.aixmId);
      airspaces.add(as);
    }
    log("Ase");
  }

  void _readAirspaceShapes() {
    var aseS = aseDocument.findAllElements("Ase");
    for (xml.XmlElement a in aseS) {
      AseShape as = AseShape(a);
      airspaceShapes.add(as);
    }
    log("AseSh");
  }

  void _combineAirspaces() {
    for (Ase as in airspaces) {
      var shape = airspaceShapes.where((s) => s.mid == as.AseUid.mid);
      if (shape.length > 0) as.gmlPosList = shape.first.gmlPosList;
    }
  }

  void _insertAirports(Database db) async {
    for (Ahp a in airports) {
      await a.insertDatabase(db);
    }
    log("Airports inserted into DB");
  }

  void _insertReportingPoints(Database db) async {
    for (Dpn dpn in repPoints) {
      await dpn.insertDatabase(db);
    }
    log("Reporting points inserted into DB");

    await Dpn.updateAhpId(db);
    log("Reporting points AhpId updated");
  }

  void _insertProcedures(Database db) async {
    for (Prc proc in procedures) {
      await proc.insertDatabase(db);
    }
    log("Procedures inserted into DB");
  }

  void _insertAirspaces(Database db) async {
    for (Ase airs in airspaces) {
      await airs.insertDatabase(db);
    }
    log("Airspaces inserted into database");
  }
}

enum ImportStatus {
  airports,
  runways,
  runways_directions,
  frequencies,
  reporting_points,
  combine_runways,
  combine_frequencies,
  combine_airports,
  procedures,
  airspaces,
  airspaces_polygons,
  combine_airspace_polygons,
  insert_db_airports,
  insert_db_reporting_points,
  insert_db_procedures,
  insert_db_airpaces
}