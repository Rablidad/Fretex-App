import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UserAuthInfo extends Model{
  static bool _authenticated = false;
  String _email;
  String _idToken;
  String _localId;
  String _password;

  String get password => _password;
  String get email => _email;
  String get localId => _localId;
  String get idToken => _idToken;
  bool get getAuthenticationValue => _authenticated;

  set setEmail(String email) => _email = email;
  set setPassword(String password) => _password = password;
  set setToken(String token) => _idToken = token;
  set setIdlocal(String localid) => _localId = localid;

  
  static Future<void> checkIfAuthenticatedOnce() async
  {
    debugPrint("Lendo Token...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token');
      final String email = prefs.getString('useremail');
      if(token != null)
      {
        _authenticated = true;
        debugPrint("Token encontrado!");
        debugPrint("Token é: " + token);
        debugPrint("email é: " + email);
        return;
      }
      debugPrint("Token não encontrado!");
      _authenticated = false;
      return;
  }
}