import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../mvt_tiles.dart';
import 'styles/style.dart';
import 'vector_tiles/utils/geometry_encoder.dart';
import 'vector_tiles/vector_tile.pb.dart';
import 'vector_tiles/vector_tile.pbserver.dart';
//import 'package:flutter/services.dart' show rootBundle;


final double tileSize = 255.0;

void testTile(Tile tile) {
  Tile_Layer layer = tile.layers[0];
  Features features = GeometryEncoder.DecodeFeatures(layer.features[0]);

  _printLayers(tile);
  _printFeature(layer, features);
  _printVectors(features);
}

// Future<Styles> loadStyles() async {
//   String value = await rootBundle.loadString('packages/mvt_tiles/styles/osm-bright-gl-style.json');
//   Styles s = Styles.fromJson(value);  
//   return s;
// }

Tile loadTile(Uint8List bytes) {
  return Tile.fromBuffer(bytes);
}

Picture getTestTile(Tile tile, Styles styles) {
  if (tile != null) {
 
    PictureRecorder recorder = PictureRecorder();
    Canvas c = Canvas(recorder);

    TileStyle backgroundStyle = styles.firstWhere((element) {
        return element.id == 'background';
      });
      _drawBackground(c, backgroundStyle);

    for (Tile_Layer layer in tile.layers) {
      print("LayerName: ${layer.name}");

      // for (String key in  layer.keys) {
      //   int i = layer.keys.indexOf(key);
      //   Tile_Value v = layer.values[i];
      //   print ("LayerVal: ${key} : ${v}");
      // }

      List<TileStyle> layerStyles = styles.getLayerStyleByName(layer.name);
      //List<TileStyle> layerStylesAllIntermittent = styles.getLayerStyleByNameFilterAll(layerStyles, layer.name, false, "fill");

      for (Tile_Feature f in layer.features) {
        Features features = GeometryEncoder.DecodeFeatures(f);
        features = GeometryEncoder.DecodeTags(layer, f, features);
        //print (features.tags);
        // print (features.Type.toString());
        //if ([Tile_GeomType.POLYGON, Tile_GeomType.LINESTRING].contains(features.Type) )

        String type = (features.Type == Tile_GeomType.LINESTRING) ? "line" : (features.Type == Tile_GeomType.POLYGON) ? "fill" : "background";
        var tileStyles = styles.getLayerStyleByNameFilterAll(layerStyles, layer.name, false, type);
        if (tileStyles.isNotEmpty)  
          _drawFeature(c, features, layer.extent.roundToDouble(), tileStyles.first, backgroundStyle);
      }

      //return recorder.endRecording();
    }

    return recorder.endRecording();
  } else 
    return null;
  
}

void _printLayers(Tile tile) {
  for (Tile_Layer l in tile.layers) {
    print ("Layername: ${l.name}");
  }
}

void _printFeature(Tile_Layer layer, Features features) {
  print(features.tags);
  print(features.Type.toString());
}

void _printVectors(Features features) {
  for (Vector vector in features) {
    print ("Encoded Vector: ${vector.toString()}");
  }
}

Canvas _drawFeature(Canvas canvas, Features features, double extents, TileStyle style, TileStyle backgroundStyle) {
  canvas.clipRect(Rect.fromLTWH(0, 0, tileSize, tileSize));
  double factor = tileSize / extents;

  //Color color = 
  
  Paint paint = Paint()
    ..color = (features.Type == Tile_GeomType.POLYGON) ? style.paint.fillColor.color : style.paint.lineColor.color
    ..style =  (features.Type == Tile_GeomType.POLYGON) ? PaintingStyle.fill : PaintingStyle.stroke
    ..strokeWidth = 1;

  Path p = Path();
  for (Vector v in features) {
    if (v.command==1) p.moveTo(v.abs_x.roundToDouble() * factor, v.abs_y.roundToDouble() * factor);
    if (v.command==2) p.lineTo(v.abs_x.roundToDouble() * factor, v.abs_y.roundToDouble() * factor);
  }
  if (features.Type == Tile_GeomType.POLYGON) {
    p.close();
  }

  canvas.drawPath(p, paint);

  return canvas;
}

Canvas _drawBackground(Canvas canvas, TileStyle backgroundStyle) {
  Paint paint = Paint()
      ..color = backgroundStyle.paint.backgroundColor.color
      ..style =  PaintingStyle.fill;
  
  canvas.drawRect(Rect.fromLTWH(0, 0, tileSize, tileSize), paint);
  return canvas;
}