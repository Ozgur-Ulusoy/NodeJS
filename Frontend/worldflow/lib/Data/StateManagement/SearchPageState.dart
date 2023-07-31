import 'package:flutter/material.dart';
import 'package:worldflow/Data/Models/post.dart';

class SearchPageState extends ChangeNotifier {
  List<Post> posts = [];

  Future<void> reset() async {
    posts.clear();
    notifyListeners();
  }

  void addPost(Post newPost) {
    posts.add(newPost);
    notifyListeners();
  }

  void setPosts(List<Post> newPosts) {
    posts.clear();
    posts.addAll(newPosts);
    notifyListeners();
  }

  Future<void> clearPosts() async {
    posts.clear();
    notifyListeners();
  }
}
