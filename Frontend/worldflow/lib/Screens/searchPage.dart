import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worldflow/Data/Consts/AppConstants.dart';
import 'package:worldflow/Data/Managers/InternetManager.dart';
import 'package:worldflow/Data/StateManagement/SearchPageState.dart';
import 'package:worldflow/Data/Widgets/PostCard.dart';
import 'package:worldflow/Data/screenUtil.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchPageState>(context, listen: false).reset();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConsts.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: ScreenUtil.height * 0.01),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil.width * 0.02),
              child: SearchBar(
                controller: searchController,
                onChanged: (value) async {
                  var datas = await InternetManager.searchPosts(value);
                  Provider.of<SearchPageState>(context, listen: false)
                      .setPosts(datas);
                },
              ),
            ),
            Consumer<SearchPageState>(
              builder: (context, value, widget) => Expanded(
                child: ListView.builder(
                  itemCount: value.posts.length,
                  itemBuilder: (context, index) {
                    // return PostCard(
                    //   post: snapshot.data![index],
                    return PostCard(post: value.posts[index]);
                  },
                ),
              ),
            )
            // SearchResults(),
          ],
        ),
      ),
    );
  }
}
