import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'root_page.dart';

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

    //  20秒後に RootPage に遷移
    Timer(Duration(seconds: 20), () {
      if (mounted) { // エラー防止用
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => RootPage()),
        );
      }
    });
  }

  // バイブレーションを開始
  void _startVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 2000); // 2000ms 振動
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // 背景色を赤に設定
      body: Column(
        children: [
          _buildTigerTapeLine(), //  上部の虎テープ
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //  ロゴを中央に表示
                  Image.asset(
                    'assets/logo.png', // ロゴのパス
                    width: 150, // サイズ調整
                    height: 150,
                  ),
                  SizedBox(height: 20), // 間隔調整
                  Text(
                    '⚠ WARNING ⚠',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildTigerTapeLine(), //  下部の虎テープ
        ],
      ),
    );
  }

  //  虎テープ（黄色と黒の斜めストライプ）を作成
  Widget _buildTigerTapeLine() {
    return Container(
      height: 30, // ラインの高さ
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/tiger_tape.png'), //  斜めストライプの画像
          fit: BoxFit.cover, // 横幅いっぱいに拡大
        ),
      ),
    );
  }
}