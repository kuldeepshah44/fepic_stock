import 'dart:convert';

import 'package:fepic_stock/utility/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ChalanDetailModel with ChangeNotifier {
  List<ChalanDetailModelParam> chalanDetailModelList = [];
  ChalanDetailModelParam detailModelParam;
  final _fetchChalanDetail = BehaviorSubject<List<ChalanDetailModelParam>>();

  Observable<List<ChalanDetailModelParam>> get getAllChalanDetail =>
      _fetchChalanDetail.stream;

  void addData(Map<String, dynamic> json) {
    chalanDetailModelList.add(ChalanDetailModelParam.fromJson(json));
  }

  void setList(List<ChalanDetailModelParam> list)
  {
    chalanDetailModelList=list;
  }

  List<ChalanDetailModelParam> getList() {
    return chalanDetailModelList;
  }

  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData = false;

    try {
      chalanDetailModelList.clear();

      await Api()
          .getPostData(send_post_data, params, false, load, contexta, _scaffoldKey,
          isfullresponce: true)
          .then((value) {

        if (value.toString() != "null") {
          var tagsJson = jsonDecode(value);
          if (!tagsJson['status']) {
            IsData = false;
            detailModelParam=null;
          } else {
            IsData = true;
            tagsJson['data'].forEach((value1) {
              addData(value1);
            });
           _fetchChalanDetail.sink.add(chalanDetailModelList);
          }
        }

        notifyListeners();
      });

      return IsData;
    } catch (err, trace) {
      debugPrint(trace.toString());
      detailModelParam=null;
      notifyListeners();
      return IsData;
    }
  }
}

class ChalanDetailModelParam {
  String chalan_log_id;
  String chalan_id;
  String chalan_log_from;
  String chalan_log_to;
  String chalan_log_qty;
  String chalan_log_status;
  String chalan_log_desc;
  String chalan_log_Added_on;

  ChalanDetailModelParam(
      {this.chalan_log_id,
      this.chalan_id,
      this.chalan_log_from,
      this.chalan_log_to,
      this.chalan_log_qty,
      this.chalan_log_status,
      this.chalan_log_desc,
      this.chalan_log_Added_on});

  factory ChalanDetailModelParam.fromJson(Map<String, dynamic> json)=>
    ChalanDetailModelParam(
      chalan_log_id: json["chalan_log_id"],
      chalan_id: json["chalan_id"],
      chalan_log_from: json["chalan_log_from"],
      chalan_log_to: json["chalan_log_to"],
      chalan_log_qty: json["chalan_log_qty"],
      chalan_log_status: json["chalan_log_status"],
      chalan_log_desc: json["chalan_log_desc"],
      chalan_log_Added_on: json["chalan_log_Added_on"],
    );

}
