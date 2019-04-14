import 'package:flutter/material.dart';

class TweetPage extends StatefulWidget {
  @override
  _TweetPage createState() => _TweetPage();
}

class _TweetPage extends State<TweetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("动弹"),
      ),
    );
  }
}
