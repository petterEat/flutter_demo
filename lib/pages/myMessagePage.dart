import 'package:flutter/material.dart';
import 'package:china_open/commons/constants.dart' show AppColors;

class MyMessagePage extends StatefulWidget {
  @override
  _MyMessagePageState createState() => _MyMessagePageState();
}

class _MyMessagePageState extends State<MyMessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '我的消息',
          style: TextStyle(
            color: Color(AppColors.APPBAR),
          ),
        ),
        iconTheme: IconThemeData(color: Color(AppColors.APP_THEME)),
      ),
      body: Column(
        children: <Widget>[
          Text('this is my firist flutter page'),
        ],
      ),
    );
  }
}
