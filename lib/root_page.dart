import 'package:flutter/material.dart';
import 'package:mokumou_hazard/map_page.dart';
import 'package:mokumou_hazard/post_page.dart';
import 'package:mokumou_hazard/test_page.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_gate.dart';

/// ボトムナビゲーションを実装
/// 下記ページを切り替えるページ
/// - マップページ
/// - マーカー作成
/// - プロフィールページ

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    String appBarTitle;
    switch (_selectedIndex) {
      case 0:
        page = const MapPage();
        appBarTitle = 'Map Page';
        break;
      case 1:
        page = const PostPage();
        appBarTitle = 'Post Page';
        break;
      default:
        page = const TestPage();
        appBarTitle = 'Test Page';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          appBarTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,color: Colors.white,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }),
        ],
      ),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'map'),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: 'post'),
          BottomNavigationBarItem(
              icon: Icon(Icons.data_array), label: 'forTest'),
        ],
      ),
    );
  }
}
