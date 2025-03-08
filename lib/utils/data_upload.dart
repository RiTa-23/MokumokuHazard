import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//FireStoreデータアップロード用
class DataUploadPage extends StatelessWidget {
  final List<Map<String, dynamic>> smokingAreas = [
    {"name": "福岡市役所前広場 喫煙所", "latitude": 33.5902, "longitude": 130.4028},
    {"name": "天神地下街 喫煙所", "latitude": 33.5906, "longitude": 130.4017},
    {"name": "博多駅前広場 喫煙所", "latitude": 33.5895, "longitude": 130.4207},
    {"name": "キャナルシティ博多 喫煙所", "latitude": 33.5891, "longitude": 130.4128},
    {"name": "福岡パルコ 喫煙所", "latitude": 33.5903, "longitude": 130.3989},
    {"name": "岩田屋本店 喫煙所", "latitude": 33.5908, "longitude": 130.3983},
    {"name": "福岡三越 喫煙所", "latitude": 33.5899, "longitude": 130.3980},
    {"name": "ソラリアプラザ 喫煙所", "latitude": 33.5897, "longitude": 130.3985},
    {"name": "天神コア 喫煙所", "latitude": 33.5905, "longitude": 130.3987},
    {"name": "IMS（イムズ） 喫煙所", "latitude": 33.5902, "longitude": 130.3989},
    {"name": "博多リバレイン 喫煙所", "latitude": 33.5940, "longitude": 130.4060},
    {"name": "マリノアシティ福岡 喫煙所", "latitude": 33.5811, "longitude": 130.3208},
    {"name": "ホークスタウンモール 喫煙所", "latitude": 33.5933, "longitude": 130.3625},
    {"name": "福岡空港 国内線ターミナル 喫煙所", "latitude": 33.5850, "longitude": 130.4500},
    {"name": "福岡空港 国際線ターミナル 喫煙所", "latitude": 33.5865, "longitude": 130.4422},
    {"name": "福岡市中央卸売市場 喫煙所", "latitude": 33.5875, "longitude": 130.3847},
    {"name": "福岡市博多港国際ターミナル 喫煙所", "latitude": 33.6090, "longitude": 130.4083},
    {"name": "福岡市美術館 喫煙所", "latitude": 33.5836, "longitude": 130.3794},
    {"name": "福岡市博物館 喫煙所", "latitude": 33.5830, "longitude": 130.3510},
    {"name": "福岡市動植物園 喫煙所", "latitude": 33.5700, "longitude": 130.3761},
    {"name": "福岡タワー 喫煙所", "latitude": 33.5931, "longitude": 130.3519},
    {"name": "ヤフオクドーム 喫煙所", "latitude": 33.5950, "longitude": 130.3623},
    {"name": "マリンメッセ福岡 喫煙所", "latitude": 33.6091, "longitude": 130.4125},
    {"name": "福岡国際会議場 喫煙所", "latitude": 33.6085, "longitude": 130.4120},
    {"name": "福岡サンパレス ホテル&ホール 喫煙所", "latitude": 33.6092, "longitude": 130.4118},
    {"name": "アクロス福岡 喫煙所", "latitude": 33.5900, "longitude": 130.4010},
    {"name": "福岡国際センター 喫煙所", "latitude": 33.6094, "longitude": 130.4110},
    {"name": "福岡市中央区役所 喫煙所", "latitude": 33.5890, "longitude": 130.3920},
    {"name": "福岡市博多区役所 喫煙所", "latitude": 33.5900, "longitude": 130.4100},
  ];

  Future<void> uploadData() async {
    final collection = FirebaseFirestore.instance.collection('smoking_areas');
    for (var area in smokingAreas) {
      await collection.add(area);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Upload'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: uploadData,
          child: Text('Upload Data'),
        ),
      ),
    );
  }
}
