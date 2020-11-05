import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mvt_tiles/src/styles/layer_style.dart';
import '../mvt_tiles.dart';
import 'styles/style.dart';
import 'vector_tiles/utils/geometry_encoder.dart';
import 'vector_tiles/vector_tile.pb.dart';
import 'vector_tiles/vector_tile.pbserver.dart';

// void testTile(Tile tile) {
//   Tile_Layer layer = tile.layers[0];
//   Features features = GeometryEncoder.DecodeFeatures(layer.features[0]);

//   _printLayers(tile);
//   _printFeature(layer, features);
//   _printVectors(features);
// }

// Tile loadTile(Uint8List bytes) {
//   Tile tile = Tile.fromBuffer(bytes);
//   for (Tile_Layer layer in tile.layers) {
//     for (Tile_Feature feature in layer.features) {
//       feature.encodedFeature = GeometryEncoder.DecodeFeatures(feature);
//       feature.encodedFeature = GeometryEncoder.DecodeTags(layer, feature, feature.encodedFeature);
//     }
//   }
//   return tile;
// }

// Picture getTestTile(Tile tile, Styles styles) {
//   if (tile != null) {
 
//     PictureRecorder recorder = PictureRecorder();
//     Canvas c = Canvas(recorder);

//     TileStyle backgroundStyle = styles.firstWhere((element) {
//         return element.id == 'background';
//       });
//       _drawBackground(c, backgroundStyle);

    
//     LayerStyle layerStyle = LayerStyle(tile.layers);
//     for (TileStyle style in styles) {
//       List<Tile_Feature> features = layerStyle.getFeaturesByStyle(style);
//       if (style != null) {
//         if (features != null)
//           for (Tile_Feature tf in features) {
//             if (tf != null) {
//               _drawFeature(c, tf.encodedFeature, tile.layers[0].extent.roundToDouble(), style, backgroundStyle);
//             }
//           }
//       }
//     }
//     return recorder.endRecording();
//   } else 
//     return null;
// }

// void _printLayers(Tile tile) {
//   for (Tile_Layer l in tile.layers) {
//     print ("Layername: ${l.name}");
//   }
// }

// void _printFeature(Tile_Layer layer, Features feature) {
//   print(feature.tags);
//   print(feature.Type.toString());
// }

// void _printVectors(Features feature) {
//   for (Vector vector in feature) {
//     print ("Encoded Vector: ${vector.toString()}");
//   }
// }

// Canvas _drawFeature(Canvas canvas, Features feature, double extents, TileStyle style, TileStyle backgroundStyle) {
//   canvas.clipRect(Rect.fromLTWH(0, 0, tileSize, tileSize));
//   double tileSizeFactor = tileSize / extents;

//   //Color color = 

//   if (['line', 'fill'].contains(style.type)) {

//     // if ((style.paint.fillColor.color == null) && (feature.Type == Tile_GeomType.POLYGON)) 
//     //   print (style);
//     // if ((style.paint.lineColor.color == null) && (feature.Type == Tile_GeomType.LINESTRING)) 
//     //   print (style);
//     // if ((style.paint.lineColor.color == null) && (style.paint.fillColor.color == null)) 
//     //   print (style);

//     if (style.paint.fillPattern.pattern!='none')
//       return canvas;
   
  
//     Color color = (feature.Type == Tile_GeomType.POLYGON) ? style.paint.fillColor.color : style.paint.lineColor.color;
//     double opacity = ((feature.Type == Tile_GeomType.POLYGON) ? style.paint.fillOpacity.doubleValue : style.paint.lineOpacity.doubleValue);
//     color = Color.fromARGB((opacity*255).floor(), color.red, color.green, color.blue);
//     Paint paint = Paint()
//       ..color = color
//       ..style =  (feature.Type == Tile_GeomType.POLYGON) ? PaintingStyle.fill : PaintingStyle.stroke
//       ..strokeWidth = (style.paint.lineWidth.doubleValue) * 2;

//     Path p = Path();
//     for (Vector v in feature) {
//       if (v.command==1) p.moveTo(v.abs_x.roundToDouble() * tileSizeFactor, v.abs_y.roundToDouble() * tileSizeFactor);
//       if (v.command==2) p.lineTo(v.abs_x.roundToDouble() * tileSizeFactor, v.abs_y.roundToDouble() * tileSizeFactor);
//     }
//     if (feature.Type == Tile_GeomType.POLYGON) {
//       p.close();
//     }

//     canvas.drawPath(p, paint);
//   }

//   return canvas;
// }

// Canvas _drawBackground(Canvas canvas, TileStyle backgroundStyle) {
//   Paint paint = Paint()
//       ..color = backgroundStyle.paint.backgroundColor.color
//       ..style =  PaintingStyle.fill;
  
//   canvas.drawRect(Rect.fromLTWH(0, 0, tileSize, tileSize), paint);
//   return canvas;
// }