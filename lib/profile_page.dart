import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
String userName = 'User'; // 初期ユーザー名

class _ProfilePageState extends State<ProfilePage> {
 // マーカーリスト（初期データ）
  List<String> markers = [
    '福岡県福岡市東区和白東3-30-1',
    '福岡県福岡市東区和白丘1-22-27',
    'マーカーを置いた場所3',
  ];

  // マーカーを追加するる
  void addMarker() {
    setState(() {
      markers.add('マーカーを置いた場所${markers.length + 1}');
    });
  }

  // マーカーを削除する
  void _removeMarker(int index) {
    setState(() {
      markers.removeAt(index);
    });
  }

  // 設定画面を開く
  void _Settings() {
    TextEditingController nameController = TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("設定"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              onPressed: () {
                setState(() {
                  userName= nameController.text; // 新しい名前を保存
                });
                Navigator.pop(context);
              },
              child: Text("保存"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(30),
      child: AppBar(
        // 右上の設定アイコン
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _Settings,
          ),
        ],
        ),
      ),
      body: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //ユーザーアイコン
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: CircleAvatar(
              radius: 70,
              child: Icon(Icons.person,size: 120,), 
            ),
          ),
          //ユーザーネーム
          Text(
            userName, 
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            '----------------------------------------------------------'
          ),
          // マーカーの数を表示
          Text(
            '設置したマーカーの数：${markers.length}', 
            style: TextStyle(fontSize: 16),
          ),
          Text(
            '----------------------------------------------------------'
          ),
          SizedBox(height: 5,),

          // マーカー一覧
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue), // 鉛筆アイコン
                    SizedBox(width: 5),
                    Text(
                      '＜マーカー一覧＞',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 1),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.grey, // 下線
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          //マーカーリストを表示
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: ListView.builder(
                itemCount: markers.length, 
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      buildInfoItem(Icons.location_on, markers[index], index),
                      SizedBox(height: 20.0),
                    ],
                  );
                },
              ),
            ),
          ),
          // マーカー追加ボタン（テスト用）
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: addMarker,  // ボタンを押してマーカーを追加
              child: Text("マーカーを追加"),
            ),
          ),

          

        ],
      ),
    );
  }

  Widget buildInfoItem(IconData icon, String info, int index) {
    return Row(
      children: [
        Icon(icon,color: Colors.grey[700],),
        SizedBox(width: 10),
        Text(info,style: TextStyle(fontSize: 16),
        ),
        Spacer(),
        // 削除ボタン
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeMarker(index), // 削除ボタンを押してマーカーを削除
        ),
      ],
    );
  }
}
