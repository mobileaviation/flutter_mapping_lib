import 'package:xml/xml.dart';

import '../aixm_base.dart';
import '../datatypes.dart';
import 'types.dart';
import '../../utils/helpers.dart' as hp;

/// Runway direction type
/// This class describes one of the two directions of
/// a runway

class Rdn extends AixmBase {
  Uid RdnUid;
  double geoLat;
  double geoLong;
  double valTrueBrg;
  double valMagBrg;

  uomDistHorz xt_uomDispTres;
  uomDistHorz xt_uomDeclDistLimit;
  int  xt_TORA;
  int xt_LDA;
}

/// Runway type
/// This class describes the whole of the runway
class Rwy extends AixmBase {
  Uid RwyUid = Uid();

  Rdn rdnL = Rdn();
  Rdn rdnH = Rdn();

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
}

Rwy parseRwy(XmlElement e) {
  Rwy rwy = Rwy();

  XmlElement rwyUid = e.findElements("RwyUid").first;
  //rwy.RwyUid.mid = rwyUid.getAttribute("mid");
  rwy.RwyUid.txtDesig = hp.getValueFrom(rwyUid, "txtDesig");

  rwy.valLen = int.tryParse(hp.getValueFrom(e, "valLen"));
  rwy.valWid = int.tryParse(hp.getValueFrom(e, "valWid"));
  rwy.valLenStrip = int.tryParse(hp.getValueFrom(e, "valLenStrip"));
  rwy.valWidStrip = int.tryParse(hp.getValueFrom(e, "valWidStrip"));
  rwy.valPcnClass = int.tryParse(hp.getValueFrom(e, "valPcnClass"));
  rwy.txtPcnNote = hp.getValueFrom(e, "txtPcnNote");

  rwy.xt_status = hp.getValueFrom(e, "xt_status");

  rwy.uomDimRwy = hp.enumValueFromString(hp.getValueFrom(e, "uomDistHorz"), uomDistHorz.values);
  rwy.uomDimStrip = hp.enumValueFromString(hp.getValueFrom(e, "uomDimStrip"), uomElev.values);
  rwy.codePcnPavementType = hp.enumValueFromString(hp.getValueFrom(e, "codePcnPavementType"), codePcnPavementTypeBase.values);
  rwy.codePcnEvalMethod = hp.enumValueFromString(hp.getValueFrom(e, "codePcnEvalMethod"), codePcnEvalMethodBase.values);
  rwy.codePcnPavementSubgrade = hp.enumValueFromString(hp.getValueFrom(e, "codePcnPavementSubgrade"), codePcnPavementSubgradeBase.values);
  rwy.codePcnMaxTirePressure = hp.enumValueFromString(hp.getValueFrom(e, "codePcnMaxTirePressure"), codePcnMaxTirePressureBase.values);
  rwy.codeComposition = hp.enumValueFromString(hp.getValueFrom(e, "codeComposition"), codeCompositionSfcBase.values);

  return rwy;
}