import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import '../../core/viewport.dart';
import '../../utils/boundingbox.dart';
import '../../utils/mapposition.dart';

class OverlayImage {
  OverlayImage(File file) {
    _overlayImageFile = file;
  }

  BoundingBox _imageBox;
  void setImageBox(double northLat, southLat, westLon, eastLon) {
    _imageBox = BoundingBox.fromDeg(southLat, westLon, northLat, eastLon);
  }

  void setUpdateListener(Function listener) {
    _imageUpdated = listener;
  }

  Function(OverlayImage image) _imageUpdated;

  void fireUpdatedMarker() {
    if (_imageUpdated != null) {
      _imageUpdated(this);
    }
  }

  void paint(Canvas canvas) {

  }

  File _overlayImageFile;
  Image _overlayImage;

  Future<Image> getImage() async {
    if (_overlayImage != null) return await _overlayImage;

    var bytes = await _overlayImageFile.readAsBytes();
    var codec = await instantiateImageCodec(bytes);
    var f = await codec.getNextFrame();
    _overlayImage = f.image;

    return await _overlayImage;
  }

  BoundingBox getBoundingBox() { return _imageBox; }

  void CalculatePixelPosition(Viewport viewport, MapPosition mapPosition) {

  }

  bool WithinViewport(Viewport viewport) {
    return _imageBox.intersects(viewport.GetBoundingBox());
  }
}