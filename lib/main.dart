import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:mokumou_hazard/model/smoking_area_model.dart';
import 'package:mokumou_hazard/model/marker_model.dart';
import 'package:mokumou_hazard/view_model/marker_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/root_page.dart';
//import 'utils/data_upload.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SmokingAreaListModel()),
        ChangeNotifierProvider(create: (_) => MarkerListModel()),
        ChangeNotifierProxyProvider2<SmokingAreaListModel, MarkerListModel,
            MarkerViewModel>(
          create: (context) => MarkerViewModel(
            smokingAreaListModel: context.read<SmokingAreaListModel>(),
            markerListModel: context.read<MarkerListModel>(),
          ),
          update: (context, smokingModel, markerModel, markerVM) =>
              markerVM!..loadAllMarkers(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          return RootPage();
        } else {
          //return DataUploadPage();
          return LoginPage();
        }
      },
    );
  }

  Future<User?> _checkLoginStatus() async {
    return FirebaseAuth.instance.currentUser;
  }
}
