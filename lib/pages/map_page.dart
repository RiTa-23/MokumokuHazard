import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';
import 'package:mokumou_hazard/view_model/marker_view_model.dart';
import 'package:mokumou_hazard/pages/alert_page.dart'; //遷移先
import 'package:mokumou_hazard/utils/location_checker.dart'; //アラートチェック;
import 'package:mokumou_hazard/utils/get_current_location.dart'; //現在地取得

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // マップビューの初期位置
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(33.5902, 130.4028), zoom: 14.0);
  // マップの表示制御用
  late GoogleMapController mapController;
  // 現在位置の記憶用
  late Position _currentPosition;
  // 現在位置のテキスト表示用
  String _currentAddress = '現在位置を取得中...';
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

        // カメラを現在位置に移動させる場合
        _displayCurrentLocation();

        // 現在位置のテキストを更新
        _currentAddress = '緯度: ${position.latitude}, 経度: ${position.longitude}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    Timer.periodic(Duration(seconds: 2), (timer) {
      _checkCurrentLocation();
    });

    // コンパスのデータを取得
    FlutterCompass.events!.listen((event) {
      if (mounted) {
        setState(() {
          _direction = event.heading!;
        });
      }
    });
  }

  /// **現在地を取得し、サークル内か判定**
  Future<void> _checkCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });

    _checkLocation(position);
  }

  /// **サークル内に入ったか判定**
  void _checkLocation(Position position) {
    final markerVM = Provider.of<MarkerViewModel>(context, listen: false);
    if (LocationChecker.isInsideCircle(position, markerVM.circles)) {
      _navigateToNextPage();
    }
  }

  /// **画面遷移**
  void _navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlertPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 画面の幅と高さを決定する
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Consumer<MarkerViewModel>(
              builder: (context, markerVM, child) {
                return GoogleMap(
                  initialCameraPosition: _initialLocation,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  markers: markerVM.markers,
                  circles: markerVM.circles,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                );
              },
            ),
            // ここからボタンを表示するためのコードを追加
            // ズームイン・ズームアウトのボタンを配置
            SafeArea(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 100.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // ズームインボタン
                      ClipOval(
                        child: Material(
                          color: Colors.blue.shade100, // ボタンを押す前のカラー
                          child: InkWell(
                            splashColor: Colors.blue, // ボタンを押した後のカラー
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.add),
                            ),
                            onTap: () {
                              mapController.animateCamera(
                                CameraUpdate.zoomIn(),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // ズームアウトボタン
                      ClipOval(
                        child: Material(
                          color: Colors.blue.shade100, // ボタンを押す前のカラー
                          child: InkWell(
                            splashColor: Colors.blue, // ボタンを押した後のカラー
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.remove),
                            ),
                            onTap: () {
                              mapController.animateCamera(
                                CameraUpdate.zoomOut(),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  // 現在地表示ボタン
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange.shade100, // ボタンを押す前のカラー
                      child: InkWell(
                        splashColor: Colors.blue, // ボタンを押した後のカラー
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          _getCurrentLocation();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // // 現在地のテキスト表示
            // SafeArea(
            //   child: Align(
            //     alignment: Alignment.topCenter,
            //     child: Container(
            //       padding: const EdgeInsets.all(10.0),
            //       child: Container(
            //         height: 60.0,
            //         color: Colors.white,
            //         child: Column(
            //           children: [
            //             Text(
            //               _currentAddress,
            //               style: TextStyle(fontSize: 16.0),
            //             ),
            //             Text(
            //               '方向: $_direction°',
            //               style: TextStyle(fontSize: 16.0),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
