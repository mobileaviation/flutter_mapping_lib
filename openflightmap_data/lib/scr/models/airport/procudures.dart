import 'runways.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:xml/xml.dart';
import '../aixm_base.dart';
import '../datatypes.dart';
import 'airports.dart';
import 'types.dart';
import '../../utils/helpers.dart' as hp;
import 'package:geometric_utils/geometric_utils.dart';

class Prc extends AixmBase {
  Prc(XmlElement xmlElement, List<Ahp> airports, int aixmId) : super(xmlElement) {
    _airports = airports;
    this.aixmId = aixmId;
    _parse(xml);
  }
  List<Ahp> _airports;

  int aixmId;
  Uid PrcUid = Uid();
  Ahp airport;
  Rwy runway;
  String txtName;
  String txtNameAbbr;
  String codeType;
  String usageType;
  GeoPoints beztrajectory;
  GeoPoints beztrajectoryAlternate;
  GeoPoints sceletonPath;
  GeoPoints tfc_shapePoints;
  codeDistVerBase codeDistVerTfc;
  uomDistVerBase uomDistVerTfc;
  int valDistVerTfc;
  String type;
  String HoldingEntry_txtName;
  double holdingEntryGeoLat;
  double holdingEntryGeoLong;
  int holdingInboundTrack;
  String holdingOrientation;

  List<Leg> legs = [];

  void _parse(XmlElement e) {
    XmlElement pcrUid = e.findElements("PrcUid").first;
    var ahpUids = pcrUid.findElements("AhpUid");
    XmlElement ahpUid = (ahpUids.length==1) ? ahpUids.first : null;
    if (ahpUid != null) {
      String ahpMid = ahpUid.getAttribute("mid");
      var a = _airports.where((a) => a.AhpUid.mid==ahpMid);
      airport = (a.length==1) ? a.first : null;
      var rwyUids = ahpUid.findElements("RwyUid");
      XmlElement rwyUid = (rwyUids.length==2) ? rwyUids.first: null;
      if (rwyUid != null) {
        String rwyMid = rwyUid.getAttribute("mid");
        var r = airport.runways.where((ru) => ru.RwyUid.mid==rwyMid);
        runway = (r.length==1) ? r.first : null;
      }
    }
    txtName = hp.getValueFrom(e, "txtName");
    txtNameAbbr = hp.getValueFrom(e, "txtNameAbbr");
    codeType = hp.getValueFrom(e, "codeType");
    usageType = hp.getValueFrom(e, "usageType");

    beztrajectory = hp.getGeopointFrom(e, "beztrajectory");
    beztrajectoryAlternate = hp.getGeopointFrom(e, "beztrajectoryAlternate");
    sceletonPath = hp.getGeopointFrom(e, "sceletonPath");
    tfc_shapePoints = hp.getGeopointFrom(e, "tfc_shapePoints");

    codeDistVerTfc = hp.enumValueFromString(hp.getValueFrom(e, "codeDistVerTfc"), codeDistVerBase.values);
    uomDistVerTfc = hp.enumValueFromString(hp.getValueFrom(e, "uomDistVerTfc"), uomDistVerBase.values);
    valDistVerTfc = int.tryParse(hp.getValueFrom(e, "valDistVerTfc"));
    
    holdingEntryGeoLat = double.tryParse(hp.getValueFrom(e, "holdingEntryGeoLat").replaceAll(",", "."));
    holdingEntryGeoLong = double.tryParse(hp.getValueFrom(e, "holdingEntryGeoLong").replaceAll(",", "."));
    holdingInboundTrack = int.tryParse(hp.getValueFrom(e, "holdingInboundTrack"));
    holdingOrientation = hp.getValueFrom(e, "holdingOrientation");
    HoldingEntry_txtName = hp.getValueFrom(e, "HoldingEntry_txtName");

    var legsEl = e.findElements("Leg");
    for(XmlElement l in legsEl) {
      Leg leg = Leg(l);
      this.legs.add(leg);
    }
  }

  Future<int> insertDatabase(Database db) async {
    Map<String, dynamic> values = Map();
    values['aixmId'] = aixmId;
    values["txtName"] = txtName;
    values["ahpId"] = airport.Id;
    values["codeType"] = codeType;

    values["beztrajectoryId"] = await _insertGmlPosList(beztrajectory, db);
    values["beztrajectoryAlternateId"] = await _insertGmlPosList(beztrajectoryAlternate, db);
    values["sceletonPathId"] = await _insertGmlPosList(sceletonPath, db);
    values["tfc_shapePointsId"] = await _insertGmlPosList(tfc_shapePoints, db);

    values["xml"] = this.xml.toXmlString();
    Id = await db.insert("procedures", values);
    return await Id;
  }

