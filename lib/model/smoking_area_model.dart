import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SmokingAreaModel {
  final String name;
  final double latitude;
  final double longitude;

  SmokingAreaModel({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class SmokingAreaListModel extends ChangeNotifier {
  List<SmokingAreaModel> smokingAreas = [];

  Future getSmokingAreas() async {
    var collection =
        await FirebaseFirestore.instance.collection('smoking_areas').get();
    smokingAreas = collection.docs
        .map((doc) => SmokingAreaModel(
            name: doc['name'],
            latitude: doc['latitude'],
            longitude: doc['longitude']))
        .toList();
    this.smokingAreas = smokingAreas;
    notifyListeners();
  }
}
