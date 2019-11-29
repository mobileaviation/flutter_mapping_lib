import 'package:xml/xml.dart';
import 'datatypes.dart';

class AixmBase {
  int Id;

  AixmBase(XmlElement xmlElement) {
    xml = xmlElement;
  }
  XmlElement xml;

  String xt_fir;
  String txtName;

  void _parse(XmlElement xmlElement) {}
}

class Uid {
  String mid;
  String codeId;
  codeTypeSerBase codeType;
  String txtName;
  String txtDesig;
}