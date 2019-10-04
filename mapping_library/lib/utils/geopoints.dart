import 'dart:collection';
import 'boundingbox.dart' as b;
import 'geopoint.dart' as p;
import 'dart:math' as math;

class GeoPoints<GeoPoint> extends ListBase<p.GeoPoint> {
  List _innerList = new List();
  double _minLat = 1000,
      _maxLat = 1000,
      _minLon = 1000,
      _maxLon = 1000;
  b.BoundingBox _boundingBox;
  get BoundingBox { return _boundingBox; }

  _setupMinMax(p.GeoPoint point) {
    double lat = point.getLatitude();
    double lon = point.getLongitude();
    _minLat = (_minLat==1000)? lat: math.min(_minLat, lat);
    _maxLat = (_maxLat==1000)? lat: math.max(_maxLon, lat);
    _minLon = (_minLon==1000)? lon: math.min(_minLon, lon);
    _maxLon = (_maxLon==1000)? lon: math.max(_maxLon, lon);
  }

  _setupBoundaryBox() {
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

  void add(p.GeoPoint geoPoint) => _innerList.add(geoPoint);

  void addAll(Iterable<p.GeoPoint> geoPoints) => _innerList.addAll(geoPoints);

  void addFromString(String geoPoints) {
    var points = geoPoints.split(" ");
    for (String point in points) {
      var latlon = point.split(",");
      if (latlon.length==2) {
        p.GeoPoint geoPoint = new p.GeoPoint(
          double.parse(latlon[1]), double.parse(latlon[0]));
        _setupMinMax(geoPoint);
        add(geoPoint);
      }
    }
    _setupBoundaryBox();
  }

}