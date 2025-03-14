import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mokumou_hazard/model/user_model.dart';

class UserViewModel extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  Future<void> loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        _user = UserModel.fromDocument(doc);
        notifyListeners();
      }
    }
  }

  Future<void> saveUser(
      {String? name, String? backgroundImage, File? profileImage}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = {
        'name': name ?? _user?.name,
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));
      _user = UserModel(
        id: user.uid,
        name: userData['name'],
      );
      notifyListeners();
    }
  }
}
