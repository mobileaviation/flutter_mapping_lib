import 'dart:math' as math;

/// isLeft(): tests if a point is Left|On|Right of an infinite line.
///    Input:  three points P0, P1, and P2
///    Return: >0 for P2 left of the line through P0 and P1
///            =0 for P2  on the line
///            <0 for P2  right of the line
int isLeft( math.Point p0, math.Point p1, math.Point p2 )
{
  return ( (p1.x - p0.x) * (p2.y - p0.y)
      - (p2.x -  p0.x) * (p1.y - p0.y) );
}

/// wn_PnPoly(): winding number test for a point in a polygon
///      Input:   P = a point,
///               V[] = vertex points of a polygon V[n+1] with V[n]=V[0]
///      Return:  wn = the winding number (=0 only when P is outside)
int wnPnPoly( math.Point P, List<math.Point> V )
{
  int wn = 0;    // the  winding number counter
  int n = V.length-1;
  // loop through all edges of the polygon
  for (int i=0; i<n; i++) {   // edge from V[i] to  V[i+1]
    if (V[i].y <= P.y) {          // start y <= P.y
      if (V[i+1].y  > P.y)      // an upward crossing
        if (isLeft( V[i], V[i+1], P) > 0)  // P left of  edge
          ++wn;            // have  a valid up intersect
    }
    else {                        // start y > P.y (no test needed)
      if (V[i+1].y  <= P.y)     // a downward crossing
        if (isLeft( V[i], V[i+1], P) < 0)  // P right of  edge
          --wn;            // have  a valid down intersect
    }
  }
  return wn;
}

/// interceptOnCircle(): check if a line intercepts this circle
/// p1 is the first line point
/// p2 is the second line point
/// c is the circle's center
/// r is the circle's radius
List<math.Point> interceptOnCircle(math.Point p1, math.Point p2, math.Point c, double r) {
  var p3 = math.Point(p1.x - c.x, p1.y - c.y); //shifted line points
  var p4 = math.Point(p2.x - c.x, p2.y - c.y);

  var m = (p4.y - p3.y) / (p4.x - p3.x); //slope of the line
  var b = p3.y - m * p3.x; //y-intercept of line

  var underRadical = math.pow(r,2)*math.pow(m,2) + math.pow(r,2) - math.pow(b,2); //the value under the square root sign

  if (underRadical < 0) {
    //line completely missed
    return null;
  } else {
    var t1 = (-m*b + math.sqrt(underRadical))/(math.pow(m,2) + 1); //one of the intercept x's
    var t2 = (-m*b - math.sqrt(underRadical))/(math.pow(m,2) + 1); //other intercept's x
    var i1 = math.Point(t1+c.x, m*t1+b+c.y); //intercept point 1
    var i2 = math.Point(t2+c.x, m*t2+b+c.y); //intercept point 2
    return [i1, i2];
  }
}


