import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:mokumou_hazard/model/smoking_area_model.dart';
import 'package:mokumou_hazard/model/marker_model.dart';
import 'package:mokumou_hazard/view_model/marker_view_model.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
