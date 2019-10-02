import 'dart:math' as math;

double toRadians(double deg) {
  return (deg / 180) * math.pi;
}

double toDegrees(double rad) {
  return (rad * 180) / math.pi;
}