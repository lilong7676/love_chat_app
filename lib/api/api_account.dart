import 'package:love_chat/net/net_utils.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class ApiAccount {
  static fetchLogin(Map<String, String> payload) async {
    String url = '$baseUrl/oauth/token';
    Map<String, String> params = {
      'username': payload['username'],
      'password': payload['password'],
      'client_id': '1_6at33278mzs4o8oo84cco0c0gs8kc0ss0co4ww8ks0k48gc0oc',
      'client_secret': '60qx1xjm7f4sog04gg4sw48kkwcw40wgoooowossgsw84c00ww',
      'grant_type': 'password'
    };

    Dio dio = Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    try {
      Response result = await dio.post(url, data: params);
      return result.data;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future fetchRegister(Map<String, String> payload) async {
    String url = '/users/register';
    return NetUtils.requestNetwork(Method.post, url, params: payload);
  }
}
