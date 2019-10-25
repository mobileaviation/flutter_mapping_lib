import 'dart:collection';

class FixedObjects<FixedObject> extends ListBase<FixedObject> {
  List _innerList = [];

  get length => _innerList.length;

  set length(int length) {
    _innerList.length = length;
  }

  @override
  FixedObject operator [](int index) => _innerList[index];

  @override
  void operator []=(int index, FixedObject value) {
    // TODO: implement []=
    _innerList[index] = value;
  }

  void add(FixedObject object) => _innerList.add(object);

  void addAll(Iterable<FixedObject> objects) => _innerList.addAll(objects);
}
