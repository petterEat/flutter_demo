import 'package:china_open/pages/about_us.dart';
import 'package:china_open/pages/publicTween_page.dart';
import 'package:china_open/pages/setting_page.dart';
import 'package:china_open/pages/tweetBlack_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final String headImagePath;

  final List menuTitles;

  final List menuIcons;

  MyDrawer(
      {Key key,
      @required this.headImagePath,
      @required this.menuTitles,
      @required this.menuIcons})
      : assert(headImagePath != null),
        assert(menuTitles != null),
        assert(menuIcons != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: ListView.separated(
        padding: EdgeInsets.all(0.0),
        itemCount: menuTitles.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Image.asset(
              headImagePath,
              fit: BoxFit.fill,
            );
          }
          index -= 1;
          return ListTile(
            leading: Icon(menuIcons[index]),
            title: Text(menuTitles[index]),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              switch (index) {
                case 0:
                  _navPush(context, PublickTweenPage());
                  break;
                case 1:
                  _navPush(context, TweetBlackPage());
                  break;
                case 2:
                  _navPush(context, AboutPage());
                  break;
                case 3:
                  _navPush(context, SettingPage());
                  break;
              }
            },
          );
        },
        separatorBuilder: (context, index) {
          if (index == 0) {
            return Divider(
              height: 0.0,
            );
          } else {
            return Divider(
              height: 1.0,
            );
          }
        },
      ),
    );
  }

  _navPush(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }
}
