import 'package:flutter/cupertino.dart';
import 'sw_map.dart';

class SkywaysProvider extends InheritedWidget {
  final Widget child;
  final MapWidget mapview;

  SkywaysProvider({this.child, this.mapview}) : super(child: child);

  static SkywaysProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SkywaysProvider>();
  }
  
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}