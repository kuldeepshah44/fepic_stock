import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/api.dart';
import 'package:rxdart/rxdart.dart';

class ChalanListModel with ChangeNotifier {
  List<ChalanModelData> chalanModelList = [];

  final _fetchChalanList = BehaviorSubject<List<ChalanModelData>>();
  Observable<List<ChalanModelData>> get getAllChalanList => _fetchChalanList.stream;

  void addData(Map<String, dynamic> singledata) {
    chalanModelList.add(ChalanModelData.fromJson(singledata));
  }

  List<ChalanModelData> getChalanList()
  {
    return chalanModelList;
  }

  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData = false;
    try {
      String valueType = params['value'].toString();
      if( params['page']=="1") {
        chalanModelList.clear();
      }
      chalanModelList.clear();
      await Api()
          .getPostData(send_post_data, params, false, load, contexta, _scaffoldKey,
          isfullresponce: true)
          .then((value) {
        log("reponse==tre=${value}");
        if (value.toString() != "null") {
          var tagsJson = jsonDecode(value);
          if (!tagsJson['status']) {
            IsData = false;
          } else {
            IsData = true;
            tagsJson['data']['chalan'].forEach((value1) {
              addData(value1);
            });
            _fetchChalanList.sink.add(chalanModelList);
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

class ChalanModelData {
  String chalan_id;
  String chalan_no;
  String delivery_chalan_no;
  String lot_no;
  String chalan_sent_by;
  String chalan_sent_to;
  String product_id;
  String sub_product_id;
  String chalan_qty;
  String chalan_process_qty;
  String chalan_complete_qty;
  String chalan_remain_qty;
  String chalan_metere;
  String chalan_rate;
  String chalan_status;
  String chalan_main_status;
  String chalan_alter_accept;
  String chalan_Added_on;
  String chalan_Ended_On;
  String chalan_financial_year;
  String admin_name;

  String product_name;
  String product_design_no;
  String sub_product_name;
  String type_name,sent_chalan_by,sent_chalan_to,count_remark;

  ChalanModelData({
    this.chalan_id,
    this.chalan_no,
    this.delivery_chalan_no,
    this.lot_no,
    this.chalan_sent_by,
    this.chalan_sent_to,
    this.product_id,
    this.sub_product_id,
    this.chalan_qty,
    this.chalan_process_qty,
    this.chalan_complete_qty,
    this.chalan_remain_qty,
    this.chalan_metere,
    this.chalan_rate,
    this.chalan_status,
    this.chalan_main_status,
    this.chalan_alter_accept,
    this.chalan_Added_on,
    this.chalan_Ended_On,
    this.chalan_financial_year,
    this.admin_name,
    this.product_name,
    this.product_design_no,
    this.sub_product_name,
    this.type_name,
    this.sent_chalan_by,
    this.sent_chalan_to,
    this.count_remark,
  });

  factory ChalanModelData.fromJson(Map<String, dynamic> json) =>
      ChalanModelData(
        chalan_id: json["chalan_id"],
        chalan_no: json["chalan_no"],
        delivery_chalan_no: json["delivery_chalan_no"],
        lot_no: json["lot_no"],
        chalan_sent_by: json["chalan_sent_by"],
        chalan_sent_to: json["chalan_sent_to"],
        product_id: json["product_id"],
        sub_product_id: json["sub_product_id"],
        chalan_qty: json["chalan_qty"],
        chalan_process_qty: json["chalan_process_qty"],
        chalan_complete_qty: json["chalan_complete_qty"],
        chalan_remain_qty: json["chalan_remain_qty"],
        chalan_metere: json["chalan_metere"],
        chalan_rate: json["chalan_rate"],
        chalan_status: json["chalan_status"],
        chalan_main_status: json["chalan_main_status"],
        chalan_alter_accept: json["chalan_alter_accept"],
        chalan_Added_on: json["chalan_Added_on"],
        chalan_Ended_On: json["chalan_Ended_On"],
        chalan_financial_year: json["chalan_financial_year"],
        admin_name: json["admin_og_name"],
        product_name: json["product_name"],
        product_design_no: json["product_design_no"],
        sub_product_name: json["sub_product_name"],
        type_name: json["type_name"],
        sent_chalan_by: json["sent_chalan_by"],
        sent_chalan_to: json["sent_chalan_to"],
        count_remark: json["count_remark"],

      );


}


