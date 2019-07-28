import 'package:love_chat/lv/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const String UserManagerSaveKey = 'UserManagerSaveKey';

class UserManager {
  User _user;
  String accessToken;
  int get userId => _user?.userId;
  String get username => _user?.username;
  String get avatar => _user?.avatar;

  set user(User user) {
    _user = user;
  }

  // 当前用户是否已登录
  bool hasLogin() {
    return accessToken != null && _user != null;
  }

  // 数据持久化
  Future<bool> saveToDisk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String instanceString = jsonEncode(_instance);
    print('instanceString $instanceString');
    return await prefs.setString(UserManagerSaveKey, instanceString);
  }
  // 数据恢复
  Future<UserManager> restoreFromDisk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString(UserManagerSaveKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      UserManager.fromJson(json);
      return UserManager();
    }
    return null;
  }

  // 单例相关
  // 单例公开访问点
  factory UserManager() {
    return _sharedInstance();
  }
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
    return '{userId:$userId, userName:$username, avatar:$avatar, accessToken:$accessToken}';
  }

  Map<String, dynamic> toJson() {
    return {
      'User': _user == null ? '' : _user.toJson(),
      'accessToken': accessToken
    };
  }
  
  UserManager.fromJson(Map<String, dynamic> json) {
    UserManager manager = UserManager();
    if (json['User'] != null) {
      manager._user = User.fromJson(json['User']);
    }
    if ((json['accessToken'] as String).isNotEmpty) {
      manager.accessToken = json['accessToken'];
    }
  }
  
}
