import 'dart:convert';

import 'package:fepic_stock/utility/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class NotificationModel with ChangeNotifier {
  List<NotificationModelParam> notificationModelList = [];
  List<NewUserListNotificationParam> newUserListNotificationList = [];

  final _notificationCounter = BehaviorSubject<int>();
  Observable<int> get notificationCount => _notificationCounter.stream;

  final _fetchNotificationData =
      BehaviorSubject<List<NotificationModelParam>>();

  Observable<List<NotificationModelParam>> get getAllNotifiaction =>
      _fetchNotificationData.stream;

  final _fetchNewUserListNotificationData =
      BehaviorSubject<List<NewUserListNotificationParam>>();

  Observable<List<NewUserListNotificationParam>>
      get getAllNewUserListNotifiaction =>
          _fetchNewUserListNotificationData.stream;

  void setList(List<NotificationModelParam> list) {
    notificationModelList = list;
  }

  void addData(Map<String, dynamic> singledata) {
    notificationModelList.add(NotificationModelParam.fromJson(singledata));
  }

  void addNewUserNotificationData(Map<String, dynamic> singledata) {
    newUserListNotificationList
        .add(NewUserListNotificationParam.fromJson(singledata));
  }

  List<NotificationModelParam> getList() {
    return notificationModelList;
  }

  List<NewUserListNotificationParam> getNewUserNotificationList() {
    return newUserListNotificationList;
  }

  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData = false;
    try {
     // print("CONTEXT ${contexta}");

      if (params['page'].toString() == "1") {
        if (params['api_name'] == "viewAllNewListProcess") {
          _notificationCounter.sink.add(0);
          newUserListNotificationList.clear();
        } else {
          notificationModelList.clear();
        }
      }
      if (params['api_name'] == "viewAllNewListProcess") {
        _notificationCounter.sink.add(0);
        newUserListNotificationList.clear();
      } else {
        notificationModelList.clear();
      }

      await Api()
          .getPostData(
              send_post_data, params, false, load, contexta, _scaffoldKey,
              isfullresponce: true)
          .then((value) {
        if (value.toString() != "null") {
          IsData = true;

          var tagsJson = jsonDecode(value);
          if (!tagsJson['status']) {
            IsData = false;
          } else {
            IsData = true;
            tagsJson['data'].forEach((value1) {
              if (params['api_name'] == "viewAllNewListProcess") {
               addNewUserNotificationData(value1);
              } else {
                addData(value1);
              }

            });

            if (params['api_name'] == "viewAllNewListProcess") {

              print("notification===${newUserListNotificationList.length}");

              if(newUserListNotificationList.length > 0) {
                _fetchNewUserListNotificationData.add(
                    newUserListNotificationList);
                _notificationCounter.sink.add(
                    newUserListNotificationList.length);
              }
              else
                {
                  _notificationCounter.sink.add(0);
                }
            } else {
              _fetchNotificationData.add(notificationModelList);
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
}

class NotificationModelParam {
  String notification_id,
      notification_sent_by,
      notification_send_to,
      notification_description,
      notification_status,
      notification_type,
      notification_hide,
      chalan_id,
      notification_of_type,
      notification_Added_on,
      notification_financial_year,
      admin_og_name;

  NotificationModelParam(
      {this.notification_id,
      this.notification_sent_by,
      this.notification_send_to,
      this.notification_description,
      this.notification_status,
      this.notification_type,
      this.notification_hide,
      this.chalan_id,
      this.notification_of_type,
      this.notification_Added_on,
      this.notification_financial_year,
      this.admin_og_name});

  factory NotificationModelParam.fromJson(Map<String, dynamic> json) =>
      NotificationModelParam(
        notification_id: json["notification_id"],
        notification_sent_by: json["notification_sent_by"],
        notification_send_to: json["notification_send_to"],
        notification_description: json["notification_description"],
        notification_status: json["notification_status"],
        notification_type: json["notification_type"],
        notification_hide: json["notification_hide"],
        chalan_id: json["chalan_id"],
        notification_of_type: json["notification_of_type"],
        notification_Added_on: json["notification_Added_on"],
        notification_financial_year: json["notification_financial_year"],
        admin_og_name: json["admin_og_name"],
      );
}

class NewUserListNotificationParam {
  String notification_id,
      notification_sent_by,
      notification_send_to,
      notification_description,
      notification_status,
      notification_type,
      notification_hide,
      chalan_id,
      notification_of_type,
      notification_Added_on,
      notification_financial_year,
      product_design_no,
      chlan_qty;

  NewUserListNotificationParam({
    this.notification_id,
    this.notification_sent_by,
    this.notification_send_to,
    this.notification_description,
    this.notification_status,
    this.notification_type,
    this.notification_hide,
    this.chalan_id,
    this.notification_of_type,
    this.notification_Added_on,
    this.notification_financial_year,
    this.product_design_no,
    this.chlan_qty,
  });

  factory NewUserListNotificationParam.fromJson(Map<String, dynamic> json) =>
      NewUserListNotificationParam(
        notification_id: json["notification_id"],
        notification_sent_by: json["notification_sent_by"],
        notification_send_to: json["notification_send_to"],
        notification_description: json["notification_description"],
        notification_status: json["notification_status"],
        notification_type: json["notification_type"],
        notification_hide: json["notification_hide"],
        chalan_id: json["chalan_id"],
        notification_of_type: json["notification_of_type"],
        notification_Added_on: json["notification_Added_on"],
        notification_financial_year: json["notification_financial_year"],
        product_design_no: json["product_design_no"],
        chlan_qty: json["chlan_qty"],
      );
}

class OtherDetailUserNotification {
  String notification_id, product_design_no, chlan_qty;

  OtherDetailUserNotification(
      {this.notification_id, this.product_design_no, this.chlan_qty});

  factory OtherDetailUserNotification.fromJson(Map<String, dynamic> json) =>
      OtherDetailUserNotification(
        notification_id: json['notification_id'],
        product_design_no: json['product_design_no'],
        chlan_qty: json['chlan_qty'],
      );
}
