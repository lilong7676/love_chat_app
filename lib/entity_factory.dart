import 'package:love_chat/lv/user/user.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (T.toString() == 'User') {
      return User.fromJson(json) as T;
    }

    return null;
  }
}
