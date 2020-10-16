import 'dart:async';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapping_library_bloc/scr/core/mapposition.dart';
import 'package:mapping_library_bloc/scr/core/observer.dart';
import 'package:mapping_library_bloc/scr/layers/layers.dart';
import 'package:mapping_library_bloc/scr/layers/layer_bloc.dart';
import 'package:mapping_library_bloc/scr/layers/layersresponse.dart';
import 'package:mapping_library_bloc/scr/layers/painters/layerspainter.dart';


class MapView extends StatelessWidget {
  MapView({Key key, this.layers, this.centerLocation}) {
    log("MapView created");
    Bloc.observer = MapViewObserver();
  }

  final Layers layers;
  final MapPosition centerLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) => LayerBloc(LayersResponse(layers: this.layers)),
        child: MapViewBloc(
          layers: layers,
          mapPosition: centerLocation,
        ),
      ),
    );
  }
}

class MapViewBloc extends StatelessWidget {
  MapViewBloc({Key key, this.layers, this.mapPosition}) {
    Timer(Duration(milliseconds: 200), () {
      print("Timer triggered");
      if (_layerBloc != null) { 
          print ("Layerbloc available"); 
          _layerBloc.add(TileLayerEventsData(TileLayerEvents.startRetrieveTiles, mapPosition));
        }
    });
  }

  final Layers layers;
  final MapPosition mapPosition;
  LayerBloc _layerBloc;

  @override
  Widget build(BuildContext context) {
    _layerBloc = context.bloc<LayerBloc>();
    return Container(
      child: GestureDetector(
        child: BlocBuilder<LayerBloc, LayersResponse>(builder: (context, value) {
          return CustomPaint(
            painter: LayersPainter(layers: value.layers),
            child: Container(),
          );
        }),
        behavior: HitTestBehavior.translucent,
        // onTapUp: (details) {
        //   TileLayerEventsData responseData = TileLayerEventsData(TileLayerEvents.startRetrieveTiles, 10, null);
        //   _layerBloc.add(responseData);
        // }
      ),
    );
  }


}
