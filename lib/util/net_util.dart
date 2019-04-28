
import 'package:http/http.dart' as http;
class NetUtil{

  static Future<String> get(String url,Map<String,dynamic> params) async{
    if(url != null && params != null && params.isNotEmpty){
      StringBuffer sbf = new StringBuffer("?");
      params.forEach((key,value){
        sbf.write('$key=$value&');
      });
      String result = sbf.toString().substring(0,sbf.length-1);
      url += result;
      print('httpNet: '+url);
      http.Response response = await http.get(url);
      return response.body;
    }else{
      print('please check you http data');
    }
    return null;
  }

  static Future<String> post(String url,Map<String,dynamic> params) async{
    http.Response response = await http.post(url,body: params);
    return response.body;
  }
}