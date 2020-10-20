import 'package:mapping_library/mapping_library.dart';
import 'package:mapping_library_extentions/extentions.dart';
import 'package:geometric_utils/geometric_utils.dart';

class MapWidget {
  MapWidget() {
    _mapView = _retrieveMapContainer();
  }

  Mapview _mapView;
  Mapview get mapView => _mapView;

  Mapview _retrieveMapContainer() {
    return Mapview(
      mapPosition: MapPosition.create(
        // This is a location in the middle of the netherlands
        geoPoint: new GeoPoint(52.45657243868931, 5.52041338863477),
        zoomLevel: 10,
      ),
      layers: Layers(
        layers: <Layer>[
          MultiTilesLayer(
            tileSources: <TileSource>[
              CachedHttpTileSource(
                  "https://snapshots.openflightmaps.org/live/2009/tiles/world/epsg3857/base/512/latest/##Z##/##X##/##Y##.jpg",
                  "OpenFlightMapsBase1"),
              CachedHttpTileSource(
                  "https://snapshots.openflightmaps.org/live/2009/tiles/world/epsg3857/aero/512/latest/##Z##/##X##/##Y##.png",
                  "OpenFlightMapsAero1"),
            ],
            name: "Multitile Layer",
          ),
        ],
      ),
    );
  }
}
