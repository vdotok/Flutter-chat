import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vdkFlutterChat/src/core/config/config.dart';
import 'package:vdkFlutterChat/src/qrcode/qrcode.dart';
import '../models/user.dart';
import '../services/server.dart';
import '../../shared_preference/shared_preference.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  LoggedOut,
  Failure,
  Loading
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.Authenticating;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  User? _user = new User(
      auth_token: '', full_name: '', ref_id: '', authorization_token: '');
  User? get getUser => _user;

  SharedPref _sharedPref = SharedPref();

  late String _loginErrorMsg;
  String get loginErrorMsg => _loginErrorMsg;

  late String _registerErrorMsg;
  String get registerErrorMsg => _registerErrorMsg;
  static String _projectId = "";
  static String get projectId => _projectId;
  static String _tenantUrl = "";
  static String get tenantUrl => _tenantUrl;

  late String _host;
  String get host => _host;

  late String _port;
  String get port => _port;

  Future<bool> register(
    email,
    String username,
    password,
  ) async {
    _registeredInStatus = Status.Loading;
    notifyListeners();

    var version;
    var model;

    if (kIsWeb) {
      version = "web";
      model = "web";
    } else {
      if (Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        version = androidInfo.version.release;
        model = androidInfo.model;
        // Android 9 (SDK 28), Xiaomi Redmi Note 7
      }

      if (Platform.isIOS) {
        var iosInfo = await DeviceInfoPlugin().iosInfo;
        version = iosInfo.systemName;
        model = iosInfo.model;
        // iOS 13.1, iPhone 11 Pro Max iPhone
      }
    }
    _projectId = project == "" ? project_id : project;
    _tenantUrl = url == "" ? tenant_url : url;
    Map<String, dynamic> jsonData = {
      "full_name": username,
      "password": password,
      "email": email,
      "device_type": kIsWeb
          ? "web"
          : Platform.isAndroid
              ? "android"
              : "ios",
      "device_model": model,
      "device_os_ver": version,
      "app_version": "1.1.5",
      "project_id": _projectId,
    };

    final response = await callAPI(jsonData, "SignUp", null);
    print("this is response $response");
    if (response['status'] != 200) {
      _registeredInStatus = Status.Failure;
      _registerErrorMsg = response['message'];
      notifyListeners();
      return false;
    } else {
      _host = response["messaging_server_map"]["host"];
      _port = response["messaging_server_map"]["port"];
      SharedPref sharedPref = SharedPref();
      sharedPref.save("authUser", response);
      sharedPref.save("project_id", projectId);
      sharedPref.save("tenant_url", tenantUrl);
      _registeredInStatus = Status.Registered;
      _loggedInStatus = Status.LoggedIn;
      _user = User.fromJson(response);
      notifyListeners();
      return true;
    }
  }

  login(String email, password) async {
    _loggedInStatus = Status.Loading;
    notifyListeners();

    Map<String, dynamic> jsonData = {
      "email": email,
      "password": password,
      "project_id": _projectId,
    };
    _projectId = project == "" ? project_id : project;
    _tenantUrl = url == "" ? tenant_url : url;
    final response = await callAPI(jsonData, "Login", null);
    print("this is response of login api $response");
    if (response['status'] != 200) {
      _loggedInStatus = Status.Failure;
      _loginErrorMsg = response['message'];
      notifyListeners();
    } else {
      _host = response["messaging_server_map"]["host"];
      _port = response["messaging_server_map"]["port"];
      print("this is host ${_host}");
      SharedPref sharedPref = SharedPref();
      sharedPref.save("authUser", response);
      sharedPref.save("project_id", projectId);
      sharedPref.save("tenant_url", tenantUrl);
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();
      _user = User.fromJson(response);
    }
  }

  logout() {
    SharedPref sharedPref = SharedPref();
    sharedPref.remove("authUser");
    _loggedInStatus = Status.LoggedOut;
    _user = null;
    sharedPref.remove("project_id");
    sharedPref.remove("tenant_url");
    _projectId = '';
    _tenantUrl = '';
    notifyListeners();
  }

  isUserLogedIn() async {
    final authUser = await _sharedPref.read("authUser");
    final projId = await _sharedPref.read("project_id");
    final tenantURL = await _sharedPref.read("tenant_url");
    // print(
    //     "this is authUser ${jsonDecode(authUser)["messaging_server_map"]["host"]}");
    //print("this is authUser port ${jsonDecode(authUser)}");
    if (authUser == null) {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
    } else {
      _loggedInStatus = Status.LoggedIn;
      _host = jsonDecode(authUser)["messaging_server_map"]["host"];
      _port = jsonDecode(authUser)["messaging_server_map"]["port"];
      _projectId = jsonDecode(projId.toString());
      _tenantUrl = jsonDecode(tenantURL.toString());
      print("host is $_host $_port");
      _user = User.fromJson(jsonDecode(authUser));
      notifyListeners();
    }
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
