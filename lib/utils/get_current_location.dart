import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

Future<Position?> getCurrentLocation(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // 位置情報サービスが有効かどうかを確認
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // 位置情報サービスが無効の場合、エラーメッセージを表示
    print('位置情報サービスが無効です。');
    return null;
  }

  // 位置情報の権限をリクエスト
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // 位置情報の権限が拒否された場合、エラーメッセージを表示
      print('位置情報の権限が拒否されました。');
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // 位置情報の権限が永久に拒否された場合、エラーメッセージを表示
    print('位置情報の権限が永久に拒否されました。');
    return null;
  }

  // 位置情報を取得
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return position;
}
