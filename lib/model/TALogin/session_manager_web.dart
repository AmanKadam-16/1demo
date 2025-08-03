import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/model/TALogin/login.dart';

enum ApplicationType { Web, Android, IOS, Window }

class PlatformSessionManager {
  static const String _loginInfoKey = 'login_info';
  static const String _authModeKey = 'auth_mode';
    static const String _authLoginInfoKey = 'auth_login_info'; // New key for AuthLogin


  // Make the methods static so they can be accessed directly from the class
  static Future saveLoginInfo(Map loginInfo) async {
    html.window.localStorage[_loginInfoKey] = jsonEncode(loginInfo);
  }


  static const String _userInfoKey = 'user_info';

// Store user information
static Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
  html.window.localStorage[_userInfoKey] = jsonEncode(userInfo);
}

// Retrieve user information
static Future<Map<String, dynamic>?> getUserInfo() async {
  final userInfoString = html.window.localStorage[_userInfoKey];
  if (userInfoString != null) {
    return jsonDecode(userInfoString);
  }
  return null;
}

  static Future<Map?> getLoginInfo() async {
    final loginInfoString = html.window.localStorage[_loginInfoKey];
    if (loginInfoString != null) {
      print(jsonDecode(loginInfoString));
      return jsonDecode(loginInfoString);
    }
    return null;
  }
    // Save AuthLogin info
  static Future saveAuthLoginInfo(AuthLogin authLogin) async {
         final encryptedString =  base64Encode(
          authLogin.AuthEncryptedString.codeUnits);
    if (kIsWeb) {
      html.window.localStorage[_authLoginInfoKey] = jsonEncode(encryptedString.toString());
    }
  }

  static Future<Map<String, dynamic>?> getLoginDetails() async {
    final loginInfoString = html.window.localStorage[_loginInfoKey];
    if (loginInfoString != null) {
      return jsonDecode(loginInfoString);
    }
    return null;
  }
  static Future<String?> getAuthLoginInfo() async {
    final encryptedString = html.window.localStorage[_authLoginInfoKey];
    if (encryptedString != null) {
      final decoded = jsonDecode(encryptedString);
      return decoded;
    }
    return null;
  }

  static Future<void> saveAuthMode(LoginMode mode) async {
    html.window.localStorage[_authModeKey] = mode.toString();
  }

  static Future<String?> getAuthMode() async {
    return html.window.localStorage[_authModeKey];
  }

  static Future clearSession() async {
    html.window.localStorage.remove(_loginInfoKey);
    html.window.localStorage.remove(_authModeKey);
    html.window.localStorage.remove(_authLoginInfoKey);
    html.window.localStorage.remove(_userInfoKey);
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
