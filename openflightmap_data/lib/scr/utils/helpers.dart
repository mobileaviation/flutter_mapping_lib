import 'package:xml/xml.dart';
import 'package:geometric_utils/geometric_utils.dart';

String getValueFrom(XmlElement e, String elementName) {
  var el = e.children
      .where((node) => node is XmlElement && node.name.local == elementName);
  var el1 = (el!=null && el.length>0) ? el.first : null;
  var el2 = (el1!=null && el1.children.length>0) ? el1.firstChild.text : "";
  return el2;
}

double getGeo(String geoString) {
  double geo = double.tryParse(geoString.substring(0, geoString.length-1));
  if (geoString.endsWith("S")) geo = geo * -1;
  if (geoString.endsWith("W")) geo = geo * -1;
  return geo;
}

String enumValueToString(Object o) => o.toString().split('.').last;

T enumValueFromString<T>(String key, List<T> values) =>
    values.firstWhere((v) => key == enumValueToString(v), orElse: () => null);

GeoPoints getGeopointFrom(XmlElement e, String elementName) {
  var elements = e.findElements(elementName);
  if (elements.length==0) return null;
  String posList = getValueFrom(elements.first, "gmlPosList");
  GeoPoints p = GeoPoints();
  p.addFromString(posList);
  return p;
}