import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/model/TALogin/login.dart';

enum ApplicationType { Web, Android, IOS, Window }

class PlatformSessionManager {
  static const String _loginInfoKey = 'login_info';
  static const String _authModeKey = 'auth_mode';
    static const String _authLoginInfoKey = 'auth_login_info'; // New key for AuthLogin


  // Make the methods static so they can be accessed directly from the class
  static Future saveLoginInfo(Map loginInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loginInfoKey, jsonEncode(loginInfo));
  }

  static Future<Map?> getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final loginInfoString = prefs.getString(_loginInfoKey);
    if (loginInfoString != null) {
      return jsonDecode(loginInfoString);
    }
    return null;
  }

  static const String _userInfoKey = 'user_info';

// Store user information
static Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userInfoKey, jsonEncode(userInfo));
}

// Retrieve user information
static Future<Map<String, dynamic>?> getUserInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final userInfoString = prefs.getString(_userInfoKey);
  if (userInfoString != null) {
    return jsonDecode(userInfoString);
  }
  return null;
}


    // Save AuthLogin info
  static Future saveAuthLoginInfo(AuthLogin authLogin) async {
     final encryptedString =  base64Encode(
          authLogin.AuthEncryptedString.codeUnits);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_authLoginInfoKey, jsonEncode(encryptedString));
  }

    static Future<String?> getAuthLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedString = prefs.getString(_authLoginInfoKey);
    if (encryptedString != null) {
      final decoded = jsonDecode(encryptedString);
      return decoded;
    }
    return null;
  }

  // same like above but for login_info


  static Future saveAuthMode(LoginMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authModeKey, mode.toString());
  }

  static Future<String?> getAuthMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authModeKey);
  }

  static Future<Map<String, dynamic>?> getLoginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final loginInfoString = prefs.getString(_loginInfoKey);
    if (loginInfoString != null) {
      return jsonDecode(loginInfoString);
    }
    return null;
  }
  static Future clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginInfoKey);
    await prefs.remove(_authModeKey);
    await prefs.remove(_authLoginInfoKey);
    await prefs.remove(_userInfoKey);
  }

  // Check login status
  static Future<bool> isLoggedIn() async {
    final loginInfo = await getLoginInfo();
    return loginInfo != null;
  }

  static ApplicationType getApplicationType() {
    if (kIsWeb) {
      return ApplicationType.Web;
    } else if (Platform.isAndroid) {
      return ApplicationType.Android;
    } else if (Platform.isIOS) {
      return ApplicationType.IOS;
    } else if (Platform.isWindows) {
      return ApplicationType.Window;
    }
    return ApplicationType.Web; // default fallback
  }
}
