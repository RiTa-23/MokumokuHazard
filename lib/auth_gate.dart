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
      backgroundColor: Colors.blue[100], // 背景色
      body: Center(
        child: Card(
          elevation: 8, // 影の強さ
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // 角を丸くする
          ),
          margin: EdgeInsets.symmetric(horizontal: 20), // 余白
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 必要最小限の高さ
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'もくもくハザード',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 173, 73, 31),
                            //shadows: [
                              //Shadow(
                                //blurRadius: 5.0,
                                //color: Colors.black,
                                //offset: Offset(2, 2),
                              //),
                            //],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(), // 枠線を追加
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator() // ローディングアニメーション
                    : ElevatedButton(
                        onPressed: _isLoading ? null : _handleAuth,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // ボタン色
                          minimumSize: Size(250, 50),//loginボタンのサイズ
                          padding: EdgeInsets.symmetric(vertical: 12),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                       child: Text(
    _isLogin ? 'Login' : 'Register',
    style: TextStyle(color: const Color.fromARGB(255, 249, 249, 249)), // loginの文字色
  ),
),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                  child: Text(
                    _isLogin ? 'Create an account' : 'Already have an account? Login',
                  ),
                ),
                if (infoText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      infoText,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
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

