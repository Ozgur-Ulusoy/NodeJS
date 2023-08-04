import 'package:flutter/material.dart';
import 'package:worldflow/Data/Managers/InternetManager.dart';
import 'package:worldflow/Data/Models/post.dart';

class PostsPageState extends ChangeNotifier {
  int page = 0;
  int maxPage = 5;
  List<Post> posts = [];
  bool isFinish = false;

  Future<void> reset() async {
    page = 0;
    posts.clear();
    isFinish = false;
    notifyListeners();
  }

  Future<void> getFirstPage() async {
    await reset();
    await InternetManager.getPostsByPage(0).then((value) {
      addPosts(value);
    });
    notifyListeners();
  }

  void updatePost(Post post) async{
    print(post.comments.length);
      for (var i = 0; i < posts.length; i++) {
        if (posts[i].id == post.id){
          posts[i] = post;
        }
      }
      notifyListeners();
  }

  void setIsFinish(bool newIsFinish) {
    isFinish = newIsFinish;
    notifyListeners();
  }

  void setPage(int newPage) {
    if (newPage > maxPage) {
      isFinish = true;
      notifyListeners();
      return;
    }
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
