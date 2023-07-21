class Comment {
  String content;
  String ownerId;
  String createdAt;
  List<String> likes;
  List<String> dislikes;
  List<Comment?> comments;

  Comment({
    required this.content,
    required this.ownerId,
    required this.createdAt,
    required this.likes,
    required this.dislikes,
    required this.comments,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    List<Comment?> comments = [];
    List<String> likes = [];
    List<String> dislikes = [];

    var tempComments = json['comments'] as List<dynamic>;
    comments = tempComments.map((e) => Comment.fromJson(e)).toList();

    var tempLikes = json['interactions']['likes'] as List<dynamic>;
    likes = tempLikes.map((e) => e.toString()).toList();

    var tempDislikes = json['interactions']['dislikes'] as List<dynamic>;
    dislikes = tempDislikes.map((e) => e.toString()).toList();

    return Comment(
      content: json['content'],
      ownerId: json['ownerId'],
      createdAt: json['time'],
      likes: likes,
      dislikes: dislikes,
      comments: comments,
    );
  }
}
