import 'package:geometric_utils/geometric_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart';
import '../aixm_base.dart';
import '../datatypes.dart';
import '../../utils/helpers.dart' as hp;

/// AIXM Airspaces
///
class Ase extends AixmBase{
  int aixmId;
  String xt_classLayersAvail;
  Uid AseUid = Uid();
  codeClassAsBase codeClass;
  codeTypeAsBase codeType;
  String txtLocalType;
  codeDistVerBase codeDistVerUpper;
  uomDistVerBase uomDistVerUpper;
  int valDistVerUpper;
  codeDistVerBase codeDistVerLower;
  uomDistVerBase uomDistVerLower;
  int valDistVerLower;
  int valDistVerMnm;
  bool xt_selAvail;
  GeoPoints gmlPosList;

  void _parse(XmlElement e) {
    xt_fir = e.getAttribute("xt_fir");
    xt_classLayersAvail = e.getAttribute("xt_classLayersAvail");
    txtName = hp.getValueFrom(e, "txtName");
    txtLocalType = hp.getValueFrom(e, "txtLocalType");
    var aseUids = e.findElements("AseUid");
    XmlElement aseUid = aseUids.first;
    AseUid.mid = aseUid.getAttribute("mid");
    AseUid.codeId = hp.getValueFrom(aseUid, "codeId");
    codeType = hp.enumValueFromString(hp.getValueFrom(aseUid, "codeType"), codeTypeAsBase.values);
    codeClass = hp.enumValueFromString(hp.getValueFrom(e, "codeClass"), codeClassAsBase.values);
    xt_selAvail = !(hp.getValueFrom(e, "xt_selAvail")=="False");

    codeDistVerUpper = hp.enumValueFromString(hp.getValueFrom(e, "codeDistVerUpper"), codeDistVerBase.values);
    codeDistVerLower = hp.enumValueFromString(hp.getValueFrom(e, "codeDistVerLower"), codeDistVerBase.values);
    uomDistVerUpper = hp.enumValueFromString(hp.getValueFrom(e, "uomDistVerUpper"), uomDistVerBase.values);
    uomDistVerLower = hp.enumValueFromString(hp.getValueFrom(e, "uomDistVerLower"), uomDistVerBase.values);
    valDistVerUpper = int.tryParse(hp.getValueFrom(e, "valDistVerUpper"));
    valDistVerLower = int.tryParse(hp.getValueFrom(e, "valDistVerLower"));
    valDistVerMnm = int.tryParse(hp.getValueFrom(e, "valDistVerMnm"));
  }
  
  Ase(XmlElement xmlElement, int aixmId) : super(xmlElement) {
    this.aixmId = aixmId;
    xml = xmlElement;
    _parse(xmlElement);
  }

  Future<int> insertDatabase(Database db) async {
    Map<String, dynamic> values = Map();
    values['aixmId'] = aixmId;
    values["txtName"] = txtName;
    values["codeType"] = codeType.toString();
    values["codeClass"] = codeClass.toString();
    values["codeDistVerUpper"] = codeDistVerUpper.toString();
    values["codeDistVerLower"] = codeDistVerLower.toString();
    values["uomDistVerUpper"] = uomDistVerUpper.toString();
    values["uomDistVerLower"] = uomDistVerLower.toString();
    values["valDistVerUpper"] = valDistVerUpper;
    values["valDistVerLower"] = valDistVerLower;
    values["gmlPosListId"] = await _insertGmlPosList(gmlPosList, db);
    values["xml"] = this.xml.toXmlString();
    Id = await db.insert("airspaces", values);
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

class AseShape {
  String mid;
  GeoPoints gmlPosList;

  AseShape(XmlElement e) {
    mid = e.getAttribute("mid");
    gmlPosList = hp.getGeopointsFromString(hp.getValueFrom(e, "gmlPosList"));
  }
}