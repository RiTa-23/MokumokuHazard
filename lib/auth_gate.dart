import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sample_page.dart'; // 遷移先画面のインポート

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLogin = true;
  String email = '';
  String password = '';
  String infoText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            ElevatedButton(
              onPressed: () async {
                if (_isLogin) {
                  // ログイン処理
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SamplePage()),
                    );
                  } catch (e) {
                    setState(() {
                      infoText = 'ログインに失敗しました: ${e.toString()}';
                    });
                  }
                } else {
                  // アカウント登録処理
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SamplePage()),
                    );
                  } catch (e) {
                    setState(() {
                      infoText = '登録に失敗しました: ${e.toString()}';
                    });
                  }
                }
              },
              child: Text(_isLogin ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed: () {
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
}
