import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class AlertPage extends StatefulWidget {
  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  @override
  void initState() {
    super.initState();

    // 画面表示時にバイブレーションを実行
    _startVibration();

    // 20秒後に RootPage に自動遷移
    Timer(Duration(seconds: 20), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RootPage()),
      );
    });
  }

  // バイブレーションを開始
  void _startVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 500); // 500ms 振動
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // 背景色を赤に設定
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 上下に配置
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text(
                '⚠ WARNING ⚠',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Text(
                '⚠ WARNING ⚠',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// RootPage の仮コード（遷移先のページ）
class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Root Page')),
    );
  }
}