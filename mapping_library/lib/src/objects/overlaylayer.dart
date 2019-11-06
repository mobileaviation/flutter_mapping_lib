import 'overlay/overlayimage.dart';
import 'overlay/overlayimages.dart';
import 'layer.dart';
import 'dart:ui';
import '../utils/geopoint.dart';
import '../core/mapviewport.dart';
import '../utils/mapposition.dart';

class OverlayLayer extends Layer {
  OverlayLayer() {
    _overlayImages = OverlayImages();
  }

  OverlayImages _overlayImages;

  void addImage(OverlayImage overlayImage) {
    _overlayImages.add(overlayImage);
    overlayImage.setUpdateListener(_imageUpdated);
    fireUpdatedLayer();
  }

  void _imageUpdated(OverlayImage image) {
    _setupOverlayForViewport();
  }

  void paint(Canvas canvas, Size size) {
    for (OverlayImage image in _overlayImages) {
      if (image.withinViewport(_viewport)) {
        image.paint(canvas);
      }
    }
  }

  @override
  void notifyLayer(MapPosition mapPosition, MapViewport viewport) {
    _mapPosition = mapPosition;
    _viewport = viewport;
    _setupOverlayForViewport();
  }

  @override
  void doTabCheck(GeoPoint clickedPosition, Offset screenPos) {}

  void _setupOverlayForViewport() {
    for (OverlayImage image in _overlayImages) {
      image.calculatePixelPosition(_viewport, _mapPosition);
      image.getImage().then(_imageRetrieved);
    }
  }

  void _imageRetrieved(Image image) {
    fireUpdatedLayer();
  }

  MapPosition _mapPosition;
  MapViewport _viewport;
}
