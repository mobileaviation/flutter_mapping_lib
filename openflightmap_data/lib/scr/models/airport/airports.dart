import 'dart:developer';
import '../../utils/helpers.dart' as hp;

/// AIXM classes for OpenFlightMap data
/// <Ase/> Airport data
///

import 'package:xml/xml.dart';
import '../aixm_base.dart';
import '../datatypes.dart';
import 'types.dart';
import 'runways.dart';
import 'frequencies.dart';

class Ahp extends AixmBase {
  Uid AhpUid = Uid();
  Uid OrgUid = Uid();

  List<Rwy> runways = [];

  List<Fqy> frequencies = [];

  String txtDescrSite;
  String txtNameAdmin;
  String txtNameCitySer;
  String txtRmk;
  String codeIcao;
  String codeIata;

  codeTypeAdHp codeType;
  String xt_txtUrl;
  String xt_txtPhone;
  String xt_email;
  String xt_GpsIdent;
  String xt_addFreq;
  bool xt_CustomsAvail;

  List<TypeOfTraffic> xt_TypeOfTraffic = [];
  List<TypeOfUsage> xt_TypeOfUsage = [];
  List<TypeOfAircraft> xt_TypeOfAircraft = [];
  List<TypeOfFuel> xt_TypesOfFuel = [];

  String PPR_txtContact;
  String PPR_txtEmail;
  String PPR_txtPhone;

  double geoLong; // convert W to negative E to positive
  double geoLat; // convert N to positive S to negative

  int dateMagVar;
  double valMagVar;
  double valMagVarChg;

  double valRefT;
  uomT uomRefT;
  uomElev uomTransitionAlt;
  int valTransitionAlt;
  int valElev;
  uomElev uomDistVer;
}

Ahp parseAhp(XmlElement e) {
  Ahp ahp = Ahp();
  ahp.xt_fir = e.getAttribute("xt_fir");

  XmlElement ahpUid = e.findElements("AhpUid").first;
  ahp.AhpUid.codeId = hp.getValueFrom(ahpUid, "codeId");
  ahp.AhpUid.mid = int.tryParse(ahpUid.getAttribute("mid"));

  XmlElement orgUid = e.findElements("OrgUid").first;
  ahp.OrgUid.txtName = hp.getValueFrom(orgUid, "txtName");

  ahp.xt_CustomsAvail = (e.children.where((node) => node is XmlElement && node.name.local=="xt_CustomsAvail").length>0);

  XmlElement typeOfTrafficEl = e.findElements("xt_TypeOfTraffic").first;
  for (XmlNode e in typeOfTrafficEl.children) {
    if (e is XmlElement) {
      ahp.xt_TypeOfTraffic.add(hp.enumValueFromString(e.name.local, TypeOfTraffic.values));
    }
  }
  ahp.PPR_txtContact = hp.getValueFrom(typeOfTrafficEl, "PPR_txtContact");
  ahp.PPR_txtEmail = hp.getValueFrom(typeOfTrafficEl, "PPR_txtEmail");
  ahp.PPR_txtPhone = hp.getValueFrom(typeOfTrafficEl, "PPR_txtPhone");

  XmlElement typeOfUsageEl = e.findElements("xt_TypeOfUsage").first;
  for (XmlNode e in typeOfUsageEl.children) {
    if (e is XmlElement) {
      ahp.xt_TypeOfUsage.add(hp.enumValueFromString(e.name.local, TypeOfUsage.values));
    }
  }

  XmlElement typeOfAircraft = e.findElements("xt_TypeOfAircraft").first;
  for (XmlNode e in typeOfAircraft.children) {
    if (e is XmlElement) {
      ahp.xt_TypeOfAircraft.add(hp.enumValueFromString(e.name.local, TypeOfAircraft.values));
    }
  }

  XmlElement typeOfFuel = e.findElements("xt_TypesOfFuel").first;
  for (XmlNode e in typeOfFuel.children) {
    if (e is XmlElement) {
      ahp.xt_TypesOfFuel.add(hp.enumValueFromString(e.name.local, TypeOfFuel.values));
    }
  }

  ahp.txtName = hp.getValueFrom(e, "txtName");
  ahp.codeIcao = hp.getValueFrom(e, "codeIcao");
  ahp.codeIata = hp.getValueFrom(e, "codeIata");
  ahp.dateMagVar = int.tryParse(hp.getValueFrom(e, "dateMagVar"));
  ahp.valMagVar = double.tryParse(hp.getValueFrom(e, "valMagVar"));
  ahp.valMagVarChg = double.tryParse(hp.getValueFrom(e, "valMagVarChg"));
  ahp.valRefT = double.tryParse(hp.getValueFrom(e, "valRefT"));
  ahp.valTransitionAlt = int.tryParse(hp.getValueFrom(e, "valTransitionAlt"));
  ahp.valElev = int.tryParse(hp.getValueFrom(e, "valElev"));
  ahp.txtRmk = hp.getValueFrom(e, "txtRmk");
  ahp.txtDescrSite = hp.getValueFrom(e, "txtDescrSite");
  ahp.txtNameAdmin = hp.getValueFrom(e, "txtNameAdmin");
  ahp.geoLat = hp.getGeo(hp.getValueFrom(e, "geoLat"));
  ahp.geoLong = hp.getGeo(hp.getValueFrom(e, "geoLong"));
  ahp.xt_GpsIdent = hp.getValueFrom(e, "xt_GpsIdent");
  ahp.xt_addFreq = hp.getValueFrom(e, "xt_addFreq");

  ahp.codeType = hp.enumValueFromString(hp.getValueFrom(e, "codeType"), codeTypeAdHp.values);
  ahp.uomRefT = hp.enumValueFromString(hp.getValueFrom(e, "uomRefT"), uomT.values);
  ahp.uomTransitionAlt = hp.enumValueFromString(hp.getValueFrom(e, "uomTransitionAlt"), uomElev.values);
  ahp.uomDistVer = hp.enumValueFromString(hp.getValueFrom(e, "uomDistVer"), uomElev.values);

  return ahp;
}
