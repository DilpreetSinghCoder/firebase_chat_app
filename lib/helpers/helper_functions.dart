import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLogInKey = 'ISLOGEDIN';
  static String sharedPreferenceUserNameKey = 'USERNAMEKEY';
  static String sharedPreferenceUserEmail = 'USEREMAILKEY';

  static Future<void> saveUserLoggedInSharedPrefernece(
      bool isUserLoggedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool(sharedPreferenceUserLogInKey, isUserLoggedIn);
  }

  static Future<void> saveUserNameSharedPrefernece(String userName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<void> saveUserEmailSharedPrefernece(String userEmail) async {
    userEmail = userEmail.trim();
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(sharedPreferenceUserEmail, userEmail);
  }

  static Future<bool> getUserLoggedInSharedPrefernece() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var tt = pref.getBool(sharedPreferenceUserLogInKey);
    return tt ?? false;
  }

  static Future<String> getUserNameSharedPrefernece() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPrefernece() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(sharedPreferenceUserEmail);
  }
}
