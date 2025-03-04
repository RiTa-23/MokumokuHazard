# もくもくハザード
[Notion_もくもくハザード](https://ionized-kiwi-2bf.notion.site/1ac9283b1c15808aab06ebcc723b544d)
> ↑のNotionに大体の環境構築、参考資料等、情報まとめてます
## 概要
### プロダクト概要
課題：北九州はスモーカーが多い→もくもく（副流煙）を避けたい！  
解決案：喫煙者・喫煙所・路上喫煙が多い地点を把握する  
開発するアプリ：喫煙者出没ハザードマップ

### メンバー
- リタ
- ひなQ
- レック

## 環境構築
1. リポジトリをクローン
```
git clone https://github.com/DIGIT-KITAQ-Flutter/MokumokuHazard.git
```
1. プロジェクトディレクトリに移動
```
cd mokumoku_hazard
```
2. パッケージのインストール
```
flutter pub get
```
3. android/secret.properties追加
4. lib/env/env.g.dart追加

## デバッグ
```
flutter run
```

### Flutterのコマンド一覧
```
Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).
```

## commitのルール
### commit書き方
```
接頭辞:やったこと
```
### 接頭辞
- add ... 新機能
- update ... 修正、変更
- remove ... 削除
- wip
### ex.
```
add:ログイン機能追加
```

## ブランチ名のルール
### ブランチ名書き方
```
接頭辞/担当者/やること
```
### 接頭辞
- feature ... 機能追加
- fix ... バグ修正
### ex.
```
feature/rita/create_login_ui
```
## 参考資料まとめ
https://ionized-kiwi-2bf.notion.site/1ac9283b1c15800c9cd1d078527d2ae3

## トラブルと解決方法
https://www.notion.so/1ac9283b1c1580828673e2c21d7f16bd
