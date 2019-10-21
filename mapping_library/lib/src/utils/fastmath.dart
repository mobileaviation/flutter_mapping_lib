import 'dart:math' as math;

num abs(num value) {
  return value < 0 ? -value : value;
}

num absMax(num value1, num value2) {
  num a1 = value1 < 0 ? -value1 : value1;
  num a2 = value2 < 0 ? -value2 : value2;
  return a2 < a1 ? a1 : a2;
}

bool absMaxCmp(num value1, num value2, num cmp) {
  return value1 < -cmp || value1 > cmp || value2 < -cmp || value2 > cmp;
}

num clamp(num value, num min, num max) {
  return (value < min ? min : (value > max ? max : value));
}

num clampDegree(num degree) {
  while (degree > 180) degree -= 360;
  while (degree < -180) degree += 360;
  return degree;
}

num clampN(num value) {
  return (value < 0 ? 0 : (value > 1 ? 1 : value));
}

num clampRadian(num radian) {
  while (radian > math.pi) radian -= 2 * math.pi;
  while (radian < -math.pi) radian += 2 * math.pi;
  return radian;
}

int clampToByte(int value) {
  return (value < 0 ? 0 : (value > 255 ? 255 : value));
}

int log2(int x) {
  int r = 0; // result of log2(v) will go here

  if ((x & 0xFFFF0000) != 0) {
    x >>= 16;
    r |= 16;
  }
  if ((x & 0xFF00) != 0) {
    x >>= 8;
    r |= 8;
  }
  if ((x & 0xF0) != 0) {
    x >>= 4;
    r |= 4;
  }
  if ((x & 0xC) != 0) {
    x >>= 2;
    r |= 2;
  }
  if ((x & 0x2) != 0) {
    r |= 1;
  }
  return r;
}

double pow(int x) {
  if (x == 0) return 1;

  return (x > 0 ? (1 << x) : (1.0 / (1 << -x)));
}

double round2(double value) {
  return (value * 100).roundToDouble() / 100;
}

bool withinSquaredDist(num dx, num dy, num distance) {
  return dx * dx + dy * dy < distance;
}

double hypot(double a, double b) {
  double x = math.max(abs(a), abs(b));
  double y = math.min(abs(a), abs(b));

  if (x == 0) return 0;
  double t = y / x;
  return x * math.sqrt(1 + t * t);
}
