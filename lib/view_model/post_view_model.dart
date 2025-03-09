import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PostViewModel extends ChangeNotifier {
  LatLng? selectedLocation;
  double radius = 50.0;
  double riskLevel = 1.0;
  String locationName = '';

  // Firestoreにデータを格納するメソッド
  Future<void> saveMarker(BuildContext context) async {
    if (selectedLocation != null && locationName.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('markers').add({
          'user_id': user.uid,
          'name': locationName,
          'latitude': selectedLocation!.latitude,
          'longitude': selectedLocation!.longitude,
          'radius': radius,
          'risk_level': riskLevel.toInt(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('マーカーが作成されました')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ユーザーがログインしていません')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('すべてのフィールドを入力してください')),
      );
    }
  }

  void updateSelectedLocation(LatLng location) {
    selectedLocation = location;
    notifyListeners();
  }

  void updateLocationName(String name) {
    locationName = name;
    notifyListeners();
  }

  void updateRadius(double newRadius) {
    radius = newRadius;
    notifyListeners();
  }

  void updateRiskLevel(double newRiskLevel) {
    riskLevel = newRiskLevel;
    notifyListeners();
  }
}
