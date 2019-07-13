class UserManager {
  String userId;
  String userName;
  String avatar;
  String accessToken;

  bool hasLogin() {
    return false;
  }

  // 单例相关
  // 单例公开访问点
  factory UserManager() => _sharedInstance();
  // 供内部使用
  static UserManager _instance;
  UserManager._([Map<String, dynamic> json]) {
    // 具体初始化代码
    if (json != null) {
      _instance.userId = json['userId'];
      _instance.userName = json['userName'];
      _instance.avatar = json['avatar'];
    }
  }
  static UserManager _sharedInstance() {
    if (_instance == null) {
      _instance = UserManager._();
    }
    return _instance;
  }

  factory UserManager.fromJson(Map<String, dynamic> json) {
    UserManager._(json);
    return _sharedInstance();
  }

  @override
  String toString() {
    return '{userId:$userId, userName:$userName, avatar:$avatar, accessToken:$accessToken}';
  }
}
