import 'dart:collection';

class Layers<Layer> extends ListBase<Layer> {
  List _innerList = new List();

  int get length => _innerList.length;
  void set length(int length) {
    _innerList.length = length;
  }

  @override
  Layer operator [](int index) => _innerList[index];

  @override
  void operator []=(int index, Layer value) {
    // TODO: implement []=
    _innerList[index] = value;
  }

  void add(Layer layer) => _innerList.add(layer);

  void addAll(Iterable<Layer> layers) => _innerList.addAll(layers);

}