import 'package:flutter/material.dart';
import 'package:mvt_tiles/mvt_tiles.dart' as mvt;
import 'dart:ui';

class MapPainter extends CustomPainter {
  MapPainter({Key key, this.tile, this.styles});

  mvt.Tile tile;
  mvt.Styles styles;

  @override
  void paint(Canvas canvas, Size size) {
      Paint paint = Paint();
      paint.style = PaintingStyle.fill;
      paint.color = Colors.yellow;


      canvas.drawRect(Rect.fromLTWH(0,0,size.width,size.height), paint);
      print("Size: ${size.toString()}");

      paint.color = Colors.blue;
      //canvas.drawRect(Rect.fromLTWH(20,20,255, 255), paint);
      Picture p = mvt.getTestTile(tile, styles);
      if (p!=null) canvas.drawPicture(p);
    }
  
    @override
    bool shouldRepaint(CustomPainter oldDelegate) {
      
      return true;
  }
}