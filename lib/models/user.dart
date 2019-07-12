class User {
  String userId;
  String userName;
  String avatar;
  String accessToken;

  // 单例公开访问点
  factory User() => _sharedInstance();

  // 供内部使用
  static User _instance;

  User._([Map<String, dynamic> json]) {
    // 具体初始化代码
    if (json != null) {
      _instance.userId = json['userId'];
      _instance.userName = json['userName'];
      _instance.avatar = json['avatar'];
    }
  }

  static User _sharedInstance() {
    if (_instance == null) {
      _instance = User._();
    }
    return _instance;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    User._(json);
    return _sharedInstance();
  }

  @override
  String toString() {
    return '{userId:$userId, userName:$userName, avatar:$avatar, accessToken:$accessToken}';
  }
}
