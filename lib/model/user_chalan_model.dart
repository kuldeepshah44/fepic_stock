import 'dart:convert';
import 'dart:developer';

import 'package:fepic_stock/utility/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class UserChalanModel with ChangeNotifier {
  List<UserChalanParamPending> userChalanPendingList = [];
  List<UserChalanParamRunning> userChalanRunningList = [];
  List<UserChalanParamDone> userChalanDoneList = [];

  final _fetchUserChalanPendingData =
      BehaviorSubject<List<UserChalanParamPending>>();

  Observable<List<UserChalanParamPending>> get getAllUserPendingChalan =>
      _fetchUserChalanPendingData;

  final _fetchUserChalanRunninData =
      BehaviorSubject<List<UserChalanParamRunning>>();

  Observable<List<UserChalanParamRunning>> get getAllUserRunningChalan =>
      _fetchUserChalanRunninData;

  final _fetchUserChalanDoneData = BehaviorSubject<List<UserChalanParamDone>>();

  Observable<List<UserChalanParamDone>> get getAllUserDoneChalan =>
      _fetchUserChalanDoneData;

  void addData(Map<String, dynamic> json, String type) {
    print("type===${type}");
    if (type == "Pending") {
      userChalanPendingList.add(UserChalanParamPending.fromJson(json));
    } else if (type == "Running") {
      userChalanRunningList.add(UserChalanParamRunning.fromJson(json));
    } else if (type == "Done") {
      userChalanDoneList.add(UserChalanParamDone.fromJson(json));
    }
  }

  List<UserChalanParamPending> getPendingList() {
    return userChalanPendingList;
  }
  List<UserChalanParamRunning> getRunningList() {
    return userChalanRunningList;
  }
  List<UserChalanParamDone> getDoneList() {
    return userChalanDoneList;
  }

  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData = false;
    try {
      if (params['page'] == "1") {}
      userChalanPendingList.clear();
      userChalanRunningList.clear();
      userChalanDoneList.clear();
      await Api()
          .getPostData(
              send_post_data, params, false, load, contexta, _scaffoldKey,
              isfullresponce: true)
          .then((value) {
        log("reponse==tre=$value");
        if (value.toString() != "null") {
          var tagsJson = jsonDecode(value);

          if (!tagsJson['status']) {
            IsData = false;
          } else {
            IsData = true;

            tagsJson['data'].forEach((value1) {
              addData(value1, params['list_status']);
            });
            if (params['list_status'] == "Pending") {
              _fetchUserChalanPendingData.sink.add(userChalanPendingList);
            } else if (params['list_status'] == "Running") {
              _fetchUserChalanRunninData.sink.add(userChalanRunningList);
            }
            else if (params['list_status'] == "Done") {
              _fetchUserChalanDoneData.sink.add(userChalanDoneList);
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

class UserChalanParamPending {
  String designno, pieces, chalanno, lotno, chalan_count_remain;
  ChalanDetailParam chalanDetailParam;
  List<ButtonListPending> chalanButtonTypeParam;
  ChalanRemarkDetail chalanRemarkDetail;

  UserChalanParamPending(
      {this.designno,
      this.pieces,
      this.chalanno,
      this.lotno,
      this.chalan_count_remain,
      this.chalanDetailParam,
      this.chalanButtonTypeParam,
      this.chalanRemarkDetail});

  factory UserChalanParamPending.fromJson(Map<String, dynamic> map) =>
      UserChalanParamPending(
        designno: map['designno'],
        pieces: map['pieces'].toString(),
        chalanno: map['chalanno'],
        lotno: map['lotno'],
        chalan_count_remain: map['chalan_count_remain'],
        chalanDetailParam: ChalanDetailParam.fromJson(
            map['action']['btn']['detail']['parameter_to_pass']),
        chalanButtonTypeParam: List<ButtonListPending>.from(map['action']['btn']
                ['type']
            .map((x) => ButtonListPending.fromJson(x))),
        chalanRemarkDetail: ChalanRemarkDetail.fromJson(
            map['action']['btn']['remark']['parameter_to_pass']),
      );
}

class UserChalanParamRunning {
  String notification_id,designno, pieces, chalanno, lotno, chalan_count_remain;
  ChalanDetailParam chalanDetailParam;
  List<ButtonListRunning> chalanButtonTypeParam;
  ChalanRemarkDetail chalanRemarkDetail;

  UserChalanParamRunning(
      {
        this.notification_id,
        this.designno,
      this.pieces,
      this.chalanno,
      this.lotno,
      this.chalan_count_remain,
      this.chalanDetailParam,
      this.chalanButtonTypeParam,
      this.chalanRemarkDetail});

  factory UserChalanParamRunning.fromJson(Map<String, dynamic> map) =>
      UserChalanParamRunning(
        notification_id: map['notification_id'],
        designno: map['designno'],
        pieces: map['pieces'].toString(),
        chalanno: map['chalanno'],
        lotno: map['lotno'],
        chalan_count_remain: map['chalan_count_remain'],
        chalanDetailParam: ChalanDetailParam.fromJson(
            map['action']['btn']['detail']['parameter_to_pass']),
        chalanButtonTypeParam: List<ButtonListRunning>.from(map['action']['btn']
                ['type']
            .map((x) => ButtonListRunning.fromJson(x))),
        chalanRemarkDetail: ChalanRemarkDetail.fromJson(
            map['action']['btn']['remark']['parameter_to_pass']),
      );
}

class UserChalanParamDone {
  String designno, pieces, chalanno, lotno, chalan_count_remain;
  ChalanDetailParam chalanDetailParam;
  ChalanRemarkDetail chalanRemarkDetail;

  UserChalanParamDone(
      {this.designno,
      this.pieces,
      this.chalanno,
      this.lotno,
      this.chalan_count_remain,
      this.chalanDetailParam,
      this.chalanRemarkDetail});

  factory UserChalanParamDone.fromJson(Map<String, dynamic> map) =>
      UserChalanParamDone(
        designno: map['designno'],
        pieces: map['pieces'].toString(),
        chalanno: map['chalanno'],
        lotno: map['lotno'],
        chalan_count_remain: map['chalan_count_remain'],
        chalanDetailParam: ChalanDetailParam.fromJson(
            map['action']['btn']['detail']['parameter_to_pass']),
        chalanRemarkDetail: ChalanRemarkDetail.fromJson(
            map['action']['btn']['remark']['parameter_to_pass']),
      );
}

class ChalanDetailParam {
  String chalan_no,
      lot_no,
      chalan_Added_on,
      product_name,
      sub_product_name,
      product_design_no,
      chalan_qty,
      admin_og_name;

  ChalanDetailParam(
      {this.chalan_no,
      this.lot_no,
      this.chalan_Added_on,
      this.product_name,
      this.sub_product_name,
      this.product_design_no,
      this.chalan_qty,
      this.admin_og_name});

  factory ChalanDetailParam.fromJson(Map<String, dynamic> json) =>
      ChalanDetailParam(
        chalan_no: json['chalan_no'],
        lot_no: json['lot_no'],
        chalan_Added_on: json['chalan_Added_on'],
        product_name: json['product_name'],
        sub_product_name: json['sub_product_name'],
        product_design_no: json['product_design_no'],
        chalan_qty: json['chalan_qty'],
        admin_og_name: json['admin_og_name'],
      );
}

class ButtonListPending {
  String btn_name;
  ChalanTypePending parameter_to_pass;

  ButtonListPending({this.btn_name, this.parameter_to_pass});

  factory ButtonListPending.fromJson(Map<String, dynamic> json) =>
      ButtonListPending(
        btn_name: json['btn'],
        parameter_to_pass:
            ChalanTypePending.fromJson(json['parameter_to_pass']),
      );
}

class ButtonListRunning {
  String btn_name;
  ChalanTypeRunning parameter_to_pass;

  ButtonListRunning({this.btn_name, this.parameter_to_pass});

  factory ButtonListRunning.fromJson(Map<String, dynamic> json) =>
      ButtonListRunning(
        btn_name: json['btn'],
        parameter_to_pass:
            ChalanTypeRunning.fromJson(json['parameter_to_pass']),
      );
}

class ChalanTypePending {
  String notification_id,
      chalan_no,
      lot_no,
      chalan_Added_on,
      product_name,
      sub_product_name,
      product_design_no,
      chalan_qty,
      admin_og_name;

  ChalanTypePending(
      {this.notification_id,
      this.chalan_no,
      this.lot_no,
      this.chalan_Added_on,
      this.product_name,
      this.sub_product_name,
      this.product_design_no,
      this.chalan_qty,
      this.admin_og_name});

  factory ChalanTypePending.fromJson(Map<String, dynamic> json) =>
      ChalanTypePending(
        notification_id: json['notification_id'],
        chalan_no: json['chalan_no'],
        lot_no: json['lot_no'],
        chalan_Added_on: json['chalan_Added_on'],
        product_name: json['product_name'],
        sub_product_name: json['sub_product_name'],
        product_design_no: json['product_design_no'],
        chalan_qty: json['chalan_qty'],
        admin_og_name: json['admin_og_name'],
      );
}

class ChalanTypeRunning {
  String chalan_id, type;

  ChalanTypeRunning({this.chalan_id, this.type});

  factory ChalanTypeRunning.fromJson(Map<String, dynamic> json) =>
      ChalanTypeRunning(
        chalan_id: json['chalan_id'],
        type: json['type'],
      );
}

class ChalanRemarkDetail {
  String chalan_id;

  ChalanRemarkDetail({this.chalan_id});

  factory ChalanRemarkDetail.fromJson(Map<String, dynamic> json) =>
      ChalanRemarkDetail(
        chalan_id: json['chalan_id'],
      );
}
