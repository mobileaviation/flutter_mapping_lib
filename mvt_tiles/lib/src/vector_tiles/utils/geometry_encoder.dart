import 'geometry.dart';
import '../vector_tile.pb.dart' as vt;
import '../vector_tile.pbenum.dart';
import 'dart:collection';

/// GeometryEncoder
/// This class reads en encodes the Geometry values from the
/// Tile_Feature list in the read MVT tile
class GeometryEncoder {
  static Features DecodeFeatures(vt.Tile_Feature tile_feature) {
    Features _features = Features(tile_feature.type);
    
    // First integer in the geometry list is a command 
    bool command = true;

    // Define indexes
    // This is the command index, normally there are two parameters per command/index
    int index = 0;
    // In the MoveTo and LineTo commands are always have two (x en Y) vector parameter
    int paramIndex = 0;

    // Temporary vector variable
    Vector vector;
    // Store the last added vector so that the relative coordinates can be recalculated to 
    // absolute coordinates for the next vector.
    Vector lastAddedVector;
    // Temporary commandInteger  variable
    CommandInteger commandInteger;
    // If the geom is a "ClosePath" polygon the first parameters in the series needs to be stored 
    // with the ClosePath vector to have a closed polygon
    int first_x;
    int first_y;

    // Interate through the geometies (list of int) in the Tile_Feature from the MVT tile
    for (int g in tile_feature.geometry) {
      // If the parameter (geometry value) is a command
      if (command) {
        // Parse the command
        commandInteger = CommandInteger(g);
        // reset the indexes
        index = 0;
        paramIndex = 0;
        // Next geometry will be a parameter
        command = false;
        // If the command is "ClosePath" then no additional parameters are send
        if (commandInteger.id==7) {
          // Retrieve the coordinates of the first command in this series
          // So we can "Close" this polygon
          // A closed polygon will start with a "MoveTo" commmand, followed by 
          // several "LineTo" commands and last a "ClosePath" command
          // Retrieve the first "MoveTo" command parameters to store with this
          // "ClosePath" vector
          vector = Vector();
          vector.command = commandInteger.id;
          vector.x = first_x;
          vector.y = first_y;
          _features.add(vector);
        }
      } else {
        // Start reading the parameters as this geometry is a parameter
        ParameterInteger parameterInteger = ParameterInteger(g);
        // Get the next parameter (max 2) for this command by increasing the paramIndex
        paramIndex++;
        // The first parameter of a "MoveTo" or "LineTo" will be the X coordinate
        if (paramIndex==1) {
          vector = Vector();
          vector.command = commandInteger.id;
          vector.x = parameterInteger.value;
        }

        // The seconds parameter of a "MoveTo" or "LineTo" will be the Y coordinate
        if (paramIndex==2) {
          vector.y = parameterInteger.value;
          // Calculate the absolute coordinates for the part of the geometry
          _calcAbsoluteCoordinates(vector, lastAddedVector);
          _features.add(vector);
          // Store the added vector as a reference for calculating the absolute coordinates
          // of the next vector
          lastAddedVector = vector;
          paramIndex = 0;
          // If this is the first (Probably "MoveTo", Index=0) command, store its coordinates
          // to use for the "ClosePath" geom
          if (index==0) {
            first_y = vector.abs_y;
            first_x = vector.abs_x;
          }
          // The parameter are read, so increase the index
          index++;
        }   
        // Check if all the parameters for this command are read
        if (index == commandInteger.count) {
          // If so the next geometry value will be a new command
          command = true;
        }
      }
    }
    return _features;
  }

  static Vector _calcAbsoluteCoordinates(Vector geometry, Vector lastAddedGeometry) {
    geometry.abs_x = (lastAddedGeometry != null) ? lastAddedGeometry.abs_x + geometry.x : geometry.x;
    geometry.abs_y = (lastAddedGeometry != null) ? lastAddedGeometry.abs_y + geometry.y : geometry.y;
    return geometry;
  }

  static Features DecodeTags(vt.Tile_Layer layer, vt.Tile_Feature feature, Features features)
  {
    for (int i=0; i<feature.tags.length; i = i + 2) {
      int i_key = feature.tags[i];
      int i_value = feature.tags[i+1];
      String key = layer.keys[i_key];
      vt.Tile_Value value = layer.values[i_value];
      features.tags[key] = value;
    }

    return features;
  }
}

/// Geometries 
/// This is List with the Geometries parsed from the
/// Tile_Feature geometry (List<int>) variable
class Features extends ListBase<Vector> {
  Features(Tile_GeomType type) {
    _type = type;
    tags = Map();
  }

  List _innerList = List();
  Map<String, vt.Tile_Value> tags;

  @override
  Vector operator [](int index) => _innerList[index];

  @override
  void operator []=(int index, Vector value) {
    _innerList[index] = value;
  }

  void add(Vector geometry) {
    _innerList.add(geometry);
  }


  int get length => _innerList.length;
  set length(int length) {
    _innerList.length = length;
  }

  
  Tile_GeomType _type;
  get Type { return _type; }

}

class Vector {
  int command;
  int x;
  int y;
  int abs_x;
  int abs_y;

  String toString() {
    return "Geometry: cmd: " + command.toString() + " abs-coordinates: (" + abs_x.toString() + "," + abs_y.toString() + ")" +
      " coordinates: (" + x.toString() + "," + y.toString() + ")";
  }
}
