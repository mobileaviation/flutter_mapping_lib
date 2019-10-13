import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;
import '../../core/viewport.dart';
import '../../utils/geopoint.dart';
import '../../utils/boundingbox.dart';
import '../../utils/mapposition.dart';
import '../../utils/mercatorprojection.dart' as MercatorProjection;

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
    if(_visible){
      if (_overlayImage != null)
        canvas.drawImageRect(_overlayImage, Rect.fromLTWH(0, 0, _overlayImage.width.toDouble(), _overlayImage.height.toDouble()),
            _screenPosition, Paint());
    }
  }

  File _overlayImageFile;
  Image _overlayImage;
  Rect _screenPosition;
  bool _visible = true;
  get Visible { return _visible; }
  set Visible(bool value) {
    _visible = value;
    fireUpdatedImage();
  }

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
    _calculateDrawPositions(viewport, mapPosition);
  }

  _calculateDrawPositions(Viewport viewport, MapPosition mapPosition) {
    math.Point startPix = _getPixelsPosition(_imageBox.getNorthWestPoint(), mapPosition.zoomLevel);
    math.Point endPix = _getPixelsPosition(_imageBox.getSouthEastPoint(), mapPosition.zoomLevel);
    int mapSize = MercatorProjection.getMapSize(mapPosition.zoomLevel);
    math.Point centerPixels =  MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
    Size screensize = viewport.GetScreenSize();
    double startX = startPix.x - (centerPixels.x - (screensize.width/2));
    double startY = startPix.y - (centerPixels.y - (screensize.height/2));
    double endX = endPix.x - (centerPixels.x - (screensize.width/2));
    double endY = endPix.y - (centerPixels.y - (screensize.height/2));
    math.Point drawStartPoint = viewport.projectScreenPositionByReferenceAndScale(new math.Point(startX, startY),
        new math.Point(screensize.width/2, screensize.height/2),
        mapPosition.getZoomFraction() + 1);
    math.Point drawEndPoint = viewport.projectScreenPositionByReferenceAndScale(new math.Point(endX, endY),
        new math.Point(screensize.width/2, screensize.height/2),
        mapPosition.getZoomFraction() + 1);
    _screenPosition = Rect.fromLTRB(drawStartPoint.x, drawStartPoint.y, drawEndPoint.x, drawEndPoint.y);
  }

  math.Point _getPixelsPosition(GeoPoint location, int zoomLevel) {
    return MercatorProjection.GetPixelsPosition(location, zoomLevel);
  }

  bool WithinViewport(Viewport viewport) {
    return _imageBox.intersects(viewport.GetBoundingBox());
  }
}