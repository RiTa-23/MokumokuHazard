import 'package:flutter/material.dart';
import 'env/env.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    print(Env.key); // 環境変数の値を表示(デバッグ用)
    return const Scaffold(
      body: Center(
        child: Text('ここにマップ画面を作成する'),
      ),
    );
  }
}
