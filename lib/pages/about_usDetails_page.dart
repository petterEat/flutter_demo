import 'package:flutter/material.dart';
import 'package:china_open/commons/constants.dart' show AppColors;

class AboutUsDetailPage extends StatefulWidget {
  @override
  _AboutUsDetailPageState createState() => _AboutUsDetailPageState();
}

class _AboutUsDetailPageState extends State<AboutUsDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          '关于App',
          style: TextStyle(
            color: Color(AppColors.APPBAR),
          ),
        ),
        iconTheme: IconThemeData(color: Color(AppColors.APP_THEME)),
      ),
      body: buildSigleChildScorllView(),
    );
  }

  Widget buildSigleChildScorllView() {
    return SingleChildScrollView(
        child: new Container(
          child: FloatingActionButton(onPressed: (){
            print('click here');
          })
        ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('_AboutUsDetailPageState');
  }
}
