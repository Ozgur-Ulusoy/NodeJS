import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:worldflow/Data/Managers/InternetManager.dart';
import 'package:worldflow/Data/StateManagement/PostsPageState.dart';
import 'package:worldflow/Data/screenUtil.dart';

import '../Data/Consts/AppConstants.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFirstPage();
    });
  }

  Future<void> getFirstPage() async {
    await Provider.of<PostsPageState>(context, listen: false).reset();
    await InternetManager.getPostsByPage(0).then((value) {
      Provider.of<PostsPageState>(context, listen: false).addPosts(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConsts.backgroundColor,
      body: Center(
        child: Consumer<PostsPageState>(
          builder: (context, value, child) {
            return RefreshIndicator(
              semanticsLabel: 'Refresh',
              onRefresh: () {
                value.clearPosts();
                return getFirstPage();
                // return value.clearPosts();
              },
              child: LoadMore(
                // delegate: const DefaultLoadMoreDelegate(),
                // change default color
                isFinish: value.isFinish,
                // textBuilder: DefaultLoadMoreTextBuilder.english,
                // create custom textBuilder
                textBuilder: (status) {
                  if (status == LoadMoreStatus.fail) {
                    return 'Failed to load posts';
                  } else if (status == LoadMoreStatus.idle) {
                    return 'Load more posts';
                  } else if (status == LoadMoreStatus.loading) {
                    return 'Loading...';
                  } else if (status == LoadMoreStatus.nomore) {
                    return 'No more posts';
                  } else {
                    return '';
                  }
                },
                onLoadMore: () async {
                  value.page = value.page + 1;
                  bool canReload = true;
                  await InternetManager.getPostsByPage(value.page).then(
                    (val) {
                      if (val.isEmpty) {
                        value.page = value.page - 1;
                        canReload = false;
                        Provider.of<PostsPageState>(context, listen: false)
                            .setIsFinish(true);
                      } else {
                        Provider.of<PostsPageState>(context, listen: false)
                            .addPosts(val);
                        canReload = true;
                      }
                      // Provider.of<PostsPageState>(context, listen: false)
                      //     .addPosts(value);
                    },
                  );
                  return canReload;
                },
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: ScreenUtil.height * 0.08,
                      alignment: Alignment.center,
                      child: ListTile(
                        title: Text(
                          value.posts[index].title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          value.posts[index].comments.length.toString(),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    );
                  },
                  itemCount: value.posts.length,
                ),
              ),
            );
          },
        ),
      ),

      // Consumer<PostsPageState>(
      //   builder: (context, postsPageState, _) {
      //     return FutureBuilder(
      //       future: InternetManager.getPostsByPage(postsPageState.page),
      //       builder: (context, snapshot) =>
      //           NotificationListener<ScrollNotification>(
      //         onNotification: (ScrollNotification scrollInfo) {
      //           if (scrollInfo.metrics.pixels ==
      //               scrollInfo.metrics.maxScrollExtent) {
      //             postsPageState.setPage(postsPageState.page + 1);
      //           }
      //           if (snapshot.data != null) {
      //             postsPageState.addPosts(snapshot.data!);
      //           }

      //           return true;
      //         },
      //         child: ListView.builder(
      //           itemCount: postsPageState.posts.length,
      //           itemBuilder: (context, index) {
      //             return Container(
      //               margin: const EdgeInsets.all(10),
      //               padding: const EdgeInsets.all(10),
      //               decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 borderRadius: BorderRadius.circular(10),
      //               ),
      //               child: Column(
      //                 children: [
      //                   Text(postsPageState.posts[index].title),
      //                   // Text(postsPageState.posts[index].body),
      //                 ],
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
