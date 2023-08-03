import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worldflow/Data/Consts/LocalDatabaseConstants.dart';
import 'package:worldflow/Data/Managers/HiveManager.dart';
import 'package:worldflow/Data/Models/LocalDatabaseModels/UserModel.dart';
import 'package:worldflow/Data/Models/post.dart';
import 'package:worldflow/Data/StateManagement/PostPage.dart';
import 'package:worldflow/Data/screenUtil.dart';
import 'package:worldflow/Screens/postPage.dart';

class PostCard extends StatefulWidget {
  Post post;
  PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        UserModel user = await HiveGlobal.instance
            .getData(LocalDatabaseConstants.USER) as UserModel;

        print(user.token);
        // print(widget.post.comments.length);
        // print(widget.post.title);
        // print(widget.post.content);
        // print(widget.post.id);
        // print(widget.post.ownerId);

        Provider.of<PostPageState>(context, listen: false).reset();

        Provider.of<PostPageState>(context, listen: false).setPost(
          widget.post,
        );

        Provider.of<PostPageState>(context, listen: false).addComments(
          widget.post.comments,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostPage(post: widget.post),
          ),
        );
      },
      child: Container(
        height: ScreenUtil.height * 0.08,
        alignment: Alignment.center,
        child: ListTile(
          title: Text(
            widget.post.title,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Text(
            widget.post.comments.length.toString(),
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
