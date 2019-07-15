class User {
  String userId;
  String userName;
  String avatar;

  User(this.userId, this.userName, this.avatar);

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] as String;
    userName = json['userName'] as String;
    avatar = json['avatar'] as String;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'avatar': avatar,
    };
  }
}