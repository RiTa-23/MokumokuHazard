import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'root_page.dart'; // 遷移先画面のインポート

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLogin = true;
  bool _isLoading = false; // 追加: ローディング状態を管理
  String email = '';
  String password = '';
  String infoText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'ログイン' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
    
      alignment: Alignment.topCenter, // テキストを画像の上部に配置
      children: [
        Image.asset(
          'assets/logo.png', // 画像のパス
          width: 150, // 幅を指定
          height: 150, // 高さを指定
        ),
        Positioned(
          top:1, // 上部に配置（適宜調整）
          child: Text(
            'もくもくハザード', // 表示するテキスト
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 173, 73, 31), // 文字色
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black, // 影の色
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    SizedBox(height: 20),

            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            SizedBox(height: 20),

            // ローディング中ならインジケーターを表示
            _isLoading
                ? CircularProgressIndicator() // ローディングアニメーション
                : ElevatedButton(
                    onPressed: _isLoading ? null : _handleAuth, // ログイン処理
                    child: Text(_isLogin ? 'ログイン' : 'Register'),
                  ),

            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
              child: Text(_isLogin
                  ? 'Create an account'
                  : 'Already have an account? Login'),
            ),
            Text(infoText),
          ],
        ),
      ),
    );
  }

  // ログイン / 登録処理
  Future<void> _handleAuth() async {
    setState(() {
      _isLoading = true; // ローディング開始
      infoText = ''; // メッセージをリセット
    });

    try {
      if (_isLogin) {
        // ログイン処理
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // アカウント登録処理
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      // 成功時: 画面遷移
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RootPage()),
      );
    } catch (e) {
      // エラー時: メッセージを表示
      setState(() {
        infoText = 'エラー: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false; // ローディング終了
      });
    }
  }
}

