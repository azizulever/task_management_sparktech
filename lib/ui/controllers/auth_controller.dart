import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static const String _accessTokenKey = 'access-token';

  static String? accessToken;

  static Future<void> saveAccessToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    accessToken = token;
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    accessToken = token;
    return token;
  }

  static bool isLoggedIn() {
    return accessToken != null;
  }

  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  static Future<void> saveUserData(String fn, String ln, String em) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("fn", fn);
    sp.setString("ln", ln);
    sp.setString("em", em);
  }

  static Future<Map<String, String?>> getUserData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? fn = sp.getString("fn");
    String? ln = sp.getString("ln");
    String? em = sp.getString("em");

    return {
      "firstName": fn,
      "lastName": ln,
      "email": em,
    };
  }
}
