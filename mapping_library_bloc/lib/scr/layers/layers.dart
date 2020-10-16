import "package:collection/collection.dart";
import 'package:mapping_library_bloc/scr/layers/layer.dart';

class Layers extends DelegatingList<Layer> {
  final List<Layer> _layers;

  Layers() : this._(<Layer>[]);
  Layers._(l) :
    _layers = l,
    super(l);
}

// extension Layers<Layer> on List<Layer> {

// }