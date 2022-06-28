import 'dart:async';
import 'dart:io';

import 'package:fepic_stock/activity/master/chalan_master_activity.dart';
import 'package:fepic_stock/activity/user_screen/new_list_activity.dart';
import 'package:fepic_stock/model/notification_model.dart';
import 'package:fepic_stock/screen/homeScreen.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PushNotification {
  BuildContext context;

  PushNotification({this.context});

  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool _fromTop = true;
  bool called = false;
  static const platform = MethodChannel('com.siliconleaf.fepic_stock');
  StreamSubscription iosSubscription;

  void getPushNotification(
      bool IsNotification,
      GlobalKey<ScaffoldState> scaffoldState,
      NotificationModel notificationModel,
      String uid,
      String financialYear) {
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {});

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    if (IsNotification) {
      _fcm.configure(onMessage: (Map<String, dynamic> message) async {
        called = true;
        String value1 = "";
        String flag = "";
        if (Platform.isIOS) {
          if (message['aps'] != null && message['aps']['alert'] != null) {
            message['notification'] = message['aps']['alert'];
          }
          if (message['notification'] != null) {
            message['data'] = message['notification'];
          }
        }
        value1 = message['data']['body'];
        flag = message['data']['type'];
        if (message['data']['image'] == null) {
          message['data']['image'] = "";
        }


        getData(flag,scaffoldState,notificationModel,uid,financialYear);
        showGeneralDialog(
          barrierLabel: "Label",
          barrierDismissible: true,
          barrierColor: Colors.white10,
          transitionDuration: Duration(milliseconds: 700),
          context: context,
          pageBuilder: (context, anim1, anim2) {
            return GestureDetector(
              onTap: () {
                _onSubmitted(value1, 'resume', flag);
              },
              child: Align(
                alignment:
                    _fromTop ? Alignment.topCenter : Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            height: 30,
                            child: Image.asset('images/logo.png',
                                fit: BoxFit.contain)),
                      ),
                      Flexible(
                        child: Text(
                          message['data']['title'],
                          style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          message['data']['body'],
                          style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.none,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  margin:
                      EdgeInsets.only(top: 50, left: 12, right: 12, bottom: 50),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black87,
                          blurRadius: 1.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ]),
                ),
              ),
            );
          },
          transitionBuilder: (context, anim1, anim2, child) {
            return SlideTransition(
              position:
                  Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
                      .animate(anim1),
              child: child,
            );
          },
        );
      }, onLaunch: (Map<String, dynamic> message) async {
        called = true;
        String value1 = "";
        String flag = "";
        if (Platform.isIOS) {
          if (message['aps'] != null && message['aps']['alert'] != null) {
            message['notification'] = message['aps']['alert'];
          }
          if (message['notification'] != null) {
            message['data'] = message['notification'];
          }
        }
        value1 = message['data']['body'];
        flag = message['data']['type'];
        _onSubmitted(value1, 'launch', flag);
      }, onResume: (Map<String, dynamic> message) async {
        called = true;
        String value1 = "";
        String flag = "";
        if (Platform.isIOS) {
          if (message['aps'] != null && message['aps']['alert'] != null) {
            message['notification'] = message['aps']['alert'];
          }
          if (message['notification'] != null) {
            message['data'] = message['notification'];
          }
        }
        value1 = message['data']['body'];
        flag = message['data']['type'];
        _onSubmitted(value1, 'resume', flag);
      });
//kul
    } else {
      _fcm.configure(onMessage: (Map<String, dynamic> message) async {
        called = true;
        String value1 = "";
        String flag = "";
        if (Platform.isIOS) {
          if (message['aps'] != null && message['aps']['alert'] != null) {
            message['notification'] = message['aps']['alert'];
          }
          if (message['notification'] != null) {
            message['data'] = message['notification'];
          }
        }
        value1 = message['data']['body'];
        flag = message['data']['type'];

        if (message['data']['image'] == null) {
          message['data']['image'] = "";
        }
        getData(flag,scaffoldState,notificationModel,uid,financialYear);
        showGeneralDialog(
          barrierLabel: "Label",
          barrierDismissible: true,
          barrierColor: Colors.white10,
          transitionDuration: Duration(milliseconds: 700),
          context: context,
          pageBuilder: (context, anim1, anim2) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _onSubmitted(value1, 'resume', flag);
              },
              child: Align(
                alignment:
                    _fromTop ? Alignment.topCenter : Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            height: 30,
                            child: Image.asset('images/logo.png',
                                fit: BoxFit.contain)),
                      ),
                      Flexible(
                        child: Text(
                          message['data']['title'],
                          style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          message['data']['body'],
                          style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.none,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  margin:
                      EdgeInsets.only(top: 50, left: 12, right: 12, bottom: 50),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black87,
                          blurRadius: 1.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ]),
                ),
              ),
            );
          },
          transitionBuilder: (context, anim1, anim2, child) {
            return SlideTransition(
              position:
                  Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
                      .animate(anim1),
              child: child,
            );
          },
        );
      }, onResume: (Map<String, dynamic> message) async {
        called = true;
        String value1 = "";
        String flag = "";
        if (Platform.isIOS) {
          if (message['aps'] != null && message['aps']['alert'] != null) {
            message['notification'] = message['aps']['alert'];
          }
          if (message['notification'] != null) {
            message['data'] = message['notification'];
          }
        }
        value1 = message['data']['body'];
        flag = message['data']['type'];
        _onSubmitted(value1, 'resume', flag);
      });
    }
  }

  void getData(String type, GlobalKey<ScaffoldState> scaffoldState,
      NotificationModel notificationModel,
      String uid,
      String financialYear) {
    if(type=="New Chalan")
      {
        Share().getAllNewUserNotificationList(context,scaffoldState,notificationModel,uid.toString(),financialYear,false,1);
      }
  }

  _onSubmitted(String value, String type, String flag) {
    //Navigator.of(context).pop();
    if (flag == "New Chalan") {
      Get.to(NewUserListActivity());
    } else if (flag == "Chalan") {
      Get.to(ChalanMasterNewActivity());
    } else {}
  }
}
