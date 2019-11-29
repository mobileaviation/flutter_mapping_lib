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

  void readAixm(String filename, String aseFilename) {
    AixmDatabase database = AixmDatabase("ofmTest.db");
    database.databaseOpened = ((db) async {
      var aixmEl = document.findElements("AIXM-Snapshot");
      Aixm aixm = Aixm(aixmEl.first, filename);
      AixmStatus aixmStatus = await aixm.insertDatabase(db);

      if (aixmStatus.update) {
        var ahps = document.findAllElements("Ahp");
        for (xml.XmlElement e in ahps) {
          Ahp ahp = Ahp(e, aixmStatus.aixmId);
          airports.add(ahp);
        }
        log("Ahp");

        var rwys = document.findAllElements("Rwy");
        for (xml.XmlElement r in rwys) {
          Rwy rwy = Rwy(r);
          runways.add(rwy);
        }
        log("Rwy");

        var rdns = document.findAllElements("Rdn");
        for (xml.XmlElement d in rdns) {
          Rdn rdn = Rdn(d);
          runwayDirections.add(rdn);
        }
        log("Rdn");

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

        var dpn = document.findAllElements("Dpn");
        for (xml.XmlElement d in dpn) {
          Dpn dp = Dpn(d, aixmStatus.aixmId);
          repPoints.add(dp);
        }
        log("Dpn");

        for (Uni u in unis) {
          var ss = sers.where((s) => s.UniUid == u.UniUid.mid);
          u.ser = ss.first;
          var ff = frequencies.where((f) => f.SerUid == u.ser.SerUid.mid);
          u.ser.fqys.addAll(ff);
        }

        for (Rwy r in runways) {
          var rdns = runwayDirections.where((d) => d.RwyUid == r.RwyUid.mid);
          if (rdns.length == 2) {
            r.rdnH = rdns.elementAt(0);
            r.rdnL = rdns.elementAt(1);
          }
        }

        for (Ahp a in airports) {
          var rwys = runways.where((r) => r.AhpUid == a.AhpUid.mid);
          a.runways.addAll(rwys);
          var us = unis.where((u) => u.AhpUid.mid == a.AhpUid.mid);
          a.frequencies.addAll(us);
        }

        log("Added runways and frequencies to airports");

        var prc = document.findAllElements("Prc");
        for (xml.XmlElement d in prc) {
          Prc pc = Prc(d, airports, aixmStatus.aixmId);
          procedures.add(pc);
        }
        log("Prc");

        var ase = document.findAllElements("Ase");
        for (xml.XmlElement a in ase) {
          Ase as = Ase(a);
          airspaces.add(as);
        }
        log("Ase");

        var aseS = aseDocument.findAllElements("Ase");
        for (xml.XmlElement a in aseS) {
          AseShape as = AseShape(a);
          airspaceShapes.add(as);
        }
        log("AseSh");

        log("Start inserting data in database");
        insertIntoDatabase(db);
      }
      else {
        log("Update was not nessesary.");
      }
    });

    database.openDatabase();

  }

  Future insertIntoDatabase(Database database) async {
    for (Ahp a in airports) {
      await a.insertDatabase(database);
    }
    log ("Airports inserted into DB");

    for (Dpn dpn in repPoints) {
      await dpn.insertDatabase(database);
    }
    log ("Reporting points inserted into DB");

    await Dpn.updateAhpId(database);
    log("Reporting points AhpId updated");

    for (Prc proc in procedures) {
      await proc.insertDatabase(database);
    }
    log ("Procedures inserted into DB");

    log("Data succesfully inserted into the database");
  }
}