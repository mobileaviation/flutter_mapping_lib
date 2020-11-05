import 'package:flutter/material.dart';
import 'package:mvt_tiles/mvt_tiles.dart' as mvt;
import 'dart:ui';

class MapPainter extends CustomPainter {
  MapPainter({Key key, this.tile, this.styles});

  mvt.VectorTile tile;
  mvt.Styles styles;

  @override
  void paint(Canvas canvas, Size size) {
      Paint paint = Paint();
      paint.style = PaintingStyle.fill;
      paint.color = Colors.yellow;


      canvas.drawRect(Rect.fromLTWH(0,0,size.width,size.height), paint);
      print("Size: ${size.toString()}");

      if (tile != null)
        tile.paint(canvas, Rect.fromLTWH(10, 10, mvt.tileSize, mvt.tileSize));
    }
  
    @override
    bool shouldRepaint(CustomPainter oldDelegate) {
      
      return true;
  }
}