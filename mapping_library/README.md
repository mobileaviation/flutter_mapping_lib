# Basic Mapping engine for Flutter
This library supplies a basic implementation of a tiled mapping engine
for flutter. There is a basic openstreetmap widget available which can
be set on a specific geographic location. Basic gestures are implemented
to pan and zoom this map. More advanced options are available for adding
markers and vector based object like lines, polylines, circles and
polygons. Also a basic Marker implementation is available.

This library actually consists of two project, mapping_library and
mapping_library_extentions. For use on a IOS or Android device these
both needs to be added to the dependencies. The
mapping_library_extentions library adds extra IOS and Android specific
code. When using Flutter-web only add the mapping_library to the
dependencies (not tested yet!).

- Version: 0.0.6

***Disclaimer**: This version is far from finished. Most of the options
just supply very basic functionality which might still holds many bugs.
We are continuesly adding and improving options. Use at your own risk*

## Installation

    dependencies:
         mapping_library: any
         mapping_library_extentions: any

## Examples

**Checkout the [github repository](https://github.com/mobileaviation/flutter_mapping_lib) for a full example off all the options
and how to use them!!**!

**Basic Example** 

Create an instance of the OsmMap object in the contructor of your App
widget as the map needs to be in persistent memory. Add this instance to
the Build function.. **Do not add it directly to the build method!!**
```
        
    import 'package:mapping_library/mapping_library.dart';
        
    class MyApp extends StatelessWidget {
      MyApp() : super() {
        // It is important that the widget is pre-created in the constructor
        // of this parent widget as it needs to be persistant in memory
        // So do not add the directly to the build method. 
        _osmMap = _createOsmMapWidget();
      }
        
        OsmMap _osmMap;
        
        Widget _createOsmMapWidget() {
            return OsmMap(
                mapPosition: new MapPosition.Create(
                  geoPoint: new GeoPoint(52.45657243868931, 5.52041338863477),
                  zoomLevel: 11,
                )
            );
        }
        
        @override  
        Widget build(BuildContext context) {  
            return MaterialApp(  
                title: 'Flutter Demo',  
                theme: ThemeData(  
                    primarySwatch: Colors.blue,  
                ),  
                home: Container(   
                    child: _osmMap,
                )  
            );  
        }
    }
        
```

There are three callback methods:
  
- mapReady (Fired when the map initially is created, needed when you want to add more layers)
- mapPositionChanged (Fired as soon as the position or zoom of the map is changed)    
**Return**: Viewport object, this holds both the current MapPosition as the visual BoundingBox of the current map 
- mapTabbed (Fired when you tab on the map)    
**Return**: GeoPoint object, this holds the geographic location of the position tabbed.

**Advanced examples**

If you want to do more advanced stuff you need to create all the objects in the contructor of the Widget like this:

Define a MapView variable, Create this new object in the apps constructor and add the mapReady event handler.

```

class MyApp extends StatelessWidget {
  MyApp() : super() {
    _mapView = new mapview.MapView(_mapReady);
  }

  // Define a Mapview
  mapview.MapView _mapView;

  _mapReady(mapview.MapView mapView) {
  }
  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
        child: _mapView
      )
    );
  }
}

```

Continue by adding code to the mapReady callback function. First create
a base Layer. This normally should be a TileLayer. Define a http source
where the tiles are served from, Create a new HttpTileSource and finally
create a new TileLayer using this source.

```
_mapReady(mapview.MapView mapView) {
    final _url = "http://c.tile.openstreetmap.org/##Z##/##X##/##Y##.png";
    HttpTileSource osmTileSource = new HttpTileSource(_url); TileLayer
    tileLayer = new TileLayer(osmTileSource); _mapView.AddLayer(tileLayer);
    //
    //
    }
```

Create a new MapPosition to initially more and zoom the map to a chosen
default location. Create a new GeoPoint with the chosen geographic
location and use this with the desired zoomlevel to create a new
MapPosition. Set the mapview to this new MapPosition.

```
GeoPoint s = new GeoPoint(52.45657243868931, 5.52041338863477);
MapPosition _initialPosition = MapPosition.fromGeopointScale(s, 11);
_mapView.SetMapPosition(_initialPosition);
```