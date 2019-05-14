import 'package:flutter/material.dart';
import 'package:china_open/commons/constants.dart' show AppColors;

class NewsListDetailPage extends StatefulWidget {

  final int id;

  NewsListDetailPage({this.id});

  @override
  _NewsListDetailPageState createState() => _NewsListDetailPageState();
}

class _NewsListDetailPageState extends State<NewsListDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'openChina',
          style: TextStyle(color: Color(AppColors.APPBAR)),
        ),
        iconTheme: IconThemeData(color: Color( AppColors.APP_THEME)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text('hello world'),
          ],
        ),
      ),
    );
  }
}
