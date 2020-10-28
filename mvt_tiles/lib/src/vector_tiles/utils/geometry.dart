/// Decode the CommandInterger
/// First three bits holds the command range 0-7
/// Remaining 29 bits holds the command count 
/// each command holds 2 (two) ParameterIntegers (x, y)
class CommandInteger {
  CommandInteger(int commandInteger) {
    id = commandInteger & 0x7;
    count = commandInteger >> 3;
  }

  int id;
  int count;
}

/// Decode the ParameterInteger
/// A parameterInteger is 'zigzag' encoded
class ParameterInteger {
  ParameterInteger(int parameterInteger) {
    value = ((parameterInteger >> 1) ^ (-(parameterInteger & 1)));
  }

  int value;
}