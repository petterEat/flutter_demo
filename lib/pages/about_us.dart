import 'package:flutter/material.dart';
import 'package:china_open/util/data_util.dart';
import 'package:china_open/commons/constants.dart' show AppColors,AppUrls;
import 'package:china_open/pages/about_usDetails_page.dart';
import 'package:china_open/pages/myMessagePage.dart';
import 'package:china_open/pages/loginWebPage.dart';
import 'package:china_open/commons/event_bus.dart';
import 'package:china_open/util/net_util.dart';
import 'dart:convert';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  List menuTitles = [
    '我的消息',
    '阅读记录',
    '我的博客',
    '我的问答',
    '我的活动',
    '我的团队',
    '邀请好友',
  ];
  List menuIcons = [
    Icons.message,
    Icons.print,
    Icons.error,
    Icons.phone,
    Icons.send,
    Icons.people,
    Icons.person,
  ];
  String userAdmin;
  String userName;

  @override
  void initState() {
    super.initState();

    eventBus.on<LoginInEvent>().listen((eventBus){
      _getUserInfo();
    });
    eventBus.on<LoginOutEvent>().listen((eventBus){
      _showUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _buildHead();
          }
          index -= 1;
          return ListTile(
            leading: Icon(menuIcons[index]),
            title: Text(menuTitles[index]),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              DataUtils.isLogin().then((isLogin) {
                if (isLogin) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyMessagePage()));
                } else {
                  _login();
                }
              });
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
        itemCount: menuTitles.length + 1);
  }

  Container _buildHead() {
    return Container(
      height: 150,
      color: Color(AppColors.APP_THEME),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: userAdmin != null
                  ? Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Color(0xfffffff), width: 2.0),
                          image: DecorationImage(
                              image: NetworkImage(userAdmin),
                              fit: BoxFit.fill)),
                    )
                  : Image.asset(
                      'assets/images/ic_avatar_default.png',
                      width: 60.0,
                      height: 60.0,
                    ),
              onTap: () {
                DataUtils.isLogin().then((islogin) {
                  if (islogin) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AboutUsDetails_page()));
                  } else {
                    _login();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    final result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginWebPage()));
    if (result != null && result == 'refresh') {
      eventBus.fire(LoginInEvent());
    }
  }

  _showUserInfo(){
    DataUtils.getUserInfo().then((user){
      if(mounted){
        setState(() {
          if(user != null) {
            userAdmin = user.avatar;
            userName = user.name;
          }else{
            userAdmin = null;
            userName = null;
          }
        });
      }
    });
  }

  _getUserInfo() async{
    DataUtils.getAccessToken().then((accessToken){
      if(accessToken == null || accessToken.length == 0){
        return;
      }
      Map<String, dynamic> params = Map<String, dynamic>();
      params['access_token'] = accessToken;
      params['dataType'] = 'json';
      print('accessToken: $accessToken');
      NetUtil.get(AppUrls.OPENAPI_USER, params).then((data){
        if(data != null){
          Map<String,dynamic> map = json.decode(data);
          if(mounted){
            setState(() {
              userAdmin = map['avatar'];
              userName = map['name'];
            });
          }
          DataUtils.saveUserInfo(map);
        }
      });

    });
  }
}
