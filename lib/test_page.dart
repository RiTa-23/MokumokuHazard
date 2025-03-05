import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // 作成したドキュメント一覧
  List<DocumentSnapshot> documentList = [];
  // 指定したドキュメントの情報
  String orderDocumentInfo = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: <Widget>[
          // ドキュメント作成ボタン
          ElevatedButton(
            child: Text('コレクション＋ドキュメント作成'),
            onPressed: () async {
              // ドキュメント作成
              await FirebaseFirestore.instance
                  .collection('users') // コレクションID
                  .doc() // ドキュメントID
                  .set({'name': 'hoge', 'marker_num': 0, 'id': 0}); // データ
              // 作成完了を知らせるSnackBarを表示
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ドキュメントが作成されました'),
                ),
              );
            },
          ),
          // ドキュメント一覧取得ボタン
          ElevatedButton(
            child: Text('ドキュメント一覧取得'),
            onPressed: () async {
              // コレクション内のドキュメント一覧を取得
              final snapshot =
                  await FirebaseFirestore.instance.collection('users').get();
              // 取得したドキュメント一覧をUIに反映
              setState(() {
                documentList = snapshot.docs;
              });
            },
          ),
          // コレクション内のドキュメント一覧を表示
          Column(
            children: documentList.map((document) {
              return ListTile(
                title: Text('${document['name']}さん'),
                subtitle: Text('マーカー数：${document['marker_num']}'),
              );
            }).toList(),
          ),
          // ドキュメントを指定して取得ボタン
          ElevatedButton(
            child: Text('ドキュメントを指定して取得'),
            onPressed: () async {
              // コレクションIDとドキュメントIDを指定して取得
              final document = await FirebaseFirestore.instance
                  .collection('markers')
                  .doc('test')
                  .collection('radii')
                  .doc('0')
                  .get();
              // 取得したドキュメントの情報をUIに反映
              setState(() {
                orderDocumentInfo = '${document['radius']}';
              });
            },
          ),
          // ドキュメントの情報を表示
          ListTile(title: Text(orderDocumentInfo)),
        ],
      )),
    );
  }
}
