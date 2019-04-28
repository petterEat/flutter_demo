import 'package:flutter/material.dart';
import 'package:china_open/commons/constants.dart' show AppColors,AppInfos,AppUrls;
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class LoginWebPage extends StatefulWidget {
  @override
  _LoginWebPageState createState() => _LoginWebPageState();
}

class _LoginWebPageState extends State<LoginWebPage> {

  FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();
  bool isloading = true;



  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((url){
      if(mounted){
        isloading = false;
      }
      print('url');
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin.close();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _appbartitle = [
      Text('登录开源中国',
        style: TextStyle(color: Color(AppColors.APPBAR))),
    ];
    if(isloading){
      _appbartitle.add(SizedBox(
        width: 10.0,
      ));
      _appbartitle.add(CupertinoActivityIndicator());
    }
    return WebviewScaffold(
        url: AppUrls.OAUTH2_AUTHORIZE +
            '?response_type=code&client_id=' +
            AppInfos.CLIENT_ID +
            '&redirect_uri=' +
            AppInfos.REDIRECT_URI,
        appBar: AppBar(
          title: Row(
            children: _appbartitle,
          ),
          iconTheme: IconThemeData(color: Color(AppColors.APPBAR)),
        ),
      withJavascript: true,
      withLocalStorage:true,
      withZoom: true,
    );
  }
}
