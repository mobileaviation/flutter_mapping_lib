import '../vector_tiles/utils/geometry_encoder.dart';
import 'style.dart';
import '../vector_tiles/vector_tile.pb.dart';

class LayerStyle {
  LayerStyle(this.layers);

  List<Tile_Layer> layers;

  List<Tile_Feature> getFeaturesByStyle(TileStyle style) {
    var l = _getLayerByName(style.sourceLayer);
    if (l.isNotEmpty) {
      return _getFeaturesByFilter(l.first, style);
      //return l.first.features;
    } else
    return null;
  }

  Iterable<Tile_Layer> _getLayerByName(String name) {
    return layers.where((element) {
      return (element.name == name);
    });
  }

  List<Tile_Feature> _getFeaturesByFilter(Tile_Layer layer, TileStyle style) {
    return layer.features.where((element) {
      if (style.type != _getStyleType(element.encodedFeature)) return false;
      bool ret = true;
      for (StyleFilter filter in style.filter) {
        String key = filter.key;
        String type = filter.type;

        if (type == '==') {
          if (element.encodedFeature.tags[key] != null) 
            ret  = ret && (element.encodedFeature.tags[key].stringValue == _getCheckValue(element.encodedFeature, key, filter));
        }

        if (type == 'in') {
          if (element.encodedFeature.tags[key] != null) 
            ret  = ret && ( filter.values.contains(element.encodedFeature.tags[key].stringValue));
        }

        if (type == '!in') {
          if (element.encodedFeature.tags[key] != null) 
            ret  = ret && ( !filter.values.contains(element.encodedFeature.tags[key].stringValue));
        }

        if (type == '!=') {
          if (element.encodedFeature.tags[key] != null) 
            ret = ret && (element.encodedFeature.tags[key].stringValue != _getCheckValue(element.encodedFeature, key, filter));
        }
      }
      return ret;
    
    }).toList();
  }

  String _getCheckValue(Features feature, String key, StyleFilter filter) {
    List<String> checkKeys = ["\$type"];
    if (checkKeys.contains(key)) {
      if (key=='\$type') return _getFeatureType(feature.Type);
    }
    else return filter.values[0];
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