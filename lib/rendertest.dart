import 'package:flutter/material.dart';
import 'dart:ui';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp() : super() {}

  Scene test(){

    SceneBuilder sceneBuilder = SceneBuilder();
    PictureRecorder rec = PictureRecorder();
    Canvas drawerCanvas = Canvas(rec);

    Paint p = new Paint();
    p.isAntiAlias = true;
    p.color = Colors.green;
    p.style = PaintingStyle.fill;
    drawerCanvas.drawCircle(Offset(50,50), 50, p);

    sceneBuilder.addPicture(Offset(0,0),
        rec.endRecording());




    return sceneBuilder.build();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar (
          title: Text("Test Render app!"),
        ),
        body: Center(
          child: Text("Test Render App"),
        ),
      ),
    );
  }


}