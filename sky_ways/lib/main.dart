import 'package:flutter/material.dart';
import 'sw_home.dart';
import 'sw_data.dart';
import 'sw_map.dart';

void main() {
  runApp(SkyWaysApp());
}

class SkyWaysApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MapWidget mapWidget = MapWidget(); 
    return MaterialApp(
      title: 'Sky Ways',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SkywaysProvider(
          child: SkywaysHomePage(),
          mapview: mapWidget,
        ),
  
    );
  }
}
