import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeromark/providers/fromFB.dart';
import 'package:zeromark/screens/ar.dart';
import 'package:provider/provider.dart';
import 'package:zeromark/screens/homeScreen.dart';
import 'package:zeromark/screens/selectionScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TopicProvider>(
          create: (_) => TopicProvider(),
        ),
      ],
      child: MaterialApp(
        title: "Zero Mark",
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        routes: {
          ARPage.route: (context) => ARPage(),
          SelectionScreen.route: (context) => SelectionScreen(),
        },
      ),
    );
  }
}
