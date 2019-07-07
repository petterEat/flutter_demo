import 'package:flutter/material.dart';
import 'package:china_open/util/data_util.dart';
import 'package:china_open/commons/event_bus.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: ListView.separated(
            itemBuilder: (context, index) {
              return InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '退出登录',
                      style: TextStyle(color: Colors.black,fontSize: 18),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black,
                    ),
                  ],
                ),
                onTap: (){
                  _buildExitAppWidget(context);
                },
              );
            },
            itemCount: 1,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      ),
    );
  }

  _buildExitAppWidget(BuildContext mContext) {
    showModalBottomSheet(
        context: mContext,
        builder: (BuildContext mContext) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('退出登录'),
                  onTap: () {
                    Navigator.of(context).pop();
                    DataUtils.loginOut();
                    eventBus.fire(LoginOutEvent());
                    Navigator.pop(mContext, 'refresh');
                  },
                )
              ],
            ),
          );
        });
  }
}
