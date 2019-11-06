import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/core/mapviewport.dart';
import 'package:mapping_library/src/layers/overlay/overlayimage.dart';
import 'package:mapping_library/src/layers/overlay/overlayimages.dart';
import 'package:mapping_library/src/utils/mercatorprojection.dart' as MercatorProjection;
import 'layer.dart';
import 'painters/overlaylayerpainter.dart';

class OverlayLayer extends Layer {
  OverlayLayer({Key key,
    OverlayImages overlayImages,
    String name}) : super(key) {

    layerPainter = OverlayLayerPainter();
    layerPainter.layer = this;
    _setOverlaysUpdateListener();

    this.overlayImages = overlayImages;

    this.name = (name == null) ? "OverlayLayer" : name;
  }

  OverlayImages overlayImages;

  _setOverlaysUpdateListener() {
    for (OverlayImage image in overlayImages) {
      image.setUpdateListener(_imageUpdated);
    }
  }

  _setup(MapViewport viewport) {
    for (OverlayImage image in overlayImages) {
      image.calculatePixelPosition(mapViewPort, mapViewPort.mapPosition);
      image.getImage().then((image) {
        layerPainter.redraw();
      });
    }
  }

  @override
  notifyLayer(MapViewport viewport, bool mapChanged) {
    super.notifyLayer(viewport, mapChanged);
    _setup(viewport);
  }

  void addImage(OverlayImage overlayImage) {
    overlayImages.add(overlayImage);
    overlayImage.setUpdateListener(_imageUpdated);
    _setup(mapViewPort);
  }

  void _imageUpdated(OverlayImage image) {
    _setup(mapViewPort);
  }

}