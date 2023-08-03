import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worldflow/Data/Consts/LocalDatabaseConstants.dart';
import 'package:worldflow/Data/Managers/HiveManager.dart';
import 'package:worldflow/Data/Managers/InternetManager.dart';
import 'package:worldflow/Data/Models/LocalDatabaseModels/UserModel.dart';
import 'package:worldflow/Data/Models/comment.dart';
import 'package:worldflow/Data/StateManagement/PostPage.dart';

class CommentCard extends StatefulWidget {
  Comment comment;
  CommentCard({super.key, required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(widget.comment.content),
          ),
          // create container for like - dislike button
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () async {
                    //ıı
                    UserModel user = await HiveGlobal.instance
                        .getData(LocalDatabaseConstants.USER) as UserModel;

                    Map<String, dynamic> res =
                        await InternetManager.interactCommment(
                            Provider.of<PostPageState>(context, listen: false)
                                .post!
                                .id,
                            widget.comment.commentid,
                            user.id,
                            'like',
                            user.token);
                    if (res != {}) {
                      Provider.of<PostPageState>(context, listen: false)
                          .updateComment(widget.comment.commentid!, res);
                    }
                  },
                  icon: const Icon(Icons.thumb_up),
                ),
                Text(
                  widget.comment.likes.length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () async {
                    //ıı
                  },
                  icon: const Icon(Icons.thumb_down),
                ),
                Text(
                  widget.comment.dislikes.length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      // createdAt to h:m:s dd/mm/yyyy format string
                      '${widget.comment.createdAt.toLocal().toString().split('.')[0].split(' ')[1]}   ${widget.comment.createdAt.toLocal().toString().split('.')[0].split(' ')[0]}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.comment.ownerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
