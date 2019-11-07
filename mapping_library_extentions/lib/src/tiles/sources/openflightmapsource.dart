import 'cachedhttpsource.dart';
import '../../widgets/utils/airac.dart';

class OpenFlightMapsTileSource extends CachedHttpTileSource {
  OpenFlightMapsTileSource(String urlTemplate, String name)
      : super(urlTemplate, name) {
    _createOfmTileSource(urlTemplate);
  }

  static OpenFlightMapsTileSource create() {
    return OpenFlightMapsTileSource("https://snapshots.openflightmaps.org/live/##AIRAC##/tiles/world/noninteractive/epsg3857/merged/256/latest/##Z##/##X##/##Y##.png",
      "OpenFlightMaps");
  }

  final _openFlightMapsUrl =
      "https://snapshots.openflightmaps.org/live/##AIRAC##/tiles/world/noninteractive/epsg3857/merged/256/latest/##Z##/##X##/##Y##.png";

//  OpenFlightMapsTileSource.create(String name) : super('', name) {
//    String url = _openFlightMapsUrl;
//    _createOfmTileSource(url);
//  }

  _createOfmTileSource(String urlTemplate) {
    String a = Airac.getCurrentAiracCycle();
    String url = urlTemplate.replaceAll("##AIRAC##", a);
    setUrlTemplate(url);
  }
}
