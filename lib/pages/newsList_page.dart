import 'package:flutter/material.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPage createState() => _NewsListPage();
}

class _NewsListPage extends State<NewsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("资讯"),
      ),
    );
  }
}
