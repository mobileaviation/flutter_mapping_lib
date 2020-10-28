import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart' show rootBundle;


Future<Styles> loadStyles(String styleName) async {
  String value = await rootBundle.loadString('packages/mvt_tiles/styles/' + styleName + '.json');
  Styles s = Styles.fromJson(value);  
  return s;
}


class Styles extends ListBase<TileStyle> {
  Styles.fromJson(String json) {
    Map<String, dynamic> style = jsonDecode(json);
    var layers = style['layers'];
    for (var layer in layers) {
      TileStyle style = TileStyle.fromJson(layer);
      add(style);
    }
  }

  List<TileStyle> _innerList = List();

  @override
  TileStyle operator [](int index) => _innerList[index];

  @override
  void operator []=(int index, TileStyle value) {
    _innerList[index] = value;
  }

  void add(TileStyle style) {
    _innerList.add(style);
  }


  int get length => _innerList.length;
  set length(int length) {
    _innerList.length = length;
  }
  
  List<TileStyle> getLayerStyleByName(String layerName) {
    return this.where((element) {
      return element.sourceLayer == layerName;
    }).toList();
  }
  
  List<TileStyle> getLayerStyleByNameFilterAll(List<TileStyle> source, String layerName, bool intermittent, String type) {
    String intermittentType = (intermittent) ? "==" : "!=";
    var name = source.where((element) {
        return (element.sourceLayer == layerName) && (element.type == type);
      });

    var all = name.where((element) {
      return ((element.filter.indexWhere((element) => (element.type=='all')))>-1);
        // && ((element.filter.indexWhere((element) => ((element.type==intermittentType) 
        // && (element.key=='intermittent') 
        // && (element.values.contains("1")))))>-1);
    });

    return all.toList();
  }

}

class TileStyle {
  TileStyle.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    type = json['type'],
    source = json['source'],
    sourceLayer = json['source-layer'] {
      var f = json['filter'];
      if (f != null)
        filter = StyleFilters(f);

      layout = StyleLayout('none');

      var l = json['layout'];
      layout.visibility = (l!=null) ? (l['visibility']!=null) ? 
        l['visibility'] : 'none' : 'none';

      paint = StylePaint.fromList(json['paint']);
    }
    

  String id;
  String type;
  String source;
  String sourceLayer;
  StyleFilters filter;
  StyleLayout layout;
  StylePaint paint;
}

class StyleFilters extends ListBase<StyleFilter>{
  StyleFilters(List<dynamic> filters) {
    StyleFilter filter = StyleFilter.fromList(filters);
    add(filter);
    for (var f in filters) {
      if (f is List) {
        StyleFilter filter = StyleFilter.fromList(f);
        add(filter);
      }
    }
  }

  List _innerList = List();

  @override
  StyleFilter operator [](int index) => _innerList[index];

  @override
  void operator []=(int index, StyleFilter value) {
    _innerList[index] = value;
  }

  void add(StyleFilter style) {
    _innerList.add(style);
  }

  int get length => _innerList.length;
  set length(int length) {
    _innerList.length = length;
  }
}

    //   "filter": ["all", ["!=", "intermittent", 1], ["!=", "brunnel", "tunnel"]],
      //     "filter": [
      //   "all",
      //   ["==", "$type", "Polygon"],
      //   ["in", "class", "industrial", "garages", "dam"]
      // ],

class StyleFilter {
  StyleFilter.fromList(List<dynamic> filter) {
    type = filter[0];
    if (filter.length>1) {
        if (!(filter[1] is List)) {
        key = filter[1];
        values = List();
        for(int i=2; i<filter.length; i++) {
          values.add(filter[i].toString());
        }
      }
    }
  }

  StyleFilter.fromString(String item) {
    type = item;
  }

  String type;
  String key;
  List<String> values;
}

class StyleLayout {
  StyleLayout(this.visibility);

  String visibility;
}

class StylePaint {
  StylePaint.fromList(Map<String, dynamic> paint) {
    if (paint != null) {
      //fillColor = ColorValue.fromString((paint['fill-color'] != null) ? paint['fill-color'].toString() : 'none');
      fillColor = ColorValue.fromJson(paint, 'fill-color');
      fillOpacity = (paint['fill-opacity'] != null) ? double.tryParse(paint['fill-opacity'].toString()) : 1.0;
      lineColor = ColorValue.fromString((paint['line-color'] != null) ? paint['line-color'].toString() : 'none');
      lineOpacity = (paint['line-opacity'] != null) ? double.tryParse(paint['line-opacity'].toString()) : 1.0;
      fillOutlineColor = ColorValue.fromString((paint['fill-outline-color'] != null) ? paint['fill-outline-color'].toString() : 'none');
      lineWidth = PaintValue.fromJson(paint, 'line-width');
      backgroundColor = ColorValue.fromString((paint['background-color'] != null) ? paint['background-color'].toString() : 'none');
    }
  }

