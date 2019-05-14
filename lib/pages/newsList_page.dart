import 'dart:convert';

import 'package:china_open/commons/constants.dart';
import 'package:flutter/material.dart';
import 'package:china_open/pages/loginWebPage.dart';
import 'package:china_open/commons/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:china_open/widgets/NewsListItem.dart';
import 'package:china_open/util/data_util.dart';
import 'package:china_open/util/net_util.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPage createState() => _NewsListPage();
}

class _NewsListPage extends State<NewsListPage> {
  bool isLogin = false;
  int currentPage = 1;
  List newsDatalist;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener((){
      var maxScorll = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;
      if(maxScorll == pixels){
        currentPage ++;
        getNewsData(true);
      }
    });

    DataUtils.isLogin().then((isLogin){
      if(isLogin){
        if(mounted){
          setState(() {
            this.isLogin = isLogin;
          });
        }
      }
    });

    eventBus.on<LoginInEvent>().listen((event){
      if(mounted){
        setState(() {
          this.isLogin = true;
        });
        getNewsData(false);
      }
    });

    eventBus.on<LoginOutEvent>().listen((event){
      if(mounted){
        setState(() {
          this.isLogin = true;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    if (!isLogin) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('请先登录'),
            InkWell(
              onTap: () async {
                final result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginWebPage()));
                if (null != result && result == 'refresh') {
                  eventBus.fire(LoginInEvent());
                }
              },
              child: Text('登录'),
            )
          ],
        ),
      );
    }
    return RefreshIndicator(
      child: buildListView(),
      onRefresh: _pullToRefresh,
    );
  }

  Widget buildListView() {
    if (newsDatalist == null) {
      getNewsData(false);
      return CupertinoActivityIndicator();
    }
    return ListView.builder(
        controller: _scrollController,
        itemCount: newsDatalist.length, //lsn 15
        itemBuilder: (context, index) {
          return NewsListItem(newsDatas: newsDatalist[index]);
        });
  }

  void getNewsData(bool isloadMore) async {
    DataUtils.isLogin().then((isLogin){
      if(!isLogin){
        DataUtils.getAccessToken().then((accessToken){
          if (accessToken == null || accessToken.length == 0) {
            return;
          }
          Map<String, dynamic> params = Map<String, dynamic>();
          params['access_token'] = accessToken;
          params['catalog'] = 1;
          params['page'] = currentPage;
          params['pageSize'] = 10;
          params['dataType'] = 'json';

          NetUtil.get(AppUrls.NEWS_LIST, params).then((data){
            print('NEWS_LIST: $data');
            if (data != null && data.isNotEmpty) {
              Map<String, dynamic> map = json.decode(data);
              List _newsList = map['newslist'];
              if (!mounted) return;
              setState(() {
                if (isloadMore) {
                  newsDatalist.addAll(_newsList);
                } else {
                  newsDatalist = _newsList;
                }
              });
            }
          });
        });
      }
    });
  }

  Future<Null> _pullToRefresh() async {
    currentPage = 1;
    getNewsData(false);
    return null;
  }
}
