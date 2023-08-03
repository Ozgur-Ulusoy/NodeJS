class Comment {
  // String commentid;
  String? commentid;
  String content;
  String ownerId;
  String ownerName;
  DateTime createdAt;
  List<String> likes;
  List<String> dislikes;
  List<Comment?> comments;

  Comment({
    required this.commentid,
    required this.content,
    required this.ownerId,
    required this.ownerName,
    required this.createdAt,
    required this.likes,
    required this.dislikes,
    required this.comments,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    List<Comment?> comments = [];
    List<String> likes = [];
    List<String> dislikes = [];

    if (json['comments'] == null) {
      // print('comments is null');
    } else {
      var tempComments =
          json['comments'] == null ? [] : json['comments'] as List<dynamic>;
      comments = tempComments.map((e) => Comment.fromJson(e)).toList();
    }

    var tempLikes = json['interactions']['likes'] as List<dynamic>;
    likes = tempLikes.map((e) => e.toString()).toList();

    var tempDislikes = json['interactions']['dislikes'] as List<dynamic>;
    dislikes = tempDislikes.map((e) => e.toString()).toList();

    return Comment(
      commentid: json['_id'],
      content: json['content'],
      ownerId: json['ownerId'],
      ownerName: json['ownerName'],
      createdAt: DateTime.parse(json['time']),
      likes: likes,
      dislikes: dislikes,
      comments: comments,
    );
  }
}
