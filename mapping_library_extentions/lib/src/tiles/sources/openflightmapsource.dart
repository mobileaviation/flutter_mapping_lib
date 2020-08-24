import 'cachedhttpsource.dart';
import '../../widgets/utils/airac.dart';

class OpenFlightMapsTileSource extends CachedHttpTileSource {
  OpenFlightMapsTileSource(String urlTemplate, String name)
      : super(urlTemplate, name) {
    _createOfmTileSource(urlTemplate);
  }

  static OpenFlightMapsTileSource create() {
    return OpenFlightMapsTileSource("https://snapshots.openflightmaps.org/live/##AIRAC##/tiles/world/epsg3857/base/512/latest/##Z##/##X##/##Y##.jpg",
      "OpenFlightMaps1");
  }

  final _openFlightMapsUrl =
      "https://snapshots.openflightmaps.org/live/##AIRAC##/tiles/world/epsg3857/base/512/latest/##Z##/##X##/##Y##.jpg";

  _createOfmTileSource(String urlTemplate) {
    String a = Airac.getCurrentAiracCycle();
    String url = urlTemplate.replaceAll("##AIRAC##", a);
    //https://snapshots.openflightmaps.org/live/2009/tiles/world/epsg3857/base/256/latest/10/532/337.jpg
    setUrlTemplate(url);
  }
}
