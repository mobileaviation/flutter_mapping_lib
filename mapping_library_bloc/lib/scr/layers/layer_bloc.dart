import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapping_library_bloc/scr/core/mapposition.dart';
import 'package:mapping_library_bloc/scr/layers/layer.dart';
import 'package:mapping_library_bloc/scr/layers/layers.dart';
import 'package:mapping_library_bloc/scr/layers/layersresponse.dart';
import 'package:mapping_library_bloc/scr/layers/tilelayer.dart';

enum TileLayerEvents { startRetrieveTiles, tileRecieved }

class TileLayerEventsData {
  TileLayerEventsData(this.event, this.mapPosition);
  TileLayerEvents event;
  MapPosition mapPosition;
}

class LayerBloc extends Bloc<TileLayerEventsData, LayersResponse> {
  LayerBloc(LayersResponse initialState) : super(initialState) {
    this._layers = initialState.layers;
  }

  Layers _layers;

  @override
  Stream<LayersResponse> mapEventToState(TileLayerEventsData data) async* {
    switch(data.event) {
      case TileLayerEvents.startRetrieveTiles : {
        _retrieveTiles(data);
        yield LayersResponse(layers: this._layers);
        break;
      }
      case TileLayerEvents.tileRecieved : {
        yield LayersResponse(layers: this._layers);
        break;
      }
    }
  }

  void _retrieveTiles(TileLayerEventsData data) {
    for(Layer l in _layers) {
      if (l is TileLayer) {
        l.startRetrieveTiles(this, data);
      }
    }
  }

}