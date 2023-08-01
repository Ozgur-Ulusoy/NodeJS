import 'package:flutter/material.dart';
import 'package:worldflow/Data/Models/post.dart';

class PostPage extends StatefulWidget {
  Post post;
  PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    print('---------------------------------');
    print('${widget.post.id} post id');
    print('-');
    print('${widget.post.comments.length} comments length');
    for (var item in widget.post.comments) {
      print('${item.commentid} comment id');
      print('${item.content} comment content');
      print('${item.ownerId} comment owner id');
      print('${item.comments.length} comment comments length');
      for (var item2 in item.comments) {
        print('a');
        print(item2?.commentid ?? 'commentid null');
        print(item2?.content);
        print(item2?.comments.length);
      }
    }
    return const Scaffold();
  }
}
