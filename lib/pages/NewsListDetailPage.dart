import 'package:flutter/material.dart';
import 'package:china_open/commons/constants.dart' show AppColors, AppUrls;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:china_open/util/data_util.dart';
import 'package:china_open/util/net_util.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class NewsListDetailPage extends StatefulWidget {
  final int id;

  NewsListDetailPage({this.id}) : assert(id != null);

  @override
  _NewsListDetailPageState createState() => _NewsListDetailPageState();
}

class _NewsListDetailPageState extends State<NewsListDetailPage> {
  bool isLoading = true;
  String url;
  FlutterWebviewPlugin _flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    DataUtils.getAccessToken().then((token) {
      Map<String, dynamic> params = Map<String, dynamic>();
      params['access_token'] = token;
      params['dataType'] = 'json';
      params['id'] = widget.id;
      NetUtil.get(AppUrls.NEWS_DETAIL, params).then((data) {
        if (null != data && data.isNotEmpty) {
          Map<String, dynamic> map = json.decode(data);
          if (mounted) {
            setState(() {
              url = map['url'];
            });
          }
        }
      });
    });

    _flutterWebviewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      } else if (state.type == WebViewState.startLoad) {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _appBarTitle = [
      Text(
        '咨询详情',
        style: TextStyle(color: Color(AppColors.APPBAR)),
      )
    ];
    if (isLoading) {
      _appBarTitle.add(SizedBox(
        width: 10.0,
      ));
      _appBarTitle.add(CupertinoActivityIndicator());
    }

    return url == null
        ? Center(
            child: CupertinoActivityIndicator(),
          )
        : WebviewScaffold(
            url: url,
            appBar: AppBar(
              title: Row(
                children: _appBarTitle,
              ),
              iconTheme: IconThemeData(color: Color(AppColors.APPBAR)),
            ),
            withJavascript: true,
            withLocalStorage: true,
            withZoom: true,
          );
  }
}
