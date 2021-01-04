import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import '../styles/layer_style.dart';
import '../styles/style.dart';
import 'utils/geometry_encoder.dart';
import 'vector_tile.pb.dart';

final double tileSize = 512.0;

class VectorTile {
  VectorTile(Uint8List bytes, int x, y,  double zoom) {
    _tile = Tile.fromBuffer(bytes);
    _x = x;
    _y = y;
    _zoom = zoom;
    for (Tile_Layer layer in _tile.layers) {
      for (Tile_Feature feature in layer.features) {
        feature.encodedFeature = GeometryEncoder.DecodeFeatures(feature);
        feature.encodedFeature = GeometryEncoder.DecodeTags(layer, feature, feature.encodedFeature);
      }
    }
  }


  int _x;
  int _y;
  double _zoom;

  Tile _tile;
  Picture _tilePicture;
  Image _tileImage;

  Future renderTile(Styles styles) async {
    if (_tile != null) {
      PictureRecorder recorder = PictureRecorder();
      Canvas c = Canvas(recorder);
      _renderBackground(c, styles);
      _renderForeground(c, styles);
      _tilePicture = recorder.endRecording();
      _tileImage = await _tilePicture.toImage(tileSize.floor(), tileSize.floor());
    }
  }

  void paint(Canvas canvas, Rect drawRect) {
    if (_tileImage != null) {
      canvas.drawImageRect(_tileImage, 
        Rect.fromLTWH(0,0, tileSize, tileSize), 
        drawRect, new Paint());
    }
  }

  void _renderBackground(Canvas c, Styles styles) {
    TileStyle backgroundStyle = styles.firstWhere((element) {
        return element.id == 'background';
      });
    _drawBackground(c, backgroundStyle);
  }

  void _renderForeground(Canvas c, Styles styles) {
    LayerStyle layerStyle = LayerStyle(_tile.layers);
    for (TileStyle style in styles) {
      _renderLayer(layerStyle, style, c);
    }
  }

  bool _renderLayer(LayerStyle layerStyle, TileStyle style, Canvas canvas) {
    bool rendered = false;
    if (style.layout.visibility=='visible') {
      List<Tile_Feature> features = layerStyle.getFeaturesByStyle(style, _x, _y, _zoom);
      int features_length = (features == null) ? -1 : features.length;
      //log(DateTime.now().toString() + " : found ${features_length} features for layer ${style.id}");
      if (style != null) {
        if ((features != null) && (features.length>0)){
          log(DateTime.now().toString() + " : start drawing ${features_length} for layer ${style.id}");
          for (Tile_Feature tf in features) {
            if (tf != null) {
              _drawFeature(canvas, tf.encodedFeature, _tile.layers[0].extent.roundToDouble(), style);
              rendered = true;
            }
          }
        }
      }
    }
    return rendered;
  }

  void _drawFeature(Canvas canvas, Features feature, double extents, TileStyle style) {
    canvas.clipRect(Rect.fromLTWH(0, 0, tileSize, tileSize));
    double tileSizeFactor = tileSize / extents;

    if (['line', 'fill'].contains(style.type)) {

      // Temporary filter, remove when fillPattern is implemented
      if (style.paint.fillPattern.pattern!='none')
        return;
    
      Color color = (feature.Type == Tile_GeomType.POLYGON) ? style.paint.fillColor.color : style.paint.lineColor.color;
      double opacity = ((feature.Type == Tile_GeomType.POLYGON) ? style.paint.fillOpacity.doubleValue(_zoom) : style.paint.lineOpacity.doubleValue(_zoom));
      color = Color.fromARGB((opacity*255).floor(), color.red, color.green, color.blue);
      Paint paint = Paint()
        ..color = color
        ..style =  (feature.Type == Tile_GeomType.POLYGON) ? PaintingStyle.fill : PaintingStyle.stroke
        ..strokeWidth = (style.paint.lineWidth.doubleValue(_zoom));

      Path p = Path();
      for (Vector v in feature) {
        if (v.command==1) p.moveTo(v.abs_x.roundToDouble() * tileSizeFactor, v.abs_y.roundToDouble() * tileSizeFactor);
        if (v.command==2) p.lineTo(v.abs_x.roundToDouble() * tileSizeFactor, v.abs_y.roundToDouble() * tileSizeFactor);
      }
      if (feature.Type == Tile_GeomType.POLYGON) {
        p.close();
      }

      canvas.drawPath(p, paint);
    }
  }

  void _drawBackground(Canvas canvas, TileStyle backgroundStyle) {
    Paint paint = Paint()
        ..color = backgroundStyle.paint.backgroundColor.color
        ..style =  PaintingStyle.fill;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, tileSize, tileSize), paint);
  }

}