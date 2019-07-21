import 'package:love_chat/net/net_utils.dart';
import 'package:love_chat/net/net_base_entity.dart';
import 'package:love_chat/lv/user/user.dart';

class ApiUser {
  static Future<NetBaseEntity<User>> fetchUserProfile() {
    String url = '/users/userinfo';
    return NetUtils.requestNetwork<User>(Method.get, url);
  }
}
