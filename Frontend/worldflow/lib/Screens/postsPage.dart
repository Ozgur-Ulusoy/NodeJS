import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:worldflow/Data/Consts/LocalDatabaseConstants.dart';
import 'package:worldflow/Data/Managers/HiveManager.dart';
import 'package:worldflow/Data/Managers/InternetManager.dart';
import 'package:worldflow/Data/Models/LocalDatabaseModels/UserModel.dart';
import 'package:worldflow/Data/Models/post.dart';
import 'package:worldflow/Data/StateManagement/PostsPageState.dart';
import 'package:worldflow/Data/Widgets/LoadMoreDelegete.dart';
import 'package:worldflow/Data/Widgets/PostCard.dart';
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
      // getFirstPage();
      Provider.of<PostsPageState>(context, listen: false).getFirstPage();
    });
  }

  // Future<void> getFirstPage() async {
  //   await Provider.of<PostsPageState>(context, listen: false).reset();
  //   await InternetManager.getPostsByPage(0).then((value) {
  //     Provider.of<PostsPageState>(context, listen: false).addPosts(value);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: AppConsts.backgroundColor,
        onPressed: () {
          // getFirstPage();
          // showdialog
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController titleController = TextEditingController();
              TextEditingController contentController = TextEditingController();

              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: ScreenUtil.height * 0.01),
                    // title and content textfield and button
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.width * 0.02),
                      child: TextField(
                        controller: titleController,
                        maxLength: 60,
                        decoration: const InputDecoration(
                          hintText: 'Title',
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil.height * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.width * 0.02),
                      child: TextField(
                        controller: contentController,
                        maxLength: 999,
                        decoration: const InputDecoration(
                          hintText: 'Content',
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil.height * 0.01),

                    ElevatedButton(
                      onPressed: () async {
                        UserModel user = await HiveGlobal.instance
                            .getData(LocalDatabaseConstants.USER);

                        Post? post = await InternetManager.createPost(
                          title: titleController.text,
                          content: contentController.text,
                          ownerid: user.id,
                          token: user.token,
                        );
                        if (post != null) {
                          Provider.of<PostsPageState>(context, listen: false)
                              .addPost(post);
                        }
                        // await getFirstPage();
                        Navigator.pop(context);
                      },
                      child: const Text('Post'),
                    ),
                    SizedBox(height: ScreenUtil.height * 0.01),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: AppConsts.backgroundColor,
      body: Center(
        child: Consumer<PostsPageState>(
          builder: (context, value, child) {
            return RefreshIndicator(
              semanticsLabel: 'Refresh',
              onRefresh: () {
                value.clearPosts();
                // return getFirstPage();
                return Provider.of<PostsPageState>(context, listen: false)
                    .getFirstPage();

                // return value.clearPosts();
              },
              child: LoadMore(
                delegate: CustomLoadMoreDelegate(),
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
                  value.setPage(value.page + 1);
                  // bool canReload = true;
                  await InternetManager.getPostsByPage(value.page).then(
                    (val) {
                      if (val.isEmpty) {
                        value.page = value.page - 1;
                        // canReload = false;
                        value.setIsFinish(true);
                      } else {
                        value.addPosts(val);
                        // canReload = true;
                      }
                      // Provider.of<PostsPageState>(context, listen: false)
                      //     .addPosts(value);
                    },
                  );
                  return value.isFinish == false;
                },
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return PostCard(post: value.posts[index]);
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
