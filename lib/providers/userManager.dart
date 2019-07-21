import 'package:love_chat/lv/user/user.dart';

class UserManager {
  User _user;
  String accessToken;
  int get userId => _user?.userId;
  String get userName => _user?.userName;
  String get avatar => _user?.avatar;

  set user(User user) {
    _user = user;
  }

  // 单例相关
  // 单例公开访问点
  factory UserManager() => _sharedInstance();
  // 供内部使用
  static UserManager _instance;
  // 命名构造函数
  UserManager._() {
    // 具体初始化代码
  }
  static UserManager _sharedInstance() {
    if (_instance == null) {
      _instance = UserManager._();
    }
    return _instance;
  }

  @override
  String toString() {
    return '{userId:$userId, userName:$userName, avatar:$avatar, accessToken:$accessToken}';
  }
}
