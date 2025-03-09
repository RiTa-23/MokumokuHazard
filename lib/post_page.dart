import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mokumou_hazard/utils/get_current_location.dart';
import 'package:provider/provider.dart';
import 'package:mokumou_hazard/view_model/post_view_model.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late GoogleMapController mapController;
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostViewModel(),
      child: Scaffold(
        body: Column(
          children: [
            // 上2/3のGoogleMap表示
            Expanded(
              flex: 5,
              child: Consumer<PostViewModel>(
                builder: (context, postVM, child) {
                  return GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(33.881918764227144,
                          130.87829735395513), // 初期位置を福岡市役所前広場に設定
                      zoom: 14.0,
                    ),
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    onTap: (LatLng location) {
                      postVM.updateSelectedLocation(location);
                    },
                    markers: postVM.selectedLocation != null
                        ? {
                            Marker(
                              markerId: MarkerId('selectedLocation'),
                              position: postVM.selectedLocation!,
                            ),
                          }
                        : {},
                    circles: postVM.selectedLocation != null
                        ? {
                            Circle(
                              circleId: CircleId('selectedCircle'),
                              center: postVM.selectedLocation!,
                              radius: postVM.radius,
                              fillColor: Colors.red
                                  .withOpacity(postVM.riskLevel / 5.0 * 0.8),
                              strokeColor: Colors.red,
                              strokeWidth: 2,
                            ),
                          }
                        : {},
                  );
                },
              ),
            ),
            // 下1/3の詳細設定画面
            Expanded(
              flex: 4,
              child: Consumer<PostViewModel>(
                builder: (context, postVM, child) {
                  return postVM.selectedLocation == null
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
                                  postVM.updateLocationName(value);
                                },
                              ),
                              // 半径を設定するスライドバー
                              Row(
                                children: [
                                  Text(
                                      '半径: ${postVM.radius.toStringAsFixed(0)} m'),
                                  Expanded(
                                    child: Slider(
                                      value: postVM.radius,
                                      min: 5.0,
                                      max: 100.0,
                                      divisions: 100,
                                      label: postVM.radius.toStringAsFixed(0),
                                      onChanged: (value) {
                                        postVM.updateRadius(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              // 危険度を設定するスライドバー
                              Row(
                                children: [
                                  Text(
                                      '危険度: ${postVM.riskLevel.toStringAsFixed(0)}'),
                                  Expanded(
                                    child: Slider(
                                      value: postVM.riskLevel,
                                      min: 1.0,
                                      max: 5.0,
                                      divisions: 4,
                                      label:
                                          postVM.riskLevel.toStringAsFixed(0),
                                      onChanged: (value) {
                                        postVM.updateRiskLevel(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              // 作成ボタン
                              ElevatedButton(
                                onPressed: () => postVM.saveMarker(context),
                                child: Text('作成'),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
