import 'package:flutter/widgets.dart';

class MapWindow extends StatefulWidget {
  MapWindow({Key key, List<Widget> buttons, Offset position, bool visible}) : super(key: key) {
    _buttons = buttons;
    _position = position;
    _visible = visible;
    _windowState = MapWindowState();
  }

  List<Widget> _buttons;
  Offset _position;
  bool _visible;

  set position(Offset value)  {
    _windowState.setState(() {
      _position = value;
    });
  } 

  set visible(bool value) {
    _windowState.setState(() {
      _visible = value;
    });
  }

  MapWindowState _windowState;
  @override 
  MapWindowState createState() => _windowState;
}

class MapWindowState extends State<MapWindow> {


  @override
  Widget build(BuildContext context) {
    if (widget._visible) {
      return Container(
        child: Column(
          children: widget._buttons,
        ),
        
      );
    } else
      return null;
  }
}

// class EditButtons extends Container {
//   EditButtons({Key key, List<Widget> buttons}) {
//     _buttons = buttons;
//   }

//   List<Widget> _buttons;
// }