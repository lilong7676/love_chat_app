class User {
  int userId;
  String username;
  String avatar;

  User(this.userId, this.username, this.avatar);

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] as int;
    username = json['username'] as String;
    avatar = json['avatar'] as String;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'avatar': avatar,
    };
  }

  static List<User> userListFromJsonList(List list) {
    List<User> result = List();
    for (dynamic userJson in list) {
      userJson = userJson as Map<String, dynamic>;
      User user = User.fromJson(userJson);
      result.add(user);
    }
    return result;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
