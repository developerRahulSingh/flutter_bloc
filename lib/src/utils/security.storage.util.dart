import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityUtil {
  static var storage = FlutterSecureStorage();
  static String pinCodeSecurityKey = 'FVBPINCode';
  static String userNameKey = 'FVBUserName';
  static String userPasswordKey = 'FVBUserPassword';

  static Future<String> isPINCodeSecurityEnabled() async {
    String value = await storage.read(key: pinCodeSecurityKey);
    return value != null ? 'true' : 'false';
//  bool result = false;
//    return storage.read(key: pinCodeSecurityKey).then((value) {
//      result = value != null ? true : false;
//    }, onError: (error) {
//      result =  false;
//    });
//    return result;
  }

  static Future<bool> setPINCodeSecurity(String pinCode) async {
    await storage.write(key: pinCodeSecurityKey, value: pinCode);
    return true;
  }

  static Future<String> getPINCodeSecurity() async {
    String value = await storage.read(key: pinCodeSecurityKey);
    if (value != null) {
      return value;
    } else {
      return '';
    }
  }

  static removePINCodeSecurity() async {
    await storage.delete(key: pinCodeSecurityKey);
  }

  static Future<bool> saveUserCredentials(
      String username, String password) async {
    await storage.write(key: userNameKey, value: username);
    await storage.write(key: userPasswordKey, value: password);
    return true;
  }

  static Future<String> getUserName() async {
    String valueUsername = await storage.read(key: userNameKey);
    if (valueUsername != null) {
      return valueUsername;
    } else {
      return '';
    }
  }

  static Future<String> getUserPassword() async {
    String valueUserPassword = await storage.read(key: userPasswordKey);
    if (valueUserPassword != null) {
      return valueUserPassword;
    } else {
      return '';
    }
  }

  static Future<bool> removeUserCredentials() async {
    await storage.delete(key: userNameKey);
    await storage.delete(key: userPasswordKey);
    return true;
  }

  static void writeValue(String key, String value) {
    storage.write(key: key, value: value);
  }

  static void deleteValue(String key) async {
    await storage.delete(key: key);
  }

  static Future readValue(String key) async {
    String value = await storage.read(key: key);
    return value;
  }
}
