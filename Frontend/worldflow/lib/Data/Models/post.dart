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
    // print('likes : ');
    // print(json['interactions']['likes']);

    List<Comment> comments = [];
    List<String> likes = [];
    List<String> dislikes = [];

    var tempComments = json['comments'] as List<dynamic>;
    comments = tempComments.map((e) => Comment.fromJson(e)).toList();

    var tempLikes = json['interactions']['likes'] as List<dynamic>;
    likes = tempLikes.map((e) => e.toString()).toList();

    var tempDislikes = json['interactions']['dislikes'] as List<dynamic>;
    dislikes = tempDislikes.map((e) => e.toString()).toList();

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
