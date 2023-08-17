import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:worldflow/Data/Consts/AppConstants.dart';
import 'package:worldflow/Data/Consts/LocalDatabaseConstants.dart';
import 'package:worldflow/Data/Managers/HiveManager.dart';
import 'package:worldflow/Data/Managers/InternetManager.dart';
import 'package:worldflow/Data/Models/LocalDatabaseModels/UserModel.dart';
import 'package:worldflow/Data/Models/post.dart';
import 'package:worldflow/Data/StateManagement/PostPage.dart';
import 'package:worldflow/Data/StateManagement/PostsPageState.dart';
import 'package:worldflow/Data/Widgets/CommentCard.dart';
import 'package:worldflow/Data/screenUtil.dart';

import '../Data/Models/comment.dart';

// ignore: must_be_immutable
class PostPage extends StatefulWidget {
  Post post;
  PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // await Provider.of<PostsPageState>(context, listen: false)
        //     .getFirstPage();
        Provider.of<PostsPageState>(context, listen: false).updatePost(
            Provider.of<PostPageState>(context, listen: false).post!);
        print('object');
        return true;
      },
      child: Scaffold(
        // appbar with left arrow back button
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Provider.of<PostsPageState>(context, listen: false).updatePost(
                    Provider.of<PostPageState>(context, listen: false).post!);
                Navigator.of(context).pop();
                print('object');
              }),
          title: Text(
            widget.post.title,
            maxLines: 2,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: AppConsts.backgroundColor,
          onPressed: () async {
            // SHOW DIALOG
            showDialog(
                context: context,
                builder: (context) {
                  TextEditingController controller = TextEditingController();
                  return AlertDialog(
                    // SHOW DIALOG
                    title: const Text('Add Comment'),
                    content: TextField(
                      maxLength: 999,
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Comment',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          UserModel user = await HiveGlobal.instance
                                  .getData(LocalDatabaseConstants.USER)
                              as UserModel;
                          Comment? comment =
                              await InternetManager.createComment(
                                  widget.post.id,
                                  controller.text,
                                  user.id,
                                  user.token);
                          print(comment);

                          if (comment != null) {
                            Provider.of<PostPageState>(context, listen: false)
                                .addComment(comment);
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
        backgroundColor: AppConsts.backgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            controller: controller,
            slivers: [
              SliverAppBar(
                pinned: true,
                centerTitle: true,
                leading: SizedBox(),
                title: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // button to go to the up
                    IconButton(
                      onPressed: () {
                        controller.animateTo(
                          controller.position.minScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                    Consumer<PostPageState>(
                      builder: (context, state, child) {
                        return Text(
                          'Page ' + (state.page + 1).toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    // button to go to the down
                    IconButton(
                      onPressed: () {
                        controller.animateTo(
                          controller.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // print offsest of the index item

                    return VisibilityDetector(
                      key: Key(index.toString()),
                      onVisibilityChanged: (VisibilityInfo info) {
                        if (info.visibleFraction == 1)
                          Provider.of<PostPageState>(context, listen: false)
                              .SetPagePerPage(index);
                      },
                      child: CommentCard(
                          comment: Provider.of<PostPageState>(context)
                              .comments[index]),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount:
                      Provider.of<PostPageState>(context).comments.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: ScreenUtil.height * 0.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
