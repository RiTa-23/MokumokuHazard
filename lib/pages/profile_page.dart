import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mokumou_hazard/model/marker_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mokumou_hazard/widgets/info_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // デフォルトのユーザー名
  String userName = 'User';
  // デフォルトの背景画像
  String? backgroundImage = '';
  // 一時的な背景画像
  String? tempBackgroundImage;

  @override
  void initState() {
    super.initState();
    Provider.of<MarkerListModel>(context, listen: false).getUserMarkers();
    _loadData();
  }

  // データをロード
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      backgroundImage = prefs.getString('background_image');
    });
  }

  // ユーザー名と背景画像を保存
  Future<void> _saveUserData({String? newName, String? newBackground}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (newName != null) {
      setState(() {
        userName = newName;
      });
      await prefs.setString('user_name', newName);
    }
    if (newBackground != null) {
      setState(() {
        backgroundImage = newBackground.isEmpty ? null : newBackground;
      });
      await prefs.setString(
          'background_image', newBackground.isEmpty ? '' : newBackground);
    }
  }

  // マーカーを削除
  void _removeMarker(String markerID) async {
    Provider.of<MarkerListModel>(context, listen: false).removeMarker(markerID);
  }

  // 設定画面を開く (ユーザー名 & 背景画像)
  void _openSettings() {
    TextEditingController nameController =
        TextEditingController(text: userName);
    tempBackgroundImage = backgroundImage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("設定"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _showBackgroundPicker(setState),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: tempBackgroundImage != null
                            ? DecorationImage(
                                image: AssetImage(tempBackgroundImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(10),
                        color: tempBackgroundImage == null ? Colors.grey : null,
                      ),
                      child: tempBackgroundImage == null
                          ? Center(child: Text('背景画像なし'))
                          : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "ユーザー名を変更"),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("キャンセル"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _saveUserData(
                        newName: nameController.text,
                        newBackground:
                            tempBackgroundImage ?? ''); // 新しい名前と背景画像を保存
                    Navigator.pop(context);
                  },
                  child: Text("保存"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 背景画像リスト
  void _showBackgroundPicker(StateSetter setState) {
    List<String> backgrounds = [
      '',
      'assets/background1.jpg',
      'assets/background2.jpg',
      'assets/background3.jpg',
    ];
    // 背景画像を選択
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('背景画像を選択'),
          content: SingleChildScrollView(
            child: Column(
              children: backgrounds.map((imagePath) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      tempBackgroundImage =
                          imagePath.isEmpty ? null : imagePath;
                    });
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: imagePath.isNotEmpty
                            ? DecorationImage(
                                image: AssetImage(imagePath),
                                fit: BoxFit.cover,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(10),
                        color: imagePath.isEmpty ? Colors.grey : null,
                      ),
                      child: imagePath.isEmpty
                          ? Center(child: Text('背景画像なし'))
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景画像
          if (backgroundImage != null)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          // 設定ボタンを含むAppBar
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: _openSettings,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                // ユーザーアイコン
                padding: EdgeInsets.only(top: 30),
                child: CircleAvatar(
                  radius: 70,
                  child: Icon(
                    Icons.person,
                    size: 70,
                  ),
                ),
              ),
              Text(
                userName,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              // マーカーの数を表示
              Consumer<MarkerListModel>(
                builder: (context, markerListModel, child) {
                  return Chip(
                    //chipの色を指定する
                    backgroundColor: Colors.white,
                    avatar: Icon(Icons.location_on, color: Colors.orange),
                    label: Text(
                      '設置したマーカーの数：${markerListModel.userMarkers.length}',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
              SizedBox(height: 5),
              // マーカー一覧
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 5),
                        Text(
                          'マーカーリスト',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 1),
                    Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // マーカーリストを表示
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Consumer<MarkerListModel>(
                    builder: (context, markerListModel, child) {
                      return ListView.builder(
                        itemCount: markerListModel.userMarkers.length,
                        itemBuilder: (context, index) {
                          final marker = markerListModel.userMarkers[index];
                          return Column(
                            children: [
                              InfoItem(
                                icon: Icons.location_on,
                                info: marker.name,
                                markerId: marker.id,
                                latitude: marker.latitude,
                                longitude: marker.longitude,
                                riskLevel: marker.risk_level,
                                radius: marker.radius,
                                onDelete: () => _removeMarker(marker.id),
                              ),
                              SizedBox(height: 5.0),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              // // マーカー追加ボタン（テスト用）
              // FloatingActionButton(
              //   onPressed: _addMarker, // ボタンを押してマーカーを追加
              //   child: Icon(Icons.location_on_outlined),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget buildInfoItem(IconData icon, String info, String markerId,
  //     double latitude, double longitude, int riskLevel, double radius) {
  //   return Card(
  //     color: Colors.white,
  //     child: Row(
  //       children: [
  //         Spacer(),
  //         Icon(icon, color: Colors.grey[700]),
  //         SizedBox(width: 10),
  //         Center(
  //           child: Container(
  //             padding: EdgeInsets.all(10),
  //             width: 250,
  //             child: Column(
  //               children: [
  //                 Text(info, style: TextStyle(fontSize: 15)),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(Icons.circle, color: Colors.blue, size: 15),
  //                     Text('半径:$radius', style: TextStyle(fontSize: 13)),
  //                   ],
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(Icons.warning, color: Colors.red, size: 15),
  //                     Text('危険度:$riskLevel', style: TextStyle(fontSize: 13)),
  //                   ],
  //                 ),
  //                 Text('緯度:$latitude', style: TextStyle(fontSize: 10)),
  //                 Text('経度:$longitude', style: TextStyle(fontSize: 10)),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Spacer(),
  //         IconButton(
  //           icon: Icon(Icons.delete, color: Colors.red),
  //           onPressed: () => _removeMarker(markerId), // 削除ボタンを押してマーカーを削除
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
