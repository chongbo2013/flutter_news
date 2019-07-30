import 'package:shared_preferences/shared_preferences.dart';

/// create on 2019/5/30 by JasonZhang
/// desc：本地储存
class SharedPreferenceUtil {
  static const String KEY_ACCOUNT = "account";

  // 异步保存
  static Future save(String key, String value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
  }

  // 异步读取
  static Future<String> get(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  static Future savebool(String key, bool value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(key, value);
  }

  // 异步读取
  static Future<bool> getbool(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(key);
  }
}
