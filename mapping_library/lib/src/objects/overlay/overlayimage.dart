import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;
import '../../core/mapviewport.dart';
import 'package:geometric_utils/geometric_utils.dart';
import 'package:geometric_utils/mercator_utils.dart'  as MercatorProjection;
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

  void fireUpdatedImage() {
    if (_imageUpdated != null) {
      _imageUpdated(this);
    }
  }

  void paint(Canvas canvas) {
    if (_visible) {
      if (_overlayImage != null)
        canvas.drawImageRect(
            _overlayImage,
            Rect.fromLTWH(0, 0, _overlayImage.width.toDouble(),
                _overlayImage.height.toDouble()),
            _screenPosition,
            Paint());
    }
  }

  File _overlayImageFile;
  Image _overlayImage;
  Rect _screenPosition;
  bool _visible = true;

  get visible {
    return _visible;
  }

  set visible(bool value) {
    _visible = value;
    fireUpdatedImage();
  }

  Future<Image> getImage() async {
    if (_overlayImage != null) return _overlayImage;

    var bytes = await _overlayImageFile.readAsBytes();
    var codec = await instantiateImageCodec(bytes);
    var f = await codec.getNextFrame();
    _overlayImage = f.image;

    return _overlayImage;
  }

  BoundingBox getBoundingBox() {
    return _imageBox;
  }

  void calculatePixelPosition(MapViewport viewport, MapPosition mapPosition) {
    _calculateDrawPositions(viewport, mapPosition);
  }

  _calculateDrawPositions(MapViewport viewport, MapPosition mapPosition) {
    math.Point startPix = _getPixelsPosition(
        _imageBox.getNorthWestPoint(), mapPosition.zoomLevel);
    math.Point endPix = _getPixelsPosition(
        _imageBox.getSouthEastPoint(), mapPosition.zoomLevel);
    int mapSize = MercatorProjection.getMapSize(mapPosition.zoomLevel);
    math.Point centerPixels =
        MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
    Size screensize = viewport.getScreenSize();
    double startX = startPix.x - (centerPixels.x - (screensize.width / 2));
    double startY = startPix.y - (centerPixels.y - (screensize.height / 2));
    double endX = endPix.x - (centerPixels.x - (screensize.width / 2));
    double endY = endPix.y - (centerPixels.y - (screensize.height / 2));
    math.Point drawStartPoint =
        viewport.projectScreenPositionByReferenceAndScale(
            math.Point(startX, startY),
            math.Point(screensize.width / 2, screensize.height / 2),
            mapPosition.getZoomFraction() + 1);
    math.Point drawEndPoint = viewport.projectScreenPositionByReferenceAndScale(
        math.Point(endX, endY),
        math.Point(screensize.width / 2, screensize.height / 2),
        mapPosition.getZoomFraction() + 1);
    _screenPosition = Rect.fromLTRB(
        drawStartPoint.x, drawStartPoint.y, drawEndPoint.x, drawEndPoint.y);
  }

  math.Point _getPixelsPosition(GeoPoint location, int zoomLevel) {
    return MercatorProjection.getPixelsPosition(location, zoomLevel);
  }

  bool withinViewport(MapViewport viewport) {
    return _imageBox.intersects(viewport.getBoundingBox());
  }
}
