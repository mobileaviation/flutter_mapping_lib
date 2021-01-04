import '../vector_tiles/utils/geometry_encoder.dart';
import 'style.dart';
import '../vector_tiles/vector_tile.pb.dart';

class LayerStyle {
  LayerStyle(this.layers);

  List<Tile_Layer> layers;

  List<Tile_Feature> getFeaturesByStyle(TileStyle style, int x, y, double zoom) {
    var l = _getLayerByName(style.sourceLayer);
    if (l.isNotEmpty) {
      return _getFeaturesByFilter(l.first, style, x, y, zoom);
    } else
    return null;
  }

  Iterable<Tile_Layer> _getLayerByName(String name) {
    return layers.where((element) {
      return (element.name == name);
    });
  }

  List<Tile_Feature> _getFeaturesByFilter(Tile_Layer layer, TileStyle style, int x,y, double zoom) {
    return layer.features.where((element) {
      if (style.type != _getStyleType(element.encodedFeature)) return false;
      if ((style.minzoom==null) ? false : (style.minzoom>=zoom)) return false;
      bool ret = true;
      bool all = false;
      bool any = false;
      bool check = false;

      //print (element.encodedFeature.tags);
      if (style.filter == null) return false;
      for (StyleFilter filter in style.filter) {
        String key = filter.key;
        String type = filter.type;
        if (type=='all') { all = true; any = false; }
        if (type=='any') { all = false; any = true; }


        if (type == '==') {
          check = true;
          ret  = ret && _getCheckValue(element.encodedFeature, key, type, filter);
        }

        if (type == 'in') {
          check = true;
          if (element.encodedFeature.tags[key] != null) 
            ret  = ret && ( filter.values.contains(element.encodedFeature.tags[key].stringValue));
        }

        if (type == '!in') {
          check = true;
          if (element.encodedFeature.tags[key] != null) 
            ret  = ret && ( !filter.values.contains(element.encodedFeature.tags[key].stringValue));
          else ret = ret && true;
        }

        if (type == '!=') {
          check = true;
          ret = ret && _getCheckValue(element.encodedFeature, key, type, filter);
        }
      }
      return ret && check;
    
    }).toList();
  }



  bool _getCheckValue(Features feature, String key, String type, StyleFilter filter) {
    List<String> checkKeys = ["\$type"];
    if (checkKeys.contains(key)) {
      if (key=='\$type') return (_getFeatureType(feature) == filter.values[0]);
    }
    else {
      return (feature.tags[key]==null) ? ['!='].contains(type) : (filter.values[0] == feature.tags[key].stringValue);
    }
  }

  String _getFeatureType(Features feature) {
    switch (feature.Type) {
      case Tile_GeomType.LINESTRING : return "LineString";
      case Tile_GeomType.POLYGON : return "Polygon";
      case Tile_GeomType.POINT : return "Point";
      case Tile_GeomType.UNKNOWN : return "Unknown";
    }
  }

  String _getStyleType(Features feature) {
    switch (feature.Type) {
      case Tile_GeomType.LINESTRING : return "line";
      case Tile_GeomType.POLYGON : return "fill";
      case Tile_GeomType.POINT : return "symbol";
      case Tile_GeomType.UNKNOWN : return "Unknown";
    }
  }
}