  Future<int> _insertGmlPosList(GeoPoints points, Database db) async {
    if (points != null) {
      if (points.length>0)
        return await _insertGmlDatabase(db, points);
    }
    return await null;
  }

  Future<int> _insertGmlDatabase(Database db, GeoPoints geoPoints) async {
    Map<String, dynamic> values = Map();
    values["gmlPostList"] = geoPoints.getGeoPointsStr();
    values["latMinE6"] = geoPoints.boundingBox.minLatitudeE6;
    values["latMaxE6"] = geoPoints.boundingBox.maxLatitudeE6;
    values["lonMinE6"] = geoPoints.boundingBox.minLongitudeE6;
    values["lonMaxE6"] = geoPoints.boundingBox.maxLongitudeE6;
    Id = await db.insert("gmlPositions", values);
    return await Id;
  }
}

class Leg {
  Leg(XmlElement e) { _parse(e); }
  int id;
  String type;
  LegPos entry;
  LegPos exit;
  List<Sector> sectors = [];

  void _parse(XmlElement e) {
    id = int.tryParse(hp.getValueFrom(e, "id"));
    type = hp.getValueFrom(e, "type");
    XmlElement ent = e.findElements("entry").first;
    XmlElement exi = e.findElements("exit").first;
    entry = LegPos(ent);
    exit = LegPos(exi);

    var secs = e.findElements("sector");
    for (XmlElement s in secs) {
      Sector sector = Sector(s);
      sectors.add(sector);
    }
  }
}

class LegPos {
  LegPos(XmlElement e) { _parse(e); }

  String codeType;
  String codeId;
  double geoLat;
  double geoLong;
  String txtName;
  String dpnUid;

  codeDistVerBase codeDistVerUpper;
  uomDistVerBase uomDistVerUpper;
  int valDistVerUpper;
  codeDistVerBase codeDistVerLower;
  uomDistVerBase uomDistVerLower;
  int valDistVerLower;

  void _parse(XmlElement e) {
    var dpnUids = e.findElements("DpnUid");
    _parseDpn(dpnUids);
    var prcUids = e.findElements("PrcUid");
    _parsePrc(prcUids);
    
    codeDistVerUpper = hp.enumValueFromString(hp.getValueFrom(e, "codeDistVerUpper"), codeDistVerBase.values);
    codeDistVerLower = hp.enumValueFromString(hp.getValueFrom(e, "codeDistVerLower"), codeDistVerBase.values);
    uomDistVerUpper = hp.enumValueFromString(hp.getValueFrom(e, "uomDistVerUpper"), uomDistVerBase.values);
    uomDistVerLower = hp.enumValueFromString(hp.getValueFrom(e, "uomDistVerLower"), uomDistVerBase.values);
    valDistVerUpper = int.tryParse(hp.getValueFrom(e, "valDistVerUpper"));
    valDistVerLower = int.tryParse(hp.getValueFrom(e, "valDistVerLower"));
  }

  void _parsePrc(Iterable<XmlElement> prcUids) {
    if (prcUids.length==1) {
      XmlElement d = prcUids.first;
      codeType = hp.getValueFrom(d, "codeType");
      txtName = hp.getValueFrom(d, "txtName");
    }
  }

  void _parseDpn(Iterable<XmlElement> dpnUids) {
    if (dpnUids.length==1) {
      XmlElement d = dpnUids.first;
      codeType = hp.getValueFrom(d, "codeType");
      codeId = hp.getValueFrom(d, "codeId");
      geoLat = double.tryParse(hp.getValueFrom(d, "geoLat"));
      geoLong = double.tryParse(hp.getValueFrom(d, "geoLon"));
      txtName = hp.getValueFrom(d, "txtName");
      dpnUid = d.getAttribute("mid");
    }
  }
}

class Sector {
  Sector(XmlElement e) {
    _parse(e);
  }

  int id;
  String codeType;
  int x;
  int y;
  int visThr;
  GeoPoints geoBounds;

  void _parse(XmlElement e) {
    id = int.tryParse(hp.getValueFrom(e, "id"));
    x = int.tryParse(hp.getValueFrom(e, "x"));
    y = int.tryParse(hp.getValueFrom(e, "y"));
    visThr = int.tryParse(hp.getValueFrom(e, "visThr"));
    codeType = hp.getValueFrom(e, "codeType");
    geoBounds = hp.getGeopointFrom(e, "geoBounds");
  }
}