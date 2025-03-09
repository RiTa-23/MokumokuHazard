import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}

class MarkerListModel extends ChangeNotifier {
  List<MarkerModel> markers = [];

  Future getMarkers() async {
    var collection =
        await FirebaseFirestore.instance.collection('markers').get();
    markers = collection.docs
        .map((doc) => MarkerModel(
            id: doc.id,
            user_id: doc['user_id'],
            name: doc['name'],
            latitude: doc['latitude'],
            longitude: doc['longitude'],
            radius: (doc['radius'] as num).toDouble(),
            risk_level: doc['risk_level']))
        .toList();
    this.markers = markers;
    notifyListeners();
  }
}
