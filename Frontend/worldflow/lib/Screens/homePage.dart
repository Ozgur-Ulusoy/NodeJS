import 'package:flutter/material.dart';
import 'package:worldflow/Data/Consts/AppConstants.dart';
import 'package:worldflow/Data/Managers/InternetManager.dart';
import 'package:worldflow/Data/Models/post.dart';
import 'package:worldflow/Screens/postsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Widget page = Scaffold(
    backgroundColor: AppConsts.backgroundColor,
    body: const Center(
      child: Text(
        'HOME PAGE',
        style: TextStyle(
          fontSize: 50,
          color: Colors.white,
        ),
      ),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // InternetManager.getRandomPosts(3).then((value) {
    //   print(value);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConsts.backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) async {
          setState(
            () {
              _selectedIndex = value;
            },
          );
          if (value == 0) {
            page = PostsPage();
          } else if (value == 1) {
            page = Scaffold(
              backgroundColor: AppConsts.backgroundColor,
              body: const Center(
                child: Text(
                  'PROFILE PAGE',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: page,
    );
  }
}
