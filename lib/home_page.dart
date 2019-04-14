import 'package:china_open/pages/about_us.dart';
import 'package:china_open/pages/discovery_page.dart';
import 'package:china_open/pages/newsList_page.dart';
import 'package:china_open/pages/publicTween_page.dart';
import 'package:china_open/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:china_open/widgets/navigation_icon_view.dart';
import 'package:china_open/commons/constants.dart' show AppColors;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  final _appBarTitle = ['资讯', '动弹', '发现', '我的'];
  List<NavigationIconView> _navigationIconViews;
  var _currentIndex = 0;
  List<Widget> _pages;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _navigationIconViews = [
      NavigationIconView(
          _appBarTitle[0],
          'assets/images/ic_nav_news_normal.png',
          'assets/images/ic_nav_news_actived.png'),
      NavigationIconView(
          _appBarTitle[1],
          'assets/images/ic_nav_tweet_normal.png',
          'assets/images/ic_nav_tweet_actived.png'),
      NavigationIconView(
          _appBarTitle[2],
          'assets/images/ic_nav_discover_normal.png',
          'assets/images/ic_nav_discover_actived.png'),
      NavigationIconView(_appBarTitle[3], 'assets/images/ic_nav_my_normal.png',
          'assets/images/ic_nav_my_pressed.png'),
    ];
    _pages = [
      NewsListPage(),
      PublickTweenPage(),
      DiscoveryPage(),
      AboutPage(),
    ];

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          _appBarTitle[_currentIndex],
          style: TextStyle(color: Color(AppColors.APPBAR)),
        ),
        iconTheme: IconThemeData(color: Color(AppColors.APPBAR)),
      ),
      body: PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _pages[index];
        },
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _navigationIconViews.map((view) => view.item).toList(),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(index,
              duration: Duration(microseconds: 1), curve: Curves.ease);
        },
      ),
      drawer: MyDrawer(
        headImagePath: 'assets/images/cover_img.jpg',
        menuIcons: [
          Icons.send,
          Icons.access_alarm,
          Icons.beach_access,
          Icons.wifi_tethering
        ],
        menuTitles: ['发布动弹', '动弹黑屋', '关于我们', '设置'],
      ),
    );
  }
}
