import 'package:mapping_library/core/mapview.dart';
import 'package:mapping_library/layers/tilelayer.dart';
import 'package:mapping_library_extentions/tiles/sources/mbtilessource.dart';

void SetupTestMBTilesSource(MapView mapView) {
  String path = '/sdcard/Download';
  String mbtileFileEDWL = path + '/' + 'VAC-EDWL-Langeoog.mbtiles';
  MBTilesSource mbTilesSource = MBTilesSource();
  mbTilesSource.OpenMbTilesFile(mbtileFileEDWL).then((value) {
    TileLayer tileLayer = TileLayer(mbTilesSource);
    mapView.AddLayer(tileLayer);
  });
}