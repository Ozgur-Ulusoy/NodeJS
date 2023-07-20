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
