import 'dart:developer';
import 'package:geometric_utils/geometric_utils.dart' as utils;
import 'package:sqflite/sqflite.dart';
import '../../utils/helpers.dart' as hp;
import 'package:xml/xml.dart';
import '../aixm_base.dart';
import '../datatypes.dart';
import 'types.dart';
import 'runways.dart';
import 'frequencies.dart';

class Ahp extends AixmBase {
  Uid AhpUid = Uid();
  Uid OrgUid = Uid();
  int aixmId;

  List<Rwy> runways = [];
  List<Uni> frequencies = [];

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

  Ahp(XmlElement xmlElement, int aixmId) : super(xmlElement) {
    this.aixmId = aixmId;
    if (xml != null) _parse(xml);
  }

  void _parse(XmlElement e) {
    xt_fir = e.getAttribute("xt_fir");
    XmlElement ahpUid = e.findElements("AhpUid").first;
    AhpUid.codeId = hp.getValueFrom(ahpUid, "codeId");
    AhpUid.mid = ahpUid.getAttribute("mid");
    XmlElement orgUid = e.findElements("OrgUid").first;
    OrgUid.txtName = hp.getValueFrom(orgUid, "txtName");
    xt_CustomsAvail = (e.children.where((node) => node is XmlElement && node.name.local=="xt_CustomsAvail").length>0);

    XmlElement typeOfTrafficEl = e.findElements("xt_TypeOfTraffic").first;
    for (XmlNode e in typeOfTrafficEl.children) {
      if (e is XmlElement) {
        xt_TypeOfTraffic.add(hp.enumValueFromString(e.name.local, TypeOfTraffic.values));
      }
    }

    PPR_txtContact = hp.getValueFrom(typeOfTrafficEl, "PPR_txtContact");
    PPR_txtEmail = hp.getValueFrom(typeOfTrafficEl, "PPR_txtEmail");
    PPR_txtPhone = hp.getValueFrom(typeOfTrafficEl, "PPR_txtPhone");

    XmlElement typeOfUsageEl = e.findElements("xt_TypeOfUsage").first;
    for (XmlNode e in typeOfUsageEl.children) {
      if (e is XmlElement) {
        TypeOfUsage typeOfUsage = hp.enumValueFromString(e.name.local, TypeOfUsage.values);
        if (typeOfUsage != null) xt_TypeOfUsage.add(typeOfUsage);
      }
    }

    XmlElement typeOfAircraft = e.findElements("xt_TypeOfAircraft").first;
    for (XmlNode e in typeOfAircraft.children) {
      if (e is XmlElement) {
        TypeOfAircraft typeOfAircraft = hp.enumValueFromString(e.name.local, TypeOfAircraft.values);
        if (typeOfAircraft != null) xt_TypeOfAircraft.add(typeOfAircraft);
      }
    }

    XmlElement typeOfFuel = e.findElements("xt_TypesOfFuel").first;
    for (XmlNode e in typeOfFuel.children) {
      if (e is XmlElement) {
        TypeOfFuel typeOfFuel = hp.enumValueFromString(e.name.local, TypeOfFuel.values);
        if (typeOfFuel != null) xt_TypesOfFuel.add(typeOfFuel);
      }
    }

    txtName = hp.getValueFrom(e, "txtName");
    codeIcao = hp.getValueFrom(e, "codeIcao");
    codeIata = hp.getValueFrom(e, "codeIata");
    dateMagVar = int.tryParse(hp.getValueFrom(e, "dateMagVar"));
    valMagVar = double.tryParse(hp.getValueFrom(e, "valMagVar"));
    valMagVarChg = double.tryParse(hp.getValueFrom(e, "valMagVarChg"));
    valRefT = double.tryParse(hp.getValueFrom(e, "valRefT"));
    valTransitionAlt = int.tryParse(hp.getValueFrom(e, "valTransitionAlt"));
    valElev = int.tryParse(hp.getValueFrom(e, "valElev"));
    txtRmk = hp.getValueFrom(e, "txtRmk");
    txtDescrSite = hp.getValueFrom(e, "txtDescrSite");
    txtNameAdmin = hp.getValueFrom(e, "txtNameAdmin");
    txtNameCitySer = hp.getValueFrom(e, "txtNameCitySer");
    xt_txtUrl = hp.getValueFrom(e, "xt_txtUrl");
    xt_txtPhone = hp.getValueFrom(e, "xt_txtPhone");
    xt_email = hp.getValueFrom(e, "xt_email");
    geoLat = hp.getGeo(hp.getValueFrom(e, "geoLat"));
    geoLong = hp.getGeo(hp.getValueFrom(e, "geoLong"));
    xt_GpsIdent = hp.getValueFrom(e, "xt_GpsIdent");
    xt_addFreq = hp.getValueFrom(e, "xt_addFreq");
    codeType = hp.enumValueFromString(hp.getValueFrom(e, "codeType"), codeTypeAdHp.values);
    uomRefT = hp.enumValueFromString(hp.getValueFrom(e, "uomRefT"), uomT.values);
    uomTransitionAlt = hp.enumValueFromString(hp.getValueFrom(e, "uomTransitionAlt"), uomElev.values);
    uomDistVer = hp.enumValueFromString(hp.getValueFrom(e, "uomDistVer"), uomElev.values);
  }

  Future<int> insertDatabase(Database db) async {
    Map<String, dynamic> values = Map();
    values["aixmId"] = this.aixmId;
    values["txtName"] = this.txtName;
    values["txtNameCitySer"] = this.txtNameCitySer;
    values["codeIcao"] = this.codeIcao;
    values["codeType"] = this.codeType.toString();
    values["geoLongE6"] = utils.degreeToE6(this.geoLong);
    values["geoLatE6"] = utils.degreeToE6(this.geoLat);
    values["xml"] = this.xml.toXmlString();
    Id = await db.insert("airports", values);
    for(Rwy r  in runways) {
      r.ahpId = Id;
      await r.insertDatabase(db);
    }
    for(Uni f in frequencies) {
      f.ahpId = Id;
      await f.insertDatabase(db);
    }
    return await Id;
  }
}


