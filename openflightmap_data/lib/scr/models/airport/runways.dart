import 'package:sqflite/sqlite_api.dart';
import 'package:xml/xml.dart';
import '../aixm_base.dart';
import '../datatypes.dart';
import 'types.dart';
import '../../utils/helpers.dart' as hp;

/// Runway direction type
/// This class describes one of the two directions of
/// a runway
class Rdn extends AixmBase {
  int rwyId;

  Uid RdnUid = Uid();
  String RwyUid;
  double geoLat;
  double geoLong;
  double valTrueBrg;
  double valMagBrg;
  uomDistHorz xt_uomDispTres;
  uomDistHorz xt_uomDeclDistLimit;
  int  xt_TORA;
  int xt_LDA;

  Rdn(XmlElement xmlElement) : super(xmlElement) {
    if (xml != null) _parse(xml);
  }

  void _parse(XmlElement e) {
    XmlElement rndUid = e.findElements("RdnUid").first;
    RdnUid.mid = rndUid.getAttribute("mid");
    RdnUid.txtDesig = hp.getValueFrom(rndUid, "txtDesig");
    RwyUid = e.findAllElements("RwyUid").first.getAttribute("mid");
    geoLat = hp.getGeo(hp.getValueFrom(e, "geoLat"));
    geoLong = hp.getGeo(hp.getValueFrom(e, "geoLong"));
    valTrueBrg = double.tryParse(hp.getValueFrom(e, "valTrueBrg"));
    valMagBrg = double.tryParse(hp.getValueFrom(e, "valMagBrg"));
    xt_LDA = int.tryParse(hp.getValueFrom(e, "xt_LDA"));
    xt_TORA = int.tryParse(hp.getValueFrom(e, "xt_TORA"));
    xt_uomDispTres = hp.enumValueFromString(hp.getValueFrom(e, "xt_uomDispTres"), uomDistHorz.values);
    xt_uomDeclDistLimit = hp.enumValueFromString(hp.getValueFrom(e, "xt_uomDeclDistLimit"), uomDistHorz.values);
  }

  Future<int> insertDatabase(Database db) async {
    Map<String, dynamic> values = Map();
    values["rwyId"] = this.rwyId;
    values["txtDesig"] = this.RdnUid.txtDesig;
    values["xml"] = this.xml.toXmlString();
    Id = await db.insert("runwayDirections", values);
    return await Id;
  }
}

/// Runway type
/// This class describes the whole of the runway
class Rwy extends AixmBase {
  int ahpId;

  Uid RwyUid = Uid();
  String AhpUid;

  Rdn rdnL = Rdn(null);
  Rdn rdnH = Rdn(null);

  uomDistHorz uomDimRwy;
  String xt_status;

  codeCompositionSfcBase codeComposition;

  int valLenStrip;
  int valWidStrip;
  uomElev uomDimStrip;
  int valPcnClass;

  String txtPcnNote;

  codePcnPavementTypeBase codePcnPavementType;
  codePcnPavementSubgradeBase codePcnPavementSubgrade;
  codePcnMaxTirePressureBase codePcnMaxTirePressure;

  codePcnEvalMethodBase codePcnEvalMethod;

  List<TypeOfRunwayLighting> xt_lighting = [];

  int valLen;
  int valWid;

  Rwy(XmlElement xmlElement) : super(xmlElement){
    if (xml != null) _parse(xml);
  }

  void _parse(XmlElement e) {
    XmlElement rwyUid = e.findElements("RwyUid").first;
    RwyUid.txtDesig = hp.getValueFrom(rwyUid, "txtDesig");
    RwyUid.mid = rwyUid.getAttribute("mid");
    valLen = int.tryParse(hp.getValueFrom(e, "valLen"));
    valWid = int.tryParse(hp.getValueFrom(e, "valWid"));
    valLenStrip = int.tryParse(hp.getValueFrom(e, "valLenStrip"));
    valWidStrip = int.tryParse(hp.getValueFrom(e, "valWidStrip"));
    valPcnClass = int.tryParse(hp.getValueFrom(e, "valPcnClass"));
    txtPcnNote = hp.getValueFrom(e, "txtPcnNote");
    AhpUid = e.findAllElements("AhpUid").first.getAttribute("mid");
    xt_status = hp.getValueFrom(e, "xt_status");
    uomDimRwy = hp.enumValueFromString(hp.getValueFrom(e, "uomDistHorz"), uomDistHorz.values);
    uomDimStrip = hp.enumValueFromString(hp.getValueFrom(e, "uomDimStrip"), uomElev.values);
    codePcnPavementType = hp.enumValueFromString(hp.getValueFrom(e, "codePcnPavementType"), codePcnPavementTypeBase.values);
    codePcnEvalMethod = hp.enumValueFromString(hp.getValueFrom(e, "codePcnEvalMethod"), codePcnEvalMethodBase.values);
    codePcnPavementSubgrade = hp.enumValueFromString(hp.getValueFrom(e, "codePcnPavementSubgrade"), codePcnPavementSubgradeBase.values);
    codePcnMaxTirePressure = hp.enumValueFromString(hp.getValueFrom(e, "codePcnMaxTirePressure"), codePcnMaxTirePressureBase.values);
    codeComposition = hp.enumValueFromString(hp.getValueFrom(e, "codeComposition"), codeCompositionSfcBase.values);
  }

  Future<int> insertDatabase(Database db) async {
    Map<String, dynamic> values = Map();
    values["ahpId"] = this.ahpId;
    values["txtDesig"] = this.RwyUid.txtDesig;
    values["xml"] = this.xml.toXmlString();
    Id = await db.insert("runways", values);
    rdnL.rwyId = Id;
    await rdnL.insertDatabase(db);
    rdnH.rwyId = Id;
    await rdnH.insertDatabase(db);
    return await Id;
  }
}



