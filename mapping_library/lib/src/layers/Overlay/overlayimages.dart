import 'dart:collection';
import 'overlayimage.dart' as im;

class OverlayImages extends ListBase<im.OverlayImage> {
  List _innerList = [];

  int get length => _innerList.length;

  void set length(int length) {
    _innerList.length = length;
  }

  @override
  im.OverlayImage operator [](int index) => _innerList[index];

  @override
  void operator []=(int index, im.OverlayImage value) {
    _innerList[index] = value;
  }

  void add(im.OverlayImage overlayImage) {
    _innerList.add(overlayImage);
  }

  void addAll(Iterable<im.OverlayImage> overlayImages) {
    _innerList.addAll(overlayImages);
  }

  void insert(int index, im.OverlayImage overlayImage) {
    _innerList.insert(index, overlayImage);
  }

  im.OverlayImage removeAt(int index) {
    im.OverlayImage d = _innerList.removeAt(index);
    return d;
  }
}
