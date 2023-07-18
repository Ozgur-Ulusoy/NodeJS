import 'package:flutter/material.dart';
import 'package:worldflow/Screens/homePage.dart';
import 'package:worldflow/Screens/loginPage.dart';
import 'package:worldflow/Screens/mainPage.dart';

import 'Data/Managers/HiveManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveGlobal.instance.initHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorldFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/main': (context) => const MainPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
      initialRoute: '/main',
    );
  }
}