  ColorValue fillColor;
  double fillOpacity; 
  ColorValue lineColor;
  double lineOpacity;
  ColorValue fillOutlineColor;
  List<double> lineDasharray;
  PaintValue lineWidth;
  ColorValue backgroundColor;

}

class PaintValue {
  PaintValue.fromJson(dynamic json, String field) {
    if (json[field] != null)
      if (json[field] is Map) {
        stops = List();
        base = (json[field]['base'] != null) ? double.tryParse(json[field]['base'].toString()) : 1.0;
        for(var i in json[field]['stops']) {
          Stop stop = Stop();
          stop.zoom = double.tryParse(i[0].toString());
          stop.value = i[1];
          stops.add(stop);
        }
      } else {
        value = json[field];
      }
  }

  double base;
  List<Stop> stops;
  dynamic value;
}

class Stop {
  double zoom;
  dynamic value;    
}

class ColorValue {
  ColorValue.fromString(String color) {
    _parseColor(color);
  }

  ColorValue.fromJson(dynamic json, String field) {
    colorValue = PaintValue.fromJson(json, field);
    if (colorValue.stops != null) {
      _parseColor(colorValue.stops[0].value.toString());
    }
    else {
      _parseColor(colorValue.value.toString());
    }
  }
  
  void _parseColor(String color) {
    if (color.startsWith("#")) {
      this._color = _parseHexColor(color, 1);
    }
    if (color.startsWith("rgba")) {
      this._color = _parseRGBA(color);
      return;
    }
    if (color.startsWith("rgb")) {
      this._color = _parseRGB(color);
      return;
    }
    if (color.startsWith("hsla")) {
      this._color = _parseHSLA(color);
      return;
    }
    if (color.startsWith("hsl")) {
      this._color = _parseHSL(color);
      return;
    }
  }

  Color _parseHSL(String color) {
    color = color.replaceAll("hsl(", "").replaceAll(")", "");
    var values = color.split(",");
    double hue = double.tryParse(values[0]);
    double saturation = double.tryParse(values[1].replaceAll("%", "")) / 100;
    double lightness = double.tryParse(values[2].replaceAll("%", "")) / 100;

    return HSLColor.fromAHSL( 1.0 , hue, saturation, lightness).toColor();
  }

  Color _parseHSLA(String color) {
    color = color.replaceAll("hsla(", "").replaceAll(")", "");
    var values = color.split(",");
    double hue = double.tryParse(values[0]);
    double saturation = double.tryParse(values[1].replaceAll("%", "")) / 100;
    double lightness = double.tryParse(values[2].replaceAll("%", "")) / 100;
    double opacity = double.tryParse(values[3]);

    return HSLColor.fromAHSL( opacity , hue, saturation, lightness).toColor();
  }

  Color _parseRGB(String color) {
    color = color.replaceAll("rgb(", "").replaceAll(")", "");
    var values = color.split(",");
    int r = int.tryParse(values[0]);
    int g = int.tryParse(values[1]);
    int b = int.tryParse(values[2]);
    return Color.fromRGBO(r, g, b, 1.0);
  }

  Color _parseRGBA(String color) {
    color = color.replaceAll("rgba(", "").replaceAll(")", "");
    var values = color.split(",");
    int r = int.tryParse(values[0]);
    int g = int.tryParse(values[1]);
    int b = int.tryParse(values[2]);
    double a = double.tryParse(values[3]);
    return Color.fromRGBO(r, g, b, a);
  }

  Color _parseHexColor(String color, double opacity) {
    color = color.replaceAll("#", "");
    if (color.length == 3) {
      String c = '';
      color.split('').forEach((e) =>
        c = c + e + e );
      color = c;
    }

    if (color.length == 6) {
      color = "FF" + color;
    }

    return Color(int.parse("0x$color"));
  }

  
  Color _color;
  Color get color { return _color; }
  PaintValue colorValue;

}
