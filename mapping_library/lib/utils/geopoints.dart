import 'dart:collection';
import 'boundingbox.dart' as b;
import 'geopoint.dart' as p;
import 'dart:math' as math;

class GeoPoints extends ListBase<p.GeoPoint> {
  List _innerList = new List();
  double _minLat = 1000,
      _maxLat = 1000,
      _minLon = 1000,
      _maxLon = 1000;
  b.BoundingBox _boundingBox;

  get BoundingBox {

    return _boundingBox; }

  get MathPointsE6 {
    List<math.Point> pp  = new List();
    for (p.GeoPoint po in _innerList) {
      pp.add(new math.Point(po.longitudeE6 , po.latitudeE6));
    }
    return pp;
  }

  bool _closed = false;
  get Closed { return _closed; }

  _setupMinMax(p.GeoPoint point) {
    double lat = point.getLatitude();
    double lon = point.getLongitude();
    _minLat = (_minLat==1000)? lat: math.min(_minLat, lat);
    _maxLat = (_maxLat==1000)? lat: math.max(_maxLon, lat);
    _minLon = (_minLon==1000)? lon: math.min(_minLon, lon);
    _maxLon = (_maxLon==1000)? lon: math.max(_maxLon, lon);
  }

  _setupBoundaryBox() {
    for (p.GeoPoint pi in _innerList) _setupMinMax(pi);
    _boundingBox = new b.BoundingBox.fromDeg(_minLat, _minLon, _maxLat, _maxLon);
  }

  int get length => _innerList.length;
  void set length(int length) {
    _innerList.length = length;
  }

  @override
  p.GeoPoint operator [](int index) => _innerList[index];

  @override
  void operator []=(int index, p.GeoPoint value) {
    // TODO: implement []=
    _innerList[index] = value;
  }

  void add(p.GeoPoint geoPoint) {
    _innerList.add(geoPoint);
    _setupBoundaryBox();
  }

  void addAll(Iterable<p.GeoPoint> geoPoints) {
    _innerList.addAll(geoPoints);
    _setupBoundaryBox();
  }

  void insert(int index, p.GeoPoint geoPoint) {
    _innerList.insert(index, geoPoint);
    _setupBoundaryBox();
  }

  p.GeoPoint removeAt(int index) {
    p.GeoPoint d =_innerList.removeAt(index);
    _setupBoundaryBox();
    return d;
  }

  void addFromString(String geoPoints, [bool closed = false]) {
    var points = geoPoints.split(" ");
    for (String point in points) {
      var latlon = point.split(",");
      if (latlon.length>=2) {
        p.GeoPoint geoPoint = new p.GeoPoint(
            double.parse(latlon[1]), double.parse(latlon[0]));
        add(geoPoint);
      }
    }
    if (closed) add(this[0]);
    _closed = closed;
    _setupBoundaryBox();
  }


}