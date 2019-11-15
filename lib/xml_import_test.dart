import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:openflightmap_data/openflightmap_data.dart';
import 'package:openflightmap_data/scr/services/import.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp() : super() {
    _testReadXMLFile();
  }

  void _testReadXMLFile() async {
    String xml = await rootBundle.loadString("assets/ofm/aixm_eh.xml");
    OFMImport import = OFMImport(xml);
    import.readAhp();
    log("Read XML File");
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar (
          title: Text("Test XML Import app!"),
        ),
        body: Center(
          child: Text("Test XML Import App"),
        ),
      ),
    );
  }
}