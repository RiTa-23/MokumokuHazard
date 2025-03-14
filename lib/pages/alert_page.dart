import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart'; // 🎵 追加
import 'root_page.dart';

class AlertPage extends StatefulWidget {
  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final AudioPlayer _audioPlayer = AudioPlayer(); // 🎵 追加

  @override
  void initState() {
    super.initState();

    _startVibration();
    _playAlertSound(); // 🎵 アラート音を鳴らす

    // 12秒後に RootPage に遷移
    Timer(Duration(seconds: 12), () {
      if (mounted) {
        // エラー防止
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

  // 🎵 アラート音を再生
  void _playAlertSound() async {
    await _audioPlayer.play(AssetSource('sounds/alert.m4a')); // 音声ファイルのパス
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // 🎵 メモリ解放
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(251, 139, 16, 7),
      body: Column(
        children: [
          _buildTigerTapeLine(), // 上部の虎テープ
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    '受動喫煙警戒区域に入りました',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Image.asset(
                    'assets/logo.png', // ロゴのパス
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 20),
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
          _buildTigerTapeLine(), // 下部の虎テープ
        ],
      ),
    );
  }

  // 虎テープ（黄色と黒の斜めストライプ）を作成
  Widget _buildTigerTapeLine() {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/tiger_tape.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
