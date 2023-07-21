import 'package:flutter/material.dart';
import 'package:worldflow/Data/Consts/AppConstants.dart';
import 'package:worldflow/Data/Managers/InternetManager.dart';
import 'package:worldflow/Data/Models/post.dart';

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
            page = Scaffold(
              backgroundColor: AppConsts.backgroundColor,
              body: Center(
                  child: StreamBuilder<List<Post>>(
                stream: InternetManager.getRandomPosts(3).asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        // print users token
                        return GestureDetector(
                          onTap: () {
                            print(snapshot.data![index].id);
                            print(snapshot.data![index].title);
                            print(snapshot.data![index].content);
                            print(snapshot.data![index].ownerId);
                            print(snapshot.data![index].comments);
                            print(
                                '${snapshot.data![index].likes.length} likes');
                            print(
                                '${snapshot.data![index].dislikes.length} dislikes');
                            print(
                                '${snapshot.data![index].createdAt} created at');
                            print('-------------------');
                          },
                          child: ListTile(
                            title: Text(snapshot.data![index].title),
                            subtitle: Text(snapshot.data![index].content),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
            );
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
