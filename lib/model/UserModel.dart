import 'dart:convert';

import 'package:fepic_stock/utility/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel with ChangeNotifier {
  UserDetails user;
  List<UserDetails> user_list = [];
  SharedPreferences prefs;
  final _fetchUser = BehaviorSubject<List<UserDetails>>();

  Observable<List<UserDetails>> get getAllUserlist => _fetchUser.stream;

  Future<void> saveUser(UserDetails user) async {
    try {
      prefs = await SharedPreferences.getInstance();
      prefs.setBool("IsLogin", true);
      prefs.setString("userid", user.admin_id.toString());
      prefs.setString("user_name", user.admin_name.toString());
      prefs.setString("mobile", user.admin_mobno.toString());
      prefs.setString("full_name", user.admin_og_name.toString());
      prefs.setString("user_type", user.admin_login_type.toString());
      prefs.setString("address", user.admin_address.toString());
      prefs.setString("gst", user.admin_gstin.toString());
    } catch (err) {
      debugPrint(err);
    }
  }

  Future<bool> login(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData = false;

    String api = "";
    if (params['type'] == "login") {
      // send_post_data=send_post_data1;
      api = send_post_data1;
    } else if (params['type'] == "all_user") {
      // send_post_data=getCommon;
      api = getCommon;
    }

    user_list.clear();
    try {
      await Api()
          .getPostData(api, params, false, load, contexta, _scaffoldKey,
              isfullresponce: true)
          .then((value) {
        // log("reponse==tre=${value}");
        if (value.toString() != "null") {
          IsData = true;

          var tagsJson = jsonDecode(value);
          if (!tagsJson['status']) {
            IsData = false;
          } else {
            IsData = true;
            tagsJson['data'].forEach((value1) {
              user = UserDetails.fromJson(value1);
              user_list.add(user);
            });
            if (params['type'] == "login") {
              saveUser(user);
            } else {
              _fetchUser.add(user_list);
            }
          }
        }

        notifyListeners();
      });

      return IsData;
    } catch (err, trace) {
      debugPrint(trace.toString());

      notifyListeners();
      return false;
    }
  }

  Future<String> getUserId() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("userid");
  }

  Future<String> getUserType() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_type");
  }

  Future<String> getPartyName() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("full_name");
  }

  Future<bool> IsLogin() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool("IsLogin");
  }

  void logOut() {
    prefs.clear();
  }
}

class UserDetails {
  String admin_id;
  String admin_name;
  String admin_password;
  String admin_og_name;
  String admin_address;
  String admin_mobno;
  String admin_gstin;
  String admin_type;
  String admin_login_type;
  String type_name;

  UserDetails.fromJson(Map<String, dynamic> parsedJson) {
    admin_id = parsedJson["admin_id"].toString();
    admin_name = parsedJson["admin_name"].toString();
    admin_password = parsedJson["admin_password"].toString();
    admin_og_name = parsedJson["admin_og_name"].toString();
    admin_address = parsedJson["admin_address"].toString();
    admin_mobno = parsedJson["admin_mobno"].toString();
    admin_gstin = parsedJson["admin_gstin"].toString();
    admin_type = parsedJson["admin_type"].toString();
    admin_login_type = parsedJson["admin_login_type"].toString();
    type_name = parsedJson["type_name"].toString();
  }
}
