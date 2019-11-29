import 'package:sqflite/sqlite_api.dart';
import 'package:xml/xml.dart';
import '../aixm_base.dart';
import '../datatypes.dart';
import '../../utils/helpers.dart' as hp;

/// Unit class
class Uni extends AixmBase {
  int ahpId;

  Uid UniUid = Uid();
  Uid OrgUid = Uid();
  Uid AhpUid = Uid();
  codeTypeSerBase codeType;
  Ser ser = Ser(null);

  Uni(XmlElement xmlElement) : super(xmlElement) {
    if (xml != null) _parse(xml);
  }

  @override
  void _parse(XmlElement e) {
    xt_fir = e.getAttribute("xt_fir");
    XmlElement uniUid = e.findElements("UniUid").first;
    UniUid.mid = uniUid.getAttribute("mid");
    UniUid.txtName = hp.getValueFrom(uniUid, "txtName");
    txtName = UniUid.txtName;
    XmlElement orgUid = e.findElements("OrgUid").first;
    OrgUid.txtName = hp.getValueFrom(orgUid, "txtName");
    XmlElement ahpUid = e.findElements("AhpUid").first;
    AhpUid.mid = ahpUid.getAttribute("mid");
    AhpUid.codeId = hp.getValueFrom(ahpUid, "codeId");

    codeType = hp.enumValueFromString(hp.getValueFrom(e, "codeType"), codeTypeSerBase.values);
  }

  Future<int> insertDatabase(Database db) async {
    Map<String, dynamic> values = Map();
    values["ahpId"] = this.ahpId;
    values["txtName"] = this.txtName;
    values["codeType"] = this.codeType.toString();
    values["xml"] = this.xml.toXmlString();
    Id = await db.insert("units", values);
    ser.uniId = Id;
    await ser.insertDatabase(db);
    return await Id;
  }
}

/// Service class
class Ser extends AixmBase {
  int uniId;

  Uid SerUid = Uid();
  String UniUid;
  String txtRmk;
  List<Fqy> fqys = [];

  Ser(XmlElement xmlElement) : super(xmlElement){
    if (xml != null) _parse(xml);
  }

  void _parse(XmlElement e) {
    XmlElement serUid = e.findElements("SerUid").first;
    SerUid.mid = serUid.getAttribute("mid");
    XmlElement uniUid = serUid.findElements("UniUid").first;
    UniUid = uniUid.getAttribute("mid");
    txtRmk = hp.getValueFrom(e, "txtRmk");
  }

  Future<int> insertDatabase(Database db) async {
    Map<String, dynamic> values = Map();
    values["uniId"] = this.uniId;
    values["xml"] = this.xml.toXmlString();
    Id = await db.insert("serviceTypes", values);
    for (Fqy f in fqys) {
      f.serId = Id;
      await f.insertDatabase(db);
    }
    return await Id;
  }
}

/// Frequency class
class Fqy extends AixmBase {
  int serId;

  Uid FqyUid = Uid();
  String SerUid;
  String valFreqRec;
  bool xt_primary;
  uomFreqBase uomFreq;
  String txtCallSign;

  Fqy(XmlElement xmlElement) : super(xmlElement) {
    if (xml != null) _parse(xml);
  }

  void _parse(XmlElement e) {
    XmlElement fqyUid = e.findElements("FqyUid").first;
    FqyUid.mid = fqyUid.getAttribute("mid");

    XmlElement serUid = fqyUid.findElements("SerUid").first;
    SerUid = serUid.getAttribute("mid");

    valFreqRec = hp.getValueFrom(e, "valFreqRec");
    xt_primary = (hp.getValueFrom(e, "xt_primary")=="True") ? true : false;
    uomFreq = hp.enumValueFromString(hp.getValueFrom(e, "uomFreq"), uomFreqBase.values);

    XmlElement cdl = e.findElements("Cdl").first;
    txtCallSign = hp.getValueFrom(cdl, "txtCallSign");
  }

  Future<int> insertDatabase(Database db) async {
    Map<String, dynamic> values = Map();
    values["serId"] = this.serId;
    values["txtCallSign"] = this.txtCallSign;
    values["xml"] = this.xml.toXmlString();
    Id = await db.insert("frequencies", values);
    return await Id;
  }
}

