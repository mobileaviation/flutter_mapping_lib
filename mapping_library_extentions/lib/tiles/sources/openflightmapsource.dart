import 'cachedhttpsource.dart';
import '../../widgets/utils/airac.dart';

class OpenFlightMapsTileSource extends CachedHttpTileSource {
  OpenFlightMapsTileSource(String urlTemplate, String name) : super(urlTemplate, name) {
    String a = Airac.getCurrentAiracCycle();
    String url = urlTemplate.replaceAll("##AIRAC##", a);
    SetUrlTemplate(url);
  }
}