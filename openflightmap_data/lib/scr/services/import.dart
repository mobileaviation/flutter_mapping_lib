import 'dart:developer';
import 'package:openflightmap_data/scr/models/airport/airports.dart';
import 'package:openflightmap_data/scr/models/airport/runways.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml2json/xml2json.dart' as json;

class OFMImport {
  OFMImport(String xml_str) {
    document = xml.parse(xml_str);
    xml2json = json.Xml2Json();
  }

  xml.XmlDocument document;
  json.Xml2Json xml2json;

  void readAhp() {
    var ahps = document.findAllElements("Ahp");
    for (xml.XmlElement e in ahps) {

//      xml2json.parse(e.toXmlString());
//      String json1 = xml2json.toBadgerfish();
//      String json2 = xml2json.toGData();
//      String json3 = xml2json.toParker();

      //String ahpxml = e.toXmlString(pretty: true);

      Ahp ahp = parseAhp(e);
      log("Parsed: ${ahp.txtName}");

      var rwys = document.descendants.where((value) =>
        value is xml.XmlElement && value.name.local=="Rwy" &&  (value.findAllElements("AhpUid").first.getAttribute("mid")== ahp.AhpUid.mid.toString() )
      );

      for (xml.XmlElement r in rwys) {
        Rwy rwy = parseRwy(r);
        ahp.runways.add(rwy);
      }

      log ("Rwy");

    }
    log("Ahp");
  }

}