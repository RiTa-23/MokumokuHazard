import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mokumou_hazard/model/smoking_area_model.dart';

class SmokingAreaViewModel extends ChangeNotifier {
  final SmokingAreaListModel _smokingAreaListModel;
  Set<Marker> _markers = {};

  SmokingAreaViewModel(this._smokingAreaListModel);

  Set<Marker> get markers => _markers;

  Future<void> loadSmokingAreas() async {
    await _smokingAreaListModel.getSmokingAreas();
    _markers = _smokingAreaListModel.smokingAreas.map((area) {
      return Marker(
        markerId: MarkerId(area.name),
        position: LatLng(area.latitude, area.longitude),
        infoWindow: InfoWindow(title: area.name),
      );
    }).toSet();
    notifyListeners();
  }
}
