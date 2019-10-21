import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../utils/geopoint.dart';
import '../utils/boundingbox.dart';
import '../utils/mapposition.dart';
import '../utils/mercatorprojection.dart' as MercatorProjection;
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vectorMath;

class MapViewport {
  MapViewport(Size size, MapPosition mapPosition){
    _setSize(size);
    _setupViewport(mapPosition);
    //_setupDrawport(mapPosition);
  }

  MapViewport.fromViewport(MapViewport orgViewport) {
    Size size = new Size(orgViewport._screenSize.width, orgViewport._screenSize.height);
    _setSize(size);
    MapPosition mapPosition = MapPosition.fromDegScale(
        orgViewport._mapPosition.getGeoPoint().getLatitude(),
        orgViewport._mapPosition.getGeoPoint().getLongitude(),
        orgViewport._mapPosition.getScale());
    _setupViewport(mapPosition);
    //_setupDrawport(mapPosition);
  }

  void setMapPosition(MapPosition mapPosition) {
    _setupViewport(mapPosition);
    //_setupDrawport(mapPosition);
  }

  void setMapPositionSize(Size size, MapPosition mapPosition)
  {
    _setSize(size);
    _setupViewport(mapPosition);
    //_setupDrawport(mapPosition);
  }

  math.Point getScreenPositionForMapPosition(MapPosition mapPosition)
  {
    return getScreenPositionForGeoPoint(mapPosition.getGeoPoint());
  }

  math.Point getScreenPositionForGeoPoint(GeoPoint geoPoint) {
    return MercatorProjection.getPixelRelative(geoPoint, _mapSize,
        _topLeftAbsMapPixels.x,
        _topLeftAbsMapPixels.y);
  }

  Size getScreenSize() { return _screenSize; }
  Size getDrawSize() { return _drawSize; }

  math.Point projectScreenPositionByReferenceAndScale(math.Point point, math.Point originpoint, double scale) {
    vectorMath.Matrix3 tm1 = new vectorMath.Matrix3(1,0,0,0,1,0,-originpoint.x.toDouble(),-originpoint.y.toDouble(),1);
    vectorMath.Matrix3 tm2 = new vectorMath.Matrix3(scale,0,0,0,scale,0,0,0,1);
    vectorMath.Matrix3 tm3 = new vectorMath.Matrix3(1,0,0, 0,1,0,originpoint.x.toDouble(),originpoint.y.toDouble(),1);

    vectorMath.Vector3 p = new vectorMath.Vector3(point.x.toDouble(), point.y.toDouble(), 1.0);
    tm1.transform(p);
    tm2.transform(p);
    tm3.transform(p);

    return new math.Point(p.x, p.y);
  }

  GeoPoint getNewCenterGeopointForDragPosition(Offset startDragPos, Offset curDragPos) {

    // moving the map
    // ScreenX and ScreenY is where the mouse currently is on the screen
       // Absolute (left top) position
    // Calculate new centerScreenPos relative to screenX,screenY

    double relX = startDragPos.dx - curDragPos.dx;
    double relY = startDragPos.dy - curDragPos.dy;

    double absTLx = _centerAbsMapPixels.x + relX;
    double absTLy = _centerAbsMapPixels.y + relY;

    return MercatorProjection.fromPixels(absTLx, absTLy, _mapSize);
  }

  BoundingBox getBoundingBox() { return _viewPortBoundingBox; }

  GeoPoint getGeopointForScreenPosition(math.Point screenPoint) {
    math.Point p = projectScreenPositionByReferenceAndScale(screenPoint,
        new math.Point(_screenSize.width/2, _screenSize.height/2), (1 / (1+_mapPosition.getZoomFraction())));
    
    math.Point pp = new math.Point(
        ((p.x - (_screenSize.width/2)) + _centerAbsMapPixels.x),
        ((p.y - (_screenSize.height/2)) + _centerAbsMapPixels.y));

    return MercatorProjection.fromPixels(pp.x, pp.y, _mapSize);
  }

//  void _setupDrawport(MapPosition mapPosition) {
//    _drawSize = Size(_screenSize.width * (1 + mapPosition.getZoomFraction()),
//      _screenSize.height * (1 + mapPosition.getZoomFraction()));
//    _scaledMapSize = (math.pow(2, mapPosition.getZoom()) * values.Tile.SIZE.toDouble()).floor();
//    _centerAbsMapDrawPixels = _getAbsPixelsForMapPosition(mapPosition, _scaledMapSize);
//  }

  void _setupViewport(MapPosition mapPosition) {
    _mapPosition = mapPosition;
    _mapSize = MercatorProjection.getMapSizeWithScale(mapPosition.getScale());
    _centerAbsMapPixels = _getAbsPixelsForMapPosition(mapPosition, _mapSize);

    _topLeftAbsMapPixels = new math.Point(_centerAbsMapPixels.x - (_screenSize.width/2), _centerAbsMapPixels.y - (_screenSize.height/2));
    _bottomRightAbsMapPixels = new math.Point(_centerAbsMapPixels.x + (_screenSize.width/2), _centerAbsMapPixels.y + (_screenSize.height/2));

    _viewPortBoundingBox = new BoundingBox.fromGeoPoints([
      MercatorProjection.fromPixels(_bottomRightAbsMapPixels.x, _bottomRightAbsMapPixels.y, _mapSize),
      MercatorProjection.fromPixels(_topLeftAbsMapPixels.x, _topLeftAbsMapPixels.y, _mapSize)]);
  }

  math.Point _getAbsPixelsForMapPosition(MapPosition mapPosition, int mapSize) {
    return MercatorProjection.getPixel(mapPosition.getGeoPoint(), mapSize);
  }

  void _setSize(Size size) {
    _screenSize = size;
  }

  math.Point _centerAbsMapPixels;
  math.Point _centerAbsMapDrawPixels;

  math.Point _topLeftAbsMapPixels;  // Screen pos X=0, Y=0
  get topLeftAbsPixels { return _topLeftAbsMapPixels; }
  math.Point _bottomRightAbsMapPixels;  // Screen pos X=screenSize.width, Y=screenSize.height
  get bottomRightAbsPixels { return _bottomRightAbsMapPixels; }

  int _mapSize;
  int _scaledMapSize;
  MapPosition _mapPosition;
  BoundingBox _viewPortBoundingBox;
  Size _screenSize;
  Size _drawSize;
}