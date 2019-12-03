import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:openflightmap_data/openflightmap_data.dart';
import 'package:openflightmap_data/scr/services/import.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProv;
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp() : super() {
    //_testReadXMLFile();
  }

  void _testReadXMLFile() async {
    String filename = "assets/ofm/aixm_eh.xml";
    String xml = await rootBundle.loadString(filename);
    String aseFileName = "assets/ofm/aixm_eh_ofmShapeExtension.xml";
    String aseXml = await rootBundle.loadString(aseFileName);

    OFMImport import = OFMImport(xml, aseXml);
    import.readAixm(filename, aseFileName);
    log("Read XML File");
  }

  _startImport() async {
    log("Import Button clicked!");
    String filepath;
    filepath = await FilePicker.getFilePath(type: FileType.CUSTOM, fileExtension: "zip");
    Directory unzipPath = await pathProv.getApplicationDocumentsDirectory();
    log("Open file: ${filepath}.");
    List<int> bytes = await File(filepath).readAsBytes();
    log("File: bytes read.");
    Archive archive = ZipDecoder().decodeBytes(bytes);
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    for (ArchiveFile file in archive) {
      String filename = file.name;
      if (filename.contains("isolated") && path.extension(filename)==".xml") {
        log("Zipfile: Filename:${filename}");
        String outFilename = "${unzipPath.path}/${path.basename(filename).toString()}";
        log("OutFileName: ${outFilename}");
        List<int> data = file.content;
        await File(outFilename)
          ..create(recursive: false)
          ..writeAsBytes(data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar (
          title: Text("Test XML Import app!"),
        ),
        body: Center(
          child: MaterialButton(
            child: Text("Import OFM Aixm Zipfile"),
            color: Colors.greenAccent,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            onPressed: _startImport,
          ),
        ),
      ),
    );
  }
}