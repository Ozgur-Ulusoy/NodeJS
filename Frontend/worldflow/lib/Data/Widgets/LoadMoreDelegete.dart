import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

class CustomLoadMoreDelegate extends LoadMoreDelegate {
  CustomLoadMoreDelegate();

  final double _loadmoreIndicatorSize = 33.0;

  @override
  Widget buildChild(LoadMoreStatus status,
      {LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.english}) {
    String text = builder(status);
    if (status == LoadMoreStatus.fail) {
      return Container(
          // child: Text(text, style: const TextStyle(color: Colors.white)),
          );
    }
    if (status == LoadMoreStatus.idle) {
      return Text(text, style: const TextStyle(color: Colors.white));
    }
    if (status == LoadMoreStatus.loading) {
      return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: _loadmoreIndicatorSize,
              height: _loadmoreIndicatorSize,
              child: const CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
    if (status == LoadMoreStatus.nomore) {
      // return Text(text);
      return const SizedBox();
    }

    return Text(text, style: const TextStyle(color: Colors.white));
  }
}
