import 'package:flutter/material.dart';

class TweetItem extends StatelessWidget {
  final Map<String, dynamic> tweetData;
  final RegExp regExp1 = new RegExp("</.*>");
  final RegExp regExp2 = new RegExp("<.*>");

  TweetItem({Key key, @required this.tweetData})
      : assert(tweetData != null),
        super(key: key);

  int getRow(int n) {
    int a = n % 3;
    int b = n ~/ 3;
    if (a != 0) {
      return b + 1;
    }
    return b;
  }

  // 去掉文本中的html代码
  String clearHtmlContent(String str) {
    if (str.startsWith("<emoji")) {
      return "[emoji]";
    }
    var s = str.replaceAll(regExp1, "");
    s = s.replaceAll(regExp2, "");
    s = s.replaceAll("\n", "");
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildContentWeiget(),
          Divider(),
          _buildFunctionArea(),
        ],
      ),
    );
  }

  Widget _buildContentWeiget() {
    var _columChilden = <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(tweetData['portrait'], scale: 1.5),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${tweetData['author']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
              Text(
                '${tweetData['pubDate']}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          '${clearHtmlContent(tweetData['body'])}',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _columChilden,
      ),
    );
  }

  Widget _buildFunctionArea() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.arrow_forward,
                color: Colors.blueGrey,
                size: 16.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                '转发',
                style: TextStyle(fontSize: 16.0,color: Colors.blueGrey),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.message,
                color: Colors.blueGrey,
                size: 16.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                '评论',
                style: TextStyle(fontSize: 16.0,color: Colors.blueGrey),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.thumb_up,
                color: Colors.blueGrey,
                size: 16.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                '赞',
                style: TextStyle(fontSize: 16.0,color: Colors.blueGrey),
              ),
            ],
          )
        ],
      ),
    );
  }
}
