import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/api.dart';
import 'package:rxdart/rxdart.dart';

class ChalanModel with ChangeNotifier {
  List<ChalanModelParam> chalanModelList = [];
  List<ChalanModelParam> financialYearModelList = [];
  List<ChalanModelParam> lot_noList = [];
  List<Chalan_Lot_No> chalan_lot_no_list = [];
 //String financialYear = "";

  final _fetchFinancialYear = BehaviorSubject<List<ChalanModelParam>>();
  Observable<List<ChalanModelParam>> get getAllFinancialYear =>
      _fetchFinancialYear.stream;

  final _fetchLotNo = BehaviorSubject<List<ChalanModelParam>>();
  Observable<List<ChalanModelParam>> get getAllLotNo => _fetchLotNo.stream;


  final _fetchChalanList = BehaviorSubject<List<ChalanModelParam>>();
  Observable<List<ChalanModelParam>> get getAllChalanList => _fetchChalanList.stream;

  void setList(List<ChalanModelParam> list, String type) {
    if (type == "lot_no") {
      lot_noList = list;
    } else if (type == "year") {
      financialYearModelList = list;
    } else if(type=="all") {
      chalanModelList = list;
    }
  }

  void addData(Map<String, dynamic> singledata, String type) {
    if (type == "lot_no") {
      lot_noList.add(ChalanModelParam.fromJson(singledata));
    } else if (type == "year") {
      financialYearModelList.add(ChalanModelParam.fromJson(singledata));
    } else if(type == "all") {
      chalanModelList.add(ChalanModelParam.fromJson(singledata));
    }
  }

  void addChalnNo(Map<String, dynamic> singledata) {
    chalan_lot_no_list.add(Chalan_Lot_No.fromJson(singledata));
  }

  List<ChalanModelParam> getChalanList() {
    return chalanModelList;
  }


  List<ChalanModelParam> getList() {
    return financialYearModelList;
  }

  List<ChalanModelParam> getLotNoList() {
    return lot_noList;
  }

  Future<Chalan_Lot_No> getChalanNo(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    chalan_lot_no_list.clear();
    Chalan_Lot_No chalan_lot_no;
    try {
      await Api()
          .getPostData(getCommon, params, false, load, contexta, _scaffoldKey,
              isfullresponce: true)
          .then((value) {
        log("reponse==tre=${value}");
        if (value.toString() != "null") {
          var tagsJson = jsonDecode(value);
         // financialYear = tagsJson['current_financial_year'];
          if (!tagsJson['status']) {
          } else {
            tagsJson['data'].forEach((value1) {
              addChalnNo(value1);
              //IsData=int.parse(value1['chalan_no']);
              //print("chalan_no===${value1['chalan_no']}");
            });
            chalan_lot_no = chalan_lot_no_list[0];
          }
        }

        notifyListeners();
      });

      return chalan_lot_no;
    } catch (err, trace) {
      debugPrint(trace.toString());

      notifyListeners();
      return chalan_lot_no;
    }
  }

  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData = false;
    try {
      String valueType = params['value'].toString();
      if (valueType == "lot_no") {
        lot_noList.clear();
      } else if (valueType == "year") {
        financialYearModelList.clear();
      }
      else if (valueType == "all"){
        if( params['page']=="1") {
          chalanModelList.clear();
        }
      }

      await Api()
          .getPostData(getCommon, params, false, load, contexta, _scaffoldKey,
              isfullresponce: true)
          .then((value) {
        log("reponse==tre=${value}");
        if (value.toString() != "null") {
          var tagsJson = jsonDecode(value);
          //financialYear = tagsJson['current_financial_year'];
          if (!tagsJson['status']) {
            IsData = false;
          } else {
            IsData = true;
            tagsJson['data'].forEach((value1) {
              addData(value1, valueType);
            });
            if (valueType == "lot_no") {
              _fetchLotNo.add(lot_noList);
            } else if (valueType == "year") {
              _fetchFinancialYear.add(financialYearModelList);
            }
            else if(valueType == "all"){
              _fetchChalanList.sink.add(chalanModelList);
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

class ChalanModelParam {
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
  String reciver;
  String product_name;
  String product_design_no;
  String sub_product_name;
  String unread;

  ChalanModelParam({
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
    this.reciver,
    this.product_name,
    this.product_design_no,
    this.sub_product_name,
    this.unread,
  });

  factory ChalanModelParam.fromJson(Map<String, dynamic> json) =>
      ChalanModelParam(
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
        reciver: json["reciver"],
        product_name: json["product_name"],
        product_design_no: json["product_design_no"],
        sub_product_name: json["sub_product_name"],
        unread: json["unread"],
      );

/* Map<String, dynamic> toJson() => {
    "sub_product_id": sub_product_id,
    "sub_product_name": sub_product_name,
    "product_id": product_id,
    "sub_product_Added_on": sub_product_Added_on,
  };*/
}

class Chalan_Lot_No {
  String chalan_no, lot_no;

  Chalan_Lot_No({this.chalan_no, this.lot_no});

  factory Chalan_Lot_No.fromJson(Map<String, dynamic> json) => Chalan_Lot_No(
        chalan_no: json["chalan_no"],
        lot_no: json["lot_no"],
      );
}




