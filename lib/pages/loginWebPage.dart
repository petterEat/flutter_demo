import 'package:flutter/material.dart';
import 'package:china_open/commons/constants.dart' show AppColors,AppInfos,AppUrls;
import 'package:flutter/cupertino.dart';
import 'package:china_open/util/net_util.dart';
import 'package:china_open/util/data_util.dart';
import 'dart:convert';
import 'package:china_open/commons/event_bus.dart';
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
      //www.dongnaoedu.com/?code=O1ijTn&state=
      print('url'+url);
      if(url != null && url.length > 0 && url.contains("code=")){
        String code = url.split("?")[1].split('&')[0].split('=')[1];
        Map<String,dynamic> params = Map<String,dynamic>();
        params['client_id'] = AppInfos.CLIENT_ID;
        params['client_secret'] = AppInfos.CLIENT_SECRET;
        params['grant_type'] = 'authorization_code';
        params['redirect_uri'] = AppInfos.REDIRECT_URI;
        params['code'] = '$code';
        params['dataType'] = 'json';

        NetUtil.get(AppUrls.OAUTH2_TOKEN, params).then((data){
          if(null != data){
            Map<String,dynamic> map = json.decode(data);
            if(null != map && map.isNotEmpty){
              DataUtils.saveLoginInfo(map);
              eventBus.fire(LoginInEvent());
              Navigator.pop(context,'refresh');
            }
          }
        });
      }
      
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
