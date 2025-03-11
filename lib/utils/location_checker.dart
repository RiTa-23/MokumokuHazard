import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationChecker {
  /// **現在地がサークルの範囲内かチェックする**
  static bool isInsideCircle(Position position, Set<Circle> circles) {
    for (var circle in circles) {
      double distance = _calculateDistance(
        position.latitude,
        position.longitude,
        circle.center.latitude,
        circle.center.longitude,
      );

      if (distance < circle.radius) {
        return true; // 範囲内に入ったら `true`
      }
    }
    return false; // どのサークルにも入っていない
  }

  /// **2点間の距離を計算（Haversine formula）**
  static double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371000; // 地球の半径 (m)
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);
    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            (sin(dLon / 2) * sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  /// **角度をラジアンに変換**
  static double _degToRad(double deg) {
    return deg * (pi / 180);
  }
}
