import 'package:mapping_library/mapping_library.dart';
import 'package:mapping_library_extentions/extentions.dart';

void setupTestMBTilesSource(MapView mapView) {
  String path = '/sdcard/Download';
  String mbtileFileEDWL = path + '/' + 'VAC-EDWL-Langeoog.mbtiles';
  MBTilesSource mbTilesSource = MBTilesSource();
  mbTilesSource.openMbTilesFile(mbtileFileEDWL).then((value) {
    TilesLayer tileLayer = TilesLayer(mbTilesSource);
    mapView.addLayer(tileLayer);
  });
}