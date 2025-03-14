import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String info;
  final String markerId;
  final double latitude;
  final double longitude;
  final int riskLevel;
  final double radius;
  final VoidCallback onDelete;

  const InfoItem({
    Key? key,
    required this.icon,
    required this.info,
    required this.markerId,
    required this.latitude,
    required this.longitude,
    required this.riskLevel,
    required this.radius,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Row(
        children: [
          Spacer(),
          Icon(icon, color: Colors.grey[700]),
          SizedBox(width: 10),
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              width: 250,
              child: Column(
                children: [
                  Text(info, style: TextStyle(fontSize: 15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, color: Colors.blue, size: 15),
                      Text('半径:$radius', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning, color: Colors.red, size: 15),
                      Text('危険度:$riskLevel', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  Text('緯度:$latitude', style: TextStyle(fontSize: 10)),
                  Text('経度:$longitude', style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete, // 削除ボタンを押してマーカーを削除
          ),
        ],
      ),
    );
  }
}
