import 'package:dio/dio.dart';
import 'package:worldflow/Data/Models/post.dart';
import 'package:worldflow/Data/Models/user.dart';

class InternetManager {
  // make a singleton
  static final InternetManager _instance = InternetManager._internal();
  factory InternetManager() => _instance;
  InternetManager._internal();
  static final Dio dio = Dio();

  static const String _baseUrl = 'http://10.0.2.2:3000/api/';
  static const String _authUrl = '${_baseUrl}auth/';
  static const String _postUrl = '${_baseUrl}post/';

  //! Auth API
  static Future<User?> login(
      String username, String email, String password) async {
    String url = '${_authUrl}login';

    try {
      Response response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'username': username,
            'email': email,
            'password': password,
          },
        ),
      );
      return User.fromJson(response.data['user']);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> logout(String token) async {
    String url = '${_authUrl}logout';

    try {
      Response response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          },
        ),
      );
      return response.data['success'];
    } catch (e) {
      return false;
    }
  }

  static Future<bool> checkSession(String token) async {
    String url = '${_authUrl}checkSession';

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          },
        ),
      );
      return response.data['success'];
    } catch (e) {
      return false;
    }
  }

  static Future<void> sendEmailVerify(String email, String username) async {
    String url = '${_authUrl}sendVerifyEmail';

    try {
      Response response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'email': email,
            'username': username,
          },
        ),
      );
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  static Future<Map<String, dynamic>> sendResetPasswordEmail(
      {required String email, password}) async {
    String url = '${_authUrl}sendResetPasswordEmail';

    try {
      Response response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'email': email,
            'password': password,
          },
        ),
      );
      print(response.data);
      return response.data;
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': 'Something went wrong',
      };
    }
  }

  //! Post API

  //! Create Post
  static Future<Post?> createPost(
      {required String title,
      required String content,
      required String ownerid,
      required String token}) async {
    String url = '${_postUrl}create';

    try {
      Response response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'token': token,
            'title': title,
            'content': content,
            'ownerid': ownerid,
          },
        ),
      );
      return Post.fromJson(response.data['post']);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Post>> getRandomPosts(int count) async {
    String url = '${_postUrl}getRandomPostByCount';

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'count': count,
          },
        ),
      );
      // return list of posts from response
      print(response.data['posts']);
      List<Post> posts = [];
      response.data['posts'].forEach((post) {
        posts.add(Post.fromJson(post));
      });
      return posts;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //! Get Post by Page
  static Future<List<Post>> getPostsByPage(int page) async {
    String url = '${_postUrl}getPostsByPage';

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'page': page,
            'limit': 20,
          },
        ),
      );
      // return list of posts from response
      // print(response.data['posts']);
      List<Post> posts = [];
      response.data['posts'].forEach((post) {
        if (post != null) posts.add(Post.fromJson(post));
      });
      return posts;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //! Get Post by Title
  static Future<List<Post>> searchPosts(String title) async {
    String url = '${_postUrl}getPostsByTitle';

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'title': title,
            'limit': 15,
          },
        ),
      );
      // return list of posts from response
      // print(response.data['posts']);
      List<Post> posts = [];
      response.data['posts'].forEach((post) {
        if (post != null) posts.add(Post.fromJson(post));
      });
      return posts;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
