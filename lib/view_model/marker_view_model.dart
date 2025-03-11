import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mokumou_hazard/model/smoking_area_model.dart';
import 'package:mokumou_hazard/model/marker_model.dart';

class MarkerViewModel extends ChangeNotifier {
  final SmokingAreaListModel smokingAreaListModel;
  final MarkerListModel markerListModel;

  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  MarkerViewModel({
    required this.smokingAreaListModel,
    required this.markerListModel,
  });

  Set<Marker> get markers => _markers;
  Set<Circle> get circles => _circles;

  /// Firestore からそれぞれのデータを取得し、両方の情報から Marker と Circle を作成する
  Future<void> loadAllMarkers() async {
    // カスタムアイコンの読み込み
    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/icon.png',
    );

    await smokingAreaListModel.getSmokingAreas();
    var _smoking_markers = smokingAreaListModel.smokingAreas.map((area) {
      return Marker(
        markerId: MarkerId(area.name),
        position: LatLng(area.latitude, area.longitude),
        infoWindow: InfoWindow(title: area.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      );
    }).toSet();

    await markerListModel.getMarkers();
    var _circle_markers = markerListModel.markers.map((mModel) {
      return Marker(
        markerId: MarkerId(mModel.id),
        position: LatLng(mModel.latitude, mModel.longitude),
        infoWindow: InfoWindow(title: mModel.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    }).toSet();
    _circles = markerListModel.markers.map((mModel) {
      return Circle(
        circleId: CircleId(mModel.id),
        center: LatLng(mModel.latitude, mModel.longitude),
        radius: mModel.radius, // m 単位で指定
        fillColor: Colors.red.withOpacity(mModel.risk_level / 5.0 * 0.8),
        strokeColor: Colors.red,
        strokeWidth: 1,
      );
    }).toSet();

    _markers = _smoking_markers.union(_circle_markers);

    notifyListeners();
  }
}
