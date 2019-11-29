import 'package:geometric_utils/geometric_utils.dart';
import 'package:xml/xml.dart';
import '../aixm_base.dart';
import '../datatypes.dart';
import '../../utils/helpers.dart' as hp;

/// AIXM Airspaces
///
class Ase extends AixmBase{
  String xt_classLayersAvail;
  Uid AseUid = Uid();
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
    var aseUids = e.findElements("AseUid");
    XmlElement aseUid = aseUids.first;
    AseUid.mid = hp.getValueFrom(aseUid, "mid");
    AseUid.codeType = hp.enumValueFromString(hp.getValueFrom(aseUid, "codeType"), codeTypeSerBase.values);
    AseUid.codeId = hp.getValueFrom(aseUid, "codeId");

    codeDistVerUpper = hp.enumValueFromString(hp.getValueFrom(e, "codeDistVerUpper"), codeDistVerBase.values);
    codeDistVerLower = hp.enumValueFromString(hp.getValueFrom(e, "codeDistVerLower"), codeDistVerBase.values);
    uomDistVerUpper = hp.enumValueFromString(hp.getValueFrom(e, "uomDistVerUpper"), uomDistVerBase.values);
    uomDistVerLower = hp.enumValueFromString(hp.getValueFrom(e, "uomDistVerLower"), uomDistVerBase.values);
    valDistVerUpper = int.tryParse(hp.getValueFrom(e, "valDistVerUpper"));
    valDistVerLower = int.tryParse(hp.getValueFrom(e, "valDistVerLower"));
  }
  
  Ase(XmlElement xmlElement) : super(xmlElement) {
    xml = xmlElement;
    _parse(xmlElement);
  }
}

class AseShape {
  String mid;
  GeoPoints gmlPosList;

  AseShape(XmlElement e) {
    mid = e.getAttribute("mid");
    gmlPosList = hp.getGeopointFrom(e, "gmlPosList");
  }
}