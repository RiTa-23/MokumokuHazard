import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mokumou_hazard/utils/get_current_location.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late GoogleMapController mapController;
  LatLng? selectedLocation;
  double radius = 50.0;
  double riskLevel = 1.0;
  String locationName = '';

  // 現在位置の記憶用
  late Position _currentPosition;
  // コンパスのデータ
  double _direction = 0.0;

  // 現在位置を表示するメソッド
  Future<void> _displayCurrentLocation() async {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentPosition.latitude,
            _currentPosition.longitude,
          ),
          zoom: 18.0,
          bearing: _direction,
        ),
      ),
    );
  }

  // 現在位置の取得方法
  Future<void> _getCurrentLocation() async {
    Position? position = await getCurrentLocation(context);
    if (position != null && mounted) {
      setState(() {
        // 位置を変数に格納する
        _currentPosition = position;

        // カメラを現在位置に移動させる
        _displayCurrentLocation();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //現在地を取得
    _getCurrentLocation();

    // コンパスのデータを取得
    FlutterCompass.events!.listen((event) {
      if (mounted) {
        setState(() {
          _direction = event.heading!;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 上2/3のGoogleMap表示
          Expanded(
            flex: 2,
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    33.881918764227144, 130.87829735395513), // 初期位置を福岡市役所前広場に設定
                zoom: 14.0,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              onTap: (LatLng location) {
                setState(() {
                  selectedLocation = location;
                });
              },
              markers: selectedLocation != null
                  ? {
                      Marker(
                        markerId: MarkerId('selectedLocation'),
                        position: selectedLocation!,
                      ),
                    }
                  : {},
              circles: selectedLocation != null
                  ? {
                      Circle(
                        circleId: CircleId('selectedCircle'),
                        center: selectedLocation!,
                        radius: radius,
                        fillColor:
                            Colors.red.withOpacity(riskLevel / 5.0 * 0.8),
                        strokeColor: Colors.red,
                        strokeWidth: 2,
                      ),
                    }
                  : {},
            ),
          ),
          // 下1/3の詳細設定画面
          Expanded(
            flex: 1,
            child: selectedLocation == null
                ? Center(
                    child: Text(
                      'MAPをタップして地点を選択してください',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // 場所の名前を入力するフィールド
                        TextField(
                          decoration: InputDecoration(labelText: '場所の説明'),
                          onChanged: (value) {
                            setState(() {
                              locationName = value;
                            });
                          },
                        ),
                        // 半径を設定するスライドバー
                        Row(
                          children: [
                            Text('半径: ${radius.toStringAsFixed(0)} m'),
                            Expanded(
                              child: Slider(
                                value: radius,
                                min: 5.0,
                                max: 100.0,
                                divisions: 100,
                                label: radius.toStringAsFixed(0),
                                onChanged: (value) {
                                  setState(() {
                                    radius = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        // 危険度を設定するスライドバー
                        Row(
                          children: [
                            Text('危険度: ${riskLevel.toStringAsFixed(0)}'),
                            Expanded(
                              child: Slider(
                                value: riskLevel,
                                min: 1.0,
                                max: 5.0,
                                divisions: 4,
                                label: riskLevel.toStringAsFixed(0),
                                onChanged: (value) {
                                  setState(() {
                                    riskLevel = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
