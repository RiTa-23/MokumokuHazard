import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
// マップビューの初期位置
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(0.0, 0.0)); // 追加
  // マップの表示制御用
  late GoogleMapController mapController; // 追加

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
            GoogleMap(
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
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
                      //　ズームアウトボタン
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
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                    35.65872865514525, // 仮の緯度。後で変更
                                    139.74543290592266 // 仮の経度。後で変更
                                    ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
