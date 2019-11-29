import 'fastmath.dart' as FastMath;
import 'dart:math' as math;
import 'angles.dart' as angles;
import 'geomutils.dart';
import 'values.dart';

double latitudeDistance(int meters) {
  return (meters * 360) / (2 * math.pi * EQUATORIAL_RADIUS);
}

double longitudeDistance(int meters, double latitude) {
  return (meters * 360) /
      (2 * math.pi * EQUATORIAL_RADIUS * math.cos(angles.toRadians(latitude)));
}

class GeoPoint {
  final num serialVersionUID = 8965378345755560352;
  final double INVERSE_FLATTENING = 298.257223563;
  final double POLAR_RADIUS = 6356752.3142;

  int hashCodeValue = 0;

  int latitudeE6;
  int longitudeE6;

  GeoPoint(double lat, double lon) {
    _initGeopoint(lat, lon);
  }

  GeoPoint.fromE6(int latitudeE6, int longitudeE6) {
    _initGeopoint(
        latitudeE6 / CONVERSION_FACTOR, longitudeE6 / CONVERSION_FACTOR);
  }

  GeoPoint.fromGeopoint(GeoPoint geoPoint) {
    _initGeopoint(geoPoint.getLatitude(), geoPoint.getLongitude());
  }

  void copyFrom(GeoPoint geoPoint) {
    _initGeopoint(geoPoint.getLatitude(), geoPoint.getLongitude());
  }

  String toString() {
    return "Lat: " +
        getLatitude().toString() +
        " Lon: " +
        getLongitude().toString();
  }

  _initGeopoint(double lat, double lon) {
    lat = FastMath.clamp(lat, LATITUDE_MIN, LATITUDE_MAX);
    this.latitudeE6 = (lat * CONVERSION_FACTOR).round();
    lon = FastMath.clamp(lon, LONGITUDE_MIN, LONGITUDE_MAX);
    this.longitudeE6 = (lon * CONVERSION_FACTOR).round();
  }

  double getLongitude() {
    return this.longitudeE6 / CONVERSION_FACTOR;
  }

  double getLatitude() {
    return this.latitudeE6 / CONVERSION_FACTOR;
  }

  double bearingTo(GeoPoint other) {
    double deltaLon = angles.toRadians(other.getLongitude() - getLongitude());

    double a1 = angles.toRadians(getLatitude());
    double b1 = angles.toRadians(other.getLatitude());

    double y = math.sin(deltaLon) * math.cos(b1);
    double x = math.cos(a1) * math.sin(b1) -
        math.sin(a1) * math.cos(b1) * math.cos(deltaLon);
    double result = angles.toDegrees(math.atan2(y, x));
    return (result + 360.0) % 360.0;
  }

  int calculateHashCode() {
    int result = 7;
    result = 31 * result + this.latitudeE6;
    result = 31 * result + this.longitudeE6;
    return result;
  }

  GeoPoint destinationPoint(final double distance, final double bearing) {
    double theta = angles.toRadians(bearing);
    double delta = distance / EQUATORIAL_RADIUS; // angular distance in radians

    double phi1 = angles.toRadians(getLatitude());
    double lambda1 = angles.toRadians(getLongitude());

    double phi2 = math.asin(math.sin(phi1) * math.cos(delta) +
        math.cos(phi1) * math.sin(delta) * math.cos(theta));
    double lambda2 = lambda1 +
        math.atan2(math.sin(theta) * math.sin(delta) * math.cos(phi1),
            math.cos(delta) - math.sin(phi1) * math.sin(phi2));

    return GeoPoint(angles.toDegrees(phi2), angles.toDegrees(lambda2));
  }

  double distance(GeoPoint other) {
    return FastMath.hypot(getLongitude() - other.getLongitude(),
        getLatitude() - other.getLatitude());
  }

  double sphericalDistance(GeoPoint other) {
    double dLat = angles.toRadians(other.getLatitude() - getLatitude());
    double dLon = angles.toRadians(other.getLongitude() - getLongitude());
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(angles.toRadians(getLatitude())) *
            math.cos(angles.toRadians(other.getLatitude())) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return c * EQUATORIAL_RADIUS;
  }

  double vincentyDistance(GeoPoint other) {
    double f = 1 / INVERSE_FLATTENING;
    double L = angles.toRadians(other.getLongitude() - getLongitude());
    double u1 = math.atan((1 - f) * math.tan(angles.toRadians(getLatitude())));
    double u2 =
        math.atan((1 - f) * math.tan(angles.toRadians(other.getLatitude())));
    double sinU1 = math.sin(u1), cosU1 = math.cos(u1);
    double sinU2 = math.sin(u2), cosU2 = math.cos(u2);

    double lambda = L, lambdaP, iterLimit = 100;

    double cosSqAlpha = 0,
        sinSigma = 0,
        cosSigma = 0,
        cos2SigmaM = 0,
        sigma = 0,
        sinLambda = 0,
        sinAlpha = 0,
        cosLambda = 0;
    do {
      sinLambda = math.sin(lambda);
      cosLambda = math.cos(lambda);
      sinSigma = math.sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) +
          (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) *
              (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));
      if (sinSigma == 0) return 0; // co-incident points
      cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
      sigma = math.atan2(sinSigma, cosSigma);
      sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
      cosSqAlpha = 1 - sinAlpha * sinAlpha;
      if (cosSqAlpha != 0) {
        cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;
      } else {
        cos2SigmaM = 0;
      }
      double C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
      lambdaP = lambda;
      lambda = L +
          (1 - C) *
              f *
              sinAlpha *
              (sigma +
                  C *
                      sinSigma *
                      (cos2SigmaM +
                          C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
    } while (FastMath.abs(lambda - lambdaP) > 1e-12 && --iterLimit > 0);

    if (iterLimit == 0) return 0; // formula failed to converge

    double uSq = cosSqAlpha *
        (math.pow(EQUATORIAL_RADIUS, 2) - math.pow(POLAR_RADIUS, 2)) /
        math.pow(POLAR_RADIUS, 2);
    double A =
        1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
    double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
    double deltaSigma = B *
        sinSigma *
        (cos2SigmaM +
            B /
                4 *
                (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) -
                    B /
                        6 *
                        cos2SigmaM *
                        (-3 + 4 * sinSigma * sinSigma) *
                        (-3 + 4 * cos2SigmaM * cos2SigmaM)));
    double s = POLAR_RADIUS * A * (sigma - deltaSigma);

    return s;
  }
}
