import 'package:flutter/material.dart';
import 'package:worldflow/Data/Models/comment.dart';
import 'package:worldflow/Data/Models/post.dart';

class PostPageState extends ChangeNotifier {
  int page = 0;
  int postPerPage = 10;

  Post? post;
  List<Comment> comments = [];

  void SetPagePerPage(int index) {
    page = (index / postPerPage).toInt();
    notifyListeners();
  }

  int returnCommentsPageLength() {
    return (comments.length / postPerPage).toInt();
  }

  Future<void> reset() async {
    page = 0;
    post = null;
    comments.clear();
    notifyListeners();
  }

  // update comment
  void updateComment(String commentid, Map<String, dynamic> map) {
    // convert List<dynamic> to List<String

    Comment comment =
        comments.firstWhere((element) => element.commentid == commentid);
    comment.likes = List<String>.from(map['likes'] as List);

    comment.dislikes = List<String>.from(map['dislikes'] as List);
    notifyListeners();
  }

  void setPost(Post newPost) {
    post = newPost;
    notifyListeners();
  }

  void setPage(int newPage) {
    page = newPage;
    notifyListeners();
  }

  void addComment(Comment newComment) {
    comments.add(newComment);
    if (post != null) {
      post!.comments.add(newComment);
    }
    notifyListeners();
  }

  void addComments(List<Comment> newComments) {
    comments.addAll(newComments);
    notifyListeners();
  }

  Future<void> clearComments() async {
    comments.clear();
    notifyListeners();
  }
}
