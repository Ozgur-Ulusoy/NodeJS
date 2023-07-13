import 'package:flutter/material.dart';
import 'package:worldflow/Screens/loginPage.dart';

import '../Data/screenUtil.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return LoginPage();
  }
}
