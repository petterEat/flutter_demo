import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:china_open/util/data_util.dart';
import 'package:china_open/util/net_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:china_open/commons/constants.dart' show AppColors,AppUrls;
import 'package:china_open/commons/event_bus.dart';
import 'package:china_open/pages/loginWebPage.dart';

class PublickTweenPage extends StatefulWidget {
  @override
  _PublickTweenPage createState() => _PublickTweenPage();
}

class _PublickTweenPage extends State<PublickTweenPage>
    with SingleTickerProviderStateMixin {
  List _tabTitle = ['最新', '热门'];
  List lastTweetList;
  List hotTweetList;
  int currentPage = 1;
  ScrollController _scrollController = ScrollController();
  TabController _tabController;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitle.length, vsync: this);
    _tabController.addListener(() {});
    DataUtils.isLogin().then((isLogin) {
      if (!mounted) {
        return;
      }
      setState(() {
        this.isLogin = isLogin;
      });
    });
    eventBus.on<LoginInEvent>().listen((isLogin) {
      if (!mounted) {
        return;
      }
      setState(() {
        this.isLogin = true;
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLogin) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('必须登录才能看到详情哦'),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  '马上登录',
                  style: TextStyle(color: Color(0xff000000)),
                ),
              ),
              onTap: () async{
                final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginWebPage()));
                if(result != null && result == 'fresh'){
                  eventBus.fire(LoginInEvent);
                }
              },
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            color: Color(AppColors.APP_THEME),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Color(0xffffffff),
              labelColor: Color(0xffffffff),
              tabs: _tabTitle.map((title) {
                return Tab(
                  text: title,
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: [_buildLasterTweetList(), _buildHotTweetList()]),
          ),
        ],
      );
    }
  }

  Future<Null> _pullToRefresh() async{
    currentPage = 1;
    getTweetList(false, false);
    return null;
  }

  Widget _buildLasterTweetList() {
    if (lastTweetList == null) {
      getTweetList(false, false);
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
        child: ListView.separated(
            itemBuilder: (context, index) {
              if (index == lastTweetList.length) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CupertinoActivityIndicator(),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text('正在加载'),
                      ],
                    ),
                  ),
                );
              }
              return Container(
                child: Text('container'),
              );
            },
            separatorBuilder: (context,index){
              return Container(
                height: 10.0,
                color: Colors.grey[200],
              );
            },
            itemCount: lastTweetList.length + 1),
        onRefresh: _pullToRefresh);
  }

  _buildHotTweetList(){
    if(hotTweetList == null){
      getTweetList(false,true);
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    return ListView.separated(
        itemBuilder: (context,index){
          if(index == hotTweetList.length){
            return Container(
              padding: const EdgeInsets.all(10.0),
              color: Color(0xaaaaaaaa),
              child: Text('没有更多数据了'),
            );
          }
          return Container(
            height: 10.0,
            child: Text('hot item'),
          );
        },
        separatorBuilder: (context,index){
          return Container(
            height: 10.0,
            color: Colors.grey[200],
          );
        },
        itemCount: hotTweetList.length + 1);
  }

  getTweetList(bool isLoadMore,bool isHot){
    DataUtils.isLogin().then((isLogin){
      if(isLogin){
        DataUtils.getAccessToken().then((accessToken){
          if(accessToken == null || accessToken.length == 0){
              return;
          }
          Map<String, dynamic> params = Map<String, dynamic>();
          params['access_token'] = accessToken;
          params['user'] = isHot ? -1 : 0;
          params['page'] = currentPage;
          params['pageSize'] = 10;
          params['dataType'] = 'json';
          NetUtil.get(AppUrls.TWEET_LIST, params).then((data){
            if (data != null && data.isNotEmpty) {
              Map<String, dynamic> map = json.decode(data);
              List _tweetList = map['tweetlist'];
              if (!mounted) return;
              setState(() {
                if (isLoadMore) {
                  if (isHot) {
                    lastTweetList.addAll(_tweetList);
                    hotTweetList.addAll(_tweetList);
                  }
                } else {
                  if (isHot) {
                    hotTweetList = _tweetList;
                  } else {
                    lastTweetList = _tweetList;
                  }
                }
              });
            }
          });
        });
      }
    });
  }
}
