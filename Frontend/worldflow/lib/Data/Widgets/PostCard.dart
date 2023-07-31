import 'package:flutter/material.dart';
import 'package:worldflow/Data/Models/post.dart';
import 'package:worldflow/Data/screenUtil.dart';

class PostCard extends StatefulWidget {
  Post post;
  PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
