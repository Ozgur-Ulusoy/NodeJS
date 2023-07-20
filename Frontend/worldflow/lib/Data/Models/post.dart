import 'comment.dart';

class Post {
  String id;
  String title;
  String content;
  String ownerId;
  List<Comment> comments;
  List<String> likes;
  List<String> dislikes;
  String createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.ownerId,
    required this.comments,
    required this.likes,
    required this.dislikes,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<Comment> comments = [];
    if (json['comments'] != null) {
      json['comments']
          .map((comment) => comments.add(Comment.fromJson(comment)));
    }
    List<String> likes = [];
    if (json['interactions']['likes'] != null) {
      json['interactions']['likes'].map((like) => likes.add(like.toString()));
    }
    List<String> dislikes = [];
    if (json['interactions']['dislikes'] != null) {
      json['interactions']['dislikes']
          .map((dislike) => dislikes.add(dislike.toString()));
    }

    return Post(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      ownerId: json['ownerId'],
      comments: comments,
      likes: likes,
      dislikes: dislikes,
      createdAt: json['time'],
    );
  }
}
