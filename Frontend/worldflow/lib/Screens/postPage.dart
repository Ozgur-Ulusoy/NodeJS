import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class PostPage extends StatefulWidget {
  Post post;
  PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    // print('---------------------------------');
    // print('${widget.post.id} post id');
    // print('-');
    // print('${widget.post.comments.length} comments length');
    // for (var item in widget.post.comments) {
    //   print('${item.commentid} comment id');
    //   print('${item.content} comment content');
    //   print('${item.ownerId} comment owner id');
    //   print('${item.comments.length} comment comments length');
    //   for (var item2 in item.comments) {
    //     print('a');
    //     print(item2?.commentid ?? 'commentid null');
    //     print(item2?.content);
    //     print(item2?.comments.length);
    //   }
    // }
    return WillPopScope(
      onWillPop: () async {
        await Provider.of<PostsPageState>(context, listen: false)
            .getFirstPage();
        return true;
      },
      child: Scaffold(
        // appbar with left arrow back button
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.post.title,
            maxLines: 2,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: AppConsts.backgroundColor,
          onPressed: () async {
            //ıı
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
            slivers: [
              const SliverAppBar(
                pinned: true,
                leading: SizedBox(),
              ),
              SliverToBoxAdapter(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => CommentCard(
                      comment:
                          Provider.of<PostPageState>(context).comments[index]),
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
