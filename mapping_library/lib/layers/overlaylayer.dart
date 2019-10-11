import 'Overlay/overlayimage.dart';
import 'Overlay/overlayimages.dart';

import 'layer.dart';
import 'dart:ui';
import '../utils/geopoint.dart';
import '../core/viewport.dart';
import '../utils/mapposition.dart';

class OverlayLayer extends Layer {
  OverlayLayer() {
    _overlayImages = new OverlayImages();
  }

  OverlayImages _overlayImages;

  void AddImage(OverlayImage overlayImage) {
    _overlayImages.add(overlayImage);
    overlayImage.setUpdateListener(_imageUpdated);
    fireUpdatedLayer();
  }

  void _imageUpdated(OverlayImage image) {
    _setupOverlayForViewport();
  }

  void paint(Canvas canvas, Size size) {
    for (OverlayImage image in _overlayImages) {
      if (image.WithinViewport(_viewport)) {
        image.paint(canvas);
      }
    }
  }

  @override
  void notifyLayer(MapPosition mapPosition, Viewport viewport) {
    _mapPosition = mapPosition;
    _viewport = viewport;
    _setupOverlayForViewport();
  }

  @override
  void doTabCheck(GeoPoint clickedPosition, Offset screenPos) {

  }

  void _setupOverlayForViewport() {
    for (OverlayImage image in _overlayImages) {
      image.CalculatePixelPosition(_viewport, _mapPosition);
      image.getImage().then(_imageRetrieved);
    }
  }

  void _imageRetrieved(Image image) {
    fireUpdatedLayer();
  }

  MapPosition _mapPosition;
  Viewport _viewport;

}