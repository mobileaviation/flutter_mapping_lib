import 'mapview.dart';
import 'package:flutter/widgets.dart';

class MapViewStateBase extends State<MapView> {
  CustomPaint p;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    RenderBox _mapViewRenderbox = this.context.findRenderObject();
    Size _size = _mapViewRenderbox.size;
    widget.setupViewPort(_size);
    widget.initialized = true;
    widget.mapReady(widget);
  }

  @override
  Widget build(BuildContext context) {
    p = CustomPaint(
      foregroundPainter: widget.layerPainter,
    );

    return p;
  }
}
