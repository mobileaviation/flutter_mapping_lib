import 'dart:collection';

class Vectors<GeomBase> extends ListBase<GeomBase> {
  List _innerList = new List();

  int get length => _innerList.length;
  void set length(int length) {
    _innerList.length = length;
  }

  @override
  GeomBase operator [](int index) => _innerList[index];

  @override
  void operator []=(int index, GeomBase value) {
    // TODO: implement []=
    _innerList[index] = value;
  }

  void add(GeomBase vector) => _innerList.add(vector);

  void addAll(Iterable<GeomBase> vectors) => _innerList.addAll(vectors);

}