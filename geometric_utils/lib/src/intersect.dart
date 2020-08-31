import 'dart:developer';
import 'dart:math' as math;
import 'fastmath.dart';

class CircleLineIntersect {

  final double _eps = 1e-14;
  
  double _sq(double x) {
    return x * x;
  }

  bool _within(double x1, double y1, double x2, double y2, double x, double y) {
    double d1 = math.sqrt(_sq(x2 - x1) + _sq(y2 - y1));    // distance between end-points
    double d2 = math.sqrt(_sq(x - x1) + _sq(y - y1));      // distance from point to one end
    double d3 = math.sqrt(_sq(x2 - x) + _sq(y2 - y));      // distance from point to other end
    double delta = d1 - d2 - d3;
    return abs(delta) < _eps;   // true if delta is less than a small tolerance
  }

  int _rxy(double x1, double y1, double x2, double y2, double x, double y, bool segment) {
    if (!segment || _within(x1, y1, x2, y2, x, y)) {
      // print_point(make_point(x, y));
      return 1;
    } else {
      return 0;
    }
  }
  
  double _fx(double A, double B, double C, double x) {
    return -(A * x + C) / B;
  }
  
  double _fy(double A, double B, double C, double y) {
    return -(B * y + C) / A;
  }

// Prints the intersection points (if any) of a circle, center 'cp' with radius 'r',
// and either an infinite line containing the points 'p1' and 'p2'
// or a segment drawn between those points.
int intersects(math.Point p1, math.Point p2, math.Point cp, double r, bool segment) {
    double x0 = cp.x, y0 = cp.y;
    double x1 = p1.x, y1 = p1.y;
    double x2 = p2.x, y2 = p2.y;
    double A = y2 - y1;
    double B = x1 - x2;
    double C = x2 * y1 - x1 * y2;
    double a = _sq(A) + _sq(B);
    double b, c, d;
    bool bnz = true;
    int cnt = 0;
 
    if (abs(B) >= _eps) {
        // if B isn't zero or close to it
        b = 2 * (A * C + A * B * y0 - _sq(B) * x0);
        c = _sq(C) + 2 * B * C * y0 - _sq(B) * (_sq(r) - _sq(x0) - _sq(y0));
    } else {
        b = 2 * (B * C + A * B * x0 - _sq(A) * y0);
        c = _sq(C) + 2 * A * C * x0 - _sq(A) * (_sq(r) - _sq(x0) - _sq(y0));
        bnz = false;
    }
    d = _sq(b) - 4 * a * c; // discriminant
    if (d < 0) {
        // line & circle don't intersect
        //printf("[]\n");
        return 0;
    }
 
    if (d == 0) {
        // line is tangent to circle, so just one intersect at most
        if (bnz) {
            double x = -b / (2 * a);
            double y = _fx(A, B, C, x);
            cnt = _rxy(x1, y1, x2, y2, x, y, segment);
        } else {
            double y = -b / (2 * a);
            double x = _fy(A, B, C, y);
            cnt = _rxy(x1, y1, x2, y2, x, y, segment);
        }
    } else {
        // two intersects at most
        d = math.sqrt(d);
        if (bnz) {
            double x = (-b + d) / (2 * a);
            double y = _fx(A, B, C, x);
            cnt = _rxy(x1, y1, x2, y2, x, y, segment);
 
            x = (-b - d) / (2 * a);
            y = _fx(A, B, C, x);
            cnt += _rxy(x1, y1, x2, y2, x, y, segment);
        } else {
            double y = (-b + d) / (2 * a);
            double x = _fy(A, B, C, y);
            cnt = _rxy(x1, y1, x2, y2, x, y, segment);
 
            y = (-b - d) / (2 * a);
            x = _fy(A, B, C, y);
            cnt += _rxy(x1, y1, x2, y2, x, y, segment);
        }
    }
 
    if (cnt <= 0) {
        //printf("[]");
    }
    return cnt;
}

}