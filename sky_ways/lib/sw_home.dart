import 'package:flutter/material.dart';
import 'sw_data.dart';
import 'sw_map.dart';

class SkywaysHomePage extends StatefulWidget {
  SkywaysHomePage({Key key}): super(key: key);

  @override
  _SkywaysHomePageState createState() => _SkywaysHomePageState();
}

class _SkywaysHomePageState extends State<SkywaysHomePage> {
  @override
  Widget build(BuildContext context) {
    MapWidget mapWidget = SkywaysProvider.of(context).mapview;
    return Container(
      child: mapWidget.mapView
    );
  }
}