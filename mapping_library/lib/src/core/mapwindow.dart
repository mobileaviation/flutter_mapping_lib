import 'package:flutter/widgets.dart';

class MapWindow extends StatefulWidget {
  MapWindow({Key key, List<Widget> children, Offset position, bool visible}) : super(key: key) {
    _children = children;
    _position = position;
    _visible = visible;
    _windowState = MapWindowState();
  }

  List<Widget> _children;
  Offset _position;
  bool _visible;

  MapWindowState _windowState;
  @override 
  MapWindowState createState() => _windowState;
}

class MapWindowState extends State<MapWindow> {


  @override
  Widget build(BuildContext context) {
    if (widget._visible) {
      return Positioned(
        left: widget._position.dx,
        top: widget._position.dy,
        child: Container(
          child: Column(
            children: widget._children,
          ),
        ),
        
      );
    } else
      return Container();
  }
}


