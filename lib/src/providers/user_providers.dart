
import 'dart:convert';

import 'package:app_flutter_formsvalidation/src/shared_prefs/preferences_user.dart';
import 'package:http/http.dart' as http;

class UserProvider{

  final String _firebaseToken='AIzaSyA-8kzdhtKTdhY0O6TID8cJG0Ojf6aGOB0';
  final _prefs = new PreferencesUser();
  
  Future<Map<String, dynamic>> login(String email, String password) async{
    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if(decodedResp.containsKey('idToken')){
      //Save token in the storage
      _prefs.token = decodedResp['idToken'];
      return {'ok':true,'token':decodedResp['idToken']};
    }else{
      //Error
      return {'ok':false,'message':decodedResp['error']['message']};;
    }
  }

  Future<Map<String, dynamic>> newUser(String email, String password) async{
    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    //print(decodedResp);

    if(decodedResp.containsKey('idToken')){
      //Save token in the storage
      _prefs.token = decodedResp['idToken'];
      return {'ok':true,'token':decodedResp['idToken']};
    }else{
      //Error
      return {'ok':false,'message':decodedResp['error']['message']};;
    }
  }

}