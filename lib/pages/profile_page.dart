import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mokumou_hazard/view_model/marker_view_model.dart';
import 'package:mokumou_hazard/model/marker_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // デフォルトのユーザー名
  String userName = 'User';
  // デフォルトの背景画像
  String backgroundImage = 'assets/background2.jpg';

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
      backgroundImage =
          prefs.getString('background_image') ?? 'assets/background2.jpg';
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
        backgroundImage = newBackground;
      });
      await prefs.setString('background_image', newBackground);
    }
  }

  // マーカーを追加
  // void _addMarker() {
  //   TextEditingController markerController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("マーカーを追加"),
  //         content: TextField(
  //           controller: markerController,
  //           decoration: InputDecoration(labelText: "マーカー名"),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text("キャンセル"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               if (markerController.text.isNotEmpty) {
  //                 Provider.of<MarkerListModel>(context, listen: false)
  //                     .addMarker(Marker(name: markerController.text));
  //               }
  //               Navigator.pop(context);
  //             },
  //             child: Text("追加"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // マーカーを削除
  void _removeMarker(String markerID) async {
    Provider.of<MarkerListModel>(context, listen: false).removeMarker(markerID);
  }

  // 設定画面を開く (ユーザー名 & 背景画像)
  void _openSettings() {
    TextEditingController nameController =
        TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("設定"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _showBackgroundPicker(),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(backgroundImage),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                await _saveUserData(newName: nameController.text); // 新しい名前を保存
                Navigator.pop(context);
              },
              child: Text("保存"),
            ),
          ],
        );
      },
    );
  }

  // 背景画像リスト
  void _showBackgroundPicker() {
    List<String> backgrounds = [
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
                  onTap: () async {
                    await _saveUserData(newBackground: imagePath);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: AppBar(
          // appbarの画像表示
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //右上の設定アイコン
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: _openSettings,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // アイコンから下の画像を表示
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                // ユーザーアイコン
                padding: EdgeInsets.only(top: 10),
                child: CircleAvatar(
                  radius: 70,
                  child: Icon(
                    Icons.person,
                    size: 120,
                  ),
                ),
              ),
              Text(
                userName,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                  '----------------------------------------------------------'),
              // マーカーの数を表示
              Consumer<MarkerListModel>(
                builder: (context, markerListModel, child) {
                  return Text(
                    '設置したマーカーの数：${markerListModel.userMarkers.length}',
                    style: TextStyle(fontSize: 16),
                  );
                },
              ),
              Text(
                  '----------------------------------------------------------'),
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
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Consumer<MarkerListModel>(
                    builder: (context, markerListModel, child) {
                      return ListView.builder(
                        itemCount: markerListModel.userMarkers.length,
                        itemBuilder: (context, index) {
                          final marker = markerListModel.userMarkers[index];
                          return Column(
                            children: [
                              buildInfoItem(
                                  Icons.location_on, marker.name, marker.id),
                              SizedBox(height: 20.0),
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

  Widget buildInfoItem(IconData icon, String info, String markerId) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700]),
        SizedBox(width: 10),
        Text(info, style: TextStyle(fontSize: 16)),
        Spacer(),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeMarker(markerId), // 削除ボタンを押してマーカーを削除
        ),
      ],
    );
  }
}
