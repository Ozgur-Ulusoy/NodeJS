import 'package:flutter/material.dart';
import 'package:worldflow/Data/Consts/AppConstants.dart';
import 'package:worldflow/Screens/postsPage.dart';
import 'package:worldflow/Screens/searchPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Widget page = const PostsPage();

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
            page = const PostsPage();
          } else if (value == 1) {
            page = const SearchPage();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
      body: page,
    );
  }
}
