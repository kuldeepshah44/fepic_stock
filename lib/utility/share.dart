import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:fepic_stock/model/notification_model.dart';
import 'package:fepic_stock/model/year_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Share {
  String financialYear = "";
  SharedPreferences prefs;
  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);
    String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

  int HexColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  Future<String> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  void error_message(
      GlobalKey<ScaffoldState> _scaffoldKey, String value, bool type) {
    // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    FocusScope.of(Get.context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      //margin: EdgeInsets.only(bottom: 100),
      behavior: SnackBarBehavior.floating,
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: type ? Colors.green : Colors.red,
      duration: Duration(seconds: 3),
    ));
  }

  void show_Dialog(
      BuildContext context, String message, String title, bool status) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(
              message,
              style: TextStyle(
                  color: status ? Colors.black : Colors.red, fontSize: 16),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> getAllNewUserNotificationList(
      BuildContext context,
      GlobalKey<ScaffoldState> scaffoldState,
      NotificationModel notificationModel,
      String uid,
      String financialYear,
      bool status,
      int page) async {
    Map<String, dynamic> param = {
      "searchField": "",
      "session_admin_id": uid,
      "sessionYear": financialYear,
      "page": page.toString(),
      "api_name": "viewAllNewListProcess",
    };
    // print(param);

    bool Isload = await notificationModel.fetchList(
        context, param, scaffoldState, status, false);
  }

  Future<String> currentFinancialYear()
  {
    YearModel yearModel=new YearModel();
    return yearModel.getCurrentYear();
  }

  Future<void> setCurrentYear(String yearmodelDataList)
  async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("current_year", yearmodelDataList);
  }

}
