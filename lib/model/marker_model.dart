import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MarkerModel {
  final String id;
  final String user_id;
  final String name;
  final double latitude;
  final double longitude;
  final double radius;
  final int risk_level;

  MarkerModel({
    required this.id,
    required this.user_id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.risk_level,
  });

  factory MarkerModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return MarkerModel(
      id: doc.id,
      user_id: data['user_id'],
      name: data['name'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      radius: (data['radius'] as num).toDouble(),
      risk_level: data['risk_level'],
    );
  }
}

class MarkerListModel extends ChangeNotifier {
  List<MarkerModel> markers = [];
  List<MarkerModel> userMarkers = [];

  Future<void> getMarkers() async {
    var collection =
        await FirebaseFirestore.instance.collection('markers').get();
    markers =
        collection.docs.map((doc) => MarkerModel.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<void> getUserMarkers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var collection = await FirebaseFirestore.instance
          .collection('markers')
          .where('user_id', isEqualTo: user.uid)
          .get();
      userMarkers =
          collection.docs.map((doc) => MarkerModel.fromFirestore(doc)).toList();
      notifyListeners();
    }
  }

  Future<void> removeMarker(String markerId) async {
    await FirebaseFirestore.instance
        .collection('markers')
        .doc(markerId)
        .delete();
    userMarkers.removeWhere((marker) => marker.id == markerId);
    notifyListeners();
  }
}
