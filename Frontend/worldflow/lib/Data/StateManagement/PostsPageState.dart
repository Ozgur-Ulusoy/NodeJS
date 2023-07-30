import 'package:flutter/material.dart';
import 'package:worldflow/Data/Models/post.dart';

class PostsPageState extends ChangeNotifier {
  int page = 0;
  List<Post> posts = [];
  bool isFinish = false;

  Future<void> reset() async {
    page = 0;
    posts.clear();
    isFinish = false;
    notifyListeners();
  }

  void setIsFinish(bool newIsFinish) {
    isFinish = newIsFinish;
    notifyListeners();
  }

  void setPage(int newPage) {
    page = newPage;
    notifyListeners();
  }

  void addPost(Post newPost) {
    posts.add(newPost);
    notifyListeners();
  }

  void addPosts(List<Post> newPosts) {
    posts.addAll(newPosts);
    notifyListeners();
  }

  Future<void> clearPosts() async {
    posts.clear();
    notifyListeners();
  }
}
