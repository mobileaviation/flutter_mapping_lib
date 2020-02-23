import 'dart:collection';

class Markers<MarkerBase> extends ListBase<MarkerBase> {
  List _innerList = [];

  get length => _innerList.length;

  set length(int length) {
    _innerList.length = length;
  }

  @override
  MarkerBase operator [](int index) => _innerList[index];

  @override
  void operator []=(int index, MarkerBase value) {
    _innerList[index] = value;
  }

  void add(MarkerBase marker) => _innerList.add(marker);

  void addAll(Iterable<MarkerBase> markers) => _innerList.addAll(markers);
}
