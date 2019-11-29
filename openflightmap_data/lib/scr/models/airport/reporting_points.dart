import 'package:sqflite/sqlite_api.dart';
import 'package:xml/xml.dart';
import '../aixm_base.dart';
import '../datatypes.dart';
import 'types.dart';
import '../../utils/helpers.dart' as hp;
import 'package:geometric_utils/geometric_utils.dart' as utils;

/// DesignatedPointType Class
class Dpn extends AixmBase {
  Dpn(XmlElement xmlElement, int aixmId) : super(xmlElement) {
    this.aixmId = aixmId;
    _parse(xml);
  }

  int aixmId;
  String mid;
  String codeId;
  double geoLong;
  double geoLat;
  String codeType;
  uomFreqBase uomFreq;
  String AhpUid_codeId;
  int ahpId;
  codeTypeNorthBase codeTypeNorth;
  codeDatumBase codeDatum;


  void _parse(XmlElement e) {
    XmlElement dpnUid = e.findElements("DpnUid").first;
    mid = dpnUid.getAttribute("mid");
    codeId = hp.getValueFrom(dpnUid, "codeId");
    geoLat = hp.getGeo(hp.getValueFrom(dpnUid, "geoLat"));
    geoLong = hp.getGeo(hp.getValueFrom(dpnUid, "geoLong"));
    txtName = hp.getValueFrom(e, "txtName");
    codeType = hp.getValueFrom(e, "codeType");
    uomFreq = hp.enumValueFromString(hp.getValueFrom(e, "uomFreq"), uomFreqBase.values);
    codeTypeNorth = hp.enumValueFromString(hp.getValueFrom(e, "codeTypeNorth"), codeTypeNorthBase.values);
    AhpUid_codeId = hp.getValueFrom(e, "AhpUid_codeId");
    codeDatum = hp.enumValueFromString(hp.getValueFrom(e, "codeDatum"), codeDatumBase.values);
  }

  Future<int> insertDatabase(Database db) async {
    Map<String, dynamic> values = Map();
    values["aixmId"] = this.aixmId;
    values["ahpId"] = this.ahpId;
    values["txtName"] = this.txtName;
    values["AhpUid_codeId"] = this.AhpUid_codeId;
    values["geoLongE6"] = utils.degreeToE6(this.geoLong);
    values["geoLatE6"] = utils.degreeToE6(this.geoLat);
    values["xml"] = this.xml.toXmlString();
    Id = await db.insert("designatedPoints", values);
    return await Id;
  }

  static Future updateAhpId(Database db) async {
    String q = "UPDATE designatedPoints SET ahpId = (SELECT Id FROM airports WHERE codeIcao=designatedPoints.AhpUid_codeId)";
    return await db.execute(q);
  }
}