import 'package:flutter/material.dart';
import 'package:worldflow/Data/Consts/LocalDatabaseConstants.dart';
import 'package:worldflow/Data/Managers/InternetManager.dart';
import 'package:worldflow/Data/Models/LocalDatabaseModels/UserModel.dart';
import 'package:worldflow/Screens/loadingPage.dart';
import 'package:worldflow/Screens/loginPage.dart';

import '../Data/Managers/HiveManager.dart';
import '../Data/screenUtil.dart';
import 'homePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget page = const LoadingPage();

  Future<Widget> getPage() async {
    UserModel? user =
        await HiveGlobal.instance.getData(LocalDatabaseConstants.USER);

    if (user != null && await InternetManager.checkSession(user.token)) {
      return const HomePage();
    } else {
      // await Navigator.pushNamed(context, '/login');
      await HiveGlobal.instance.deleteData(LocalDatabaseConstants.USER);
      return const LoginPage();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPage().then((value) {
      setState(() {
        page = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return page;
  }
}
