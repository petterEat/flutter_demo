import 'package:flutter/material.dart';
import 'package:china_open/pages/NewsListDetailPage.dart';

class NewsListItem extends StatelessWidget {
  final Map<String, dynamic> newsDatas;

  NewsListItem({this.newsDatas});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewsListDetailPage(
                  id: newsDatas['id'],
                )));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Color(0xffaaaaaaaa),
          width: 1.0,
        ))),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 20.0),
          child: Column(
            children: <Widget>[
              Text(
                '${newsDatas['title']}',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${newsDatas['author']} ${newsDatas['pubDate'].toString().split(' ')[0]}',
                    style: TextStyle(
                      color: Color(0xffaaaaaaaa),
                      fontSize: 14.0,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.message,
                        color: Color(0xffaaaaaaaa),
                      ),
                      Text(
                        '${newsDatas['commentCount']}',
                        style: TextStyle(
                          color: Color(0xffaaaaaaaa),
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
