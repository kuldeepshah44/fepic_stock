import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/api.dart';
import 'package:rxdart/rxdart.dart';


class AlterChalanModel with ChangeNotifier {
  List<AlterChalanModelParam> alterChalanModelList = [];

  final _fetchAlterChalan = BehaviorSubject<List<AlterChalanModelParam>>();
  Observable<List<AlterChalanModelParam>> get getAllAlterChalan => _fetchAlterChalan.stream;


  void setList(List<AlterChalanModelParam> list) {
    alterChalanModelList = list;
  }

  void addData(Map<String, dynamic> singledata) {
    alterChalanModelList.add(AlterChalanModelParam.fromJson(singledata));
  }

  List<AlterChalanModelParam> getList() {
    return alterChalanModelList;
  }


  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData=false;
    try {
      print("CONTEXT ${contexta}");

      if (params['page'].toString() == "1") {
        alterChalanModelList.clear();
      }
      alterChalanModelList.clear();


      await Api()
          .getPostData(send_post_data, params, false, load, contexta, _scaffoldKey,
          isfullresponce: true)
          .then((value) {
        // log("reponse==tre=${value}");
        if (value.toString() != "null") {
          IsData=true;

          var tagsJson = jsonDecode(value);
          if (!tagsJson['status']) {
            IsData = false;
          } else {
            IsData = true;
            tagsJson['data'].forEach((value1) {
              addData(value1);
            });
            _fetchAlterChalan.add(alterChalanModelList);
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

class AlterChalanModelParam {
  String Alter_chalan_master_id;
  String Alter_chalan_master_chalan_no;
  String Alter_chalan_master_lot_no;
  String Alter_chalan_master_Sent_to;
  String Alter_chalan_master_qty;
  String Alter_chalan_master_complete_qty;
  String Alter_chalan_master_remain_qty;
  String Alter_chalan_master_status;
  String Alter_chalan_master_Added_on;
  String alter_chalan_financial_year;
  String admin_name;

  AlterChalanModelParam({
    this.Alter_chalan_master_id,
    this.Alter_chalan_master_chalan_no,
    this.Alter_chalan_master_lot_no,
    this.Alter_chalan_master_Sent_to,
    this.Alter_chalan_master_qty,
    this.Alter_chalan_master_complete_qty,
    this.Alter_chalan_master_remain_qty,
    this.Alter_chalan_master_status,
    this.Alter_chalan_master_Added_on,
    this.alter_chalan_financial_year,
    this.admin_name,
  });

  factory AlterChalanModelParam.fromJson(Map<String, dynamic> json) => AlterChalanModelParam(
    Alter_chalan_master_id: json["Alter_chalan_master_id"] ,
    Alter_chalan_master_chalan_no: json["Alter_chalan_master_chalan_no"],
    Alter_chalan_master_lot_no: json["Alter_chalan_master_lot_no"],
    Alter_chalan_master_Sent_to: json["Alter_chalan_master_Sent_to"],
    Alter_chalan_master_qty: json["Alter_chalan_master_qty"],
    Alter_chalan_master_complete_qty: json["Alter_chalan_master_complete_qty"],
    Alter_chalan_master_remain_qty: json["Alter_chalan_master_remain_qty"],
    Alter_chalan_master_status: json["Alter_chalan_master_status"],
    Alter_chalan_master_Added_on: json["Alter_chalan_master_Added_on"],
    alter_chalan_financial_year: json["alter_chalan_financial_year"],
    admin_name: json["admin_name"],

  );

}