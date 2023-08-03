import 'comment.dart';

class Post {
  String id;
  String title;
  String ownerId;
  String ownerName;
  List<Comment> comments;
  List<String> likes;
  List<String> dislikes;
  DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.ownerId,
    required this.ownerName,
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
      ownerId: json['ownerId'],
      ownerName: json['ownerName'],
      comments: comments,
      likes: likes,
      dislikes: dislikes,
      // convert string to DateTime
      createdAt: DateTime.parse(json['time']),
      // createdAt: json['time'],
    );
  }
}
