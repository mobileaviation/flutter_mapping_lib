import 'package:mapping_library/Widgets/utils/airac.dart';
import 'httptilesource.dart';

class OpenFlightMapsTileSource extends HttpTileSource {
  OpenFlightMapsTileSource(String urlTemplate) : super(urlTemplate) {
    String a = Airac.getCurrentAiracCycle();
    String url = urlTemplate.replaceAll("##AIRAC##", a);
    SetUrlTemplate(url);
  }

}