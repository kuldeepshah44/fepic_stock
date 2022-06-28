import 'dart:convert';
import 'dart:developer';

import 'package:fepic_stock/utility/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LotModel with ChangeNotifier {
  List<LotModelParam> lotModelParamList = [];
  List<LotDetail> lotDetailList = [];
  List<AlterLotDetail> alterLotDetailList = [];

  // Lot list
  void addLotParam(Map<String, dynamic> json) {
    lotModelParamList.add(LotModelParam.fromJson(json));
  }

  List<LotModelParam> getLotList() {
    return lotModelParamList;
  }

  void addLotDetail(Map<String, dynamic> json) {
    lotDetailList.add(LotDetail.fromJson(json));
  }

  List<LotDetail> getLotDetailList() {
    return lotDetailList;
  }


  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData = false;
    try {
      if (params['page'] == "1") {
        //  lotOrderParamLiist.clear();
        lotModelParamList.clear();
        //  lotDetailParamList.clear();
      }
      lotModelParamList.clear();

      await Api()
          .getPostData(
              send_post_data, params, false, load, contexta, _scaffoldKey,
              isfullresponce: true)
          .then((value) {
        log("reponse==tre=${value}");
        if (value.toString() != "null") {
          var tagsJson = jsonDecode(value);

          if (!tagsJson['status']) {
            IsData = false;
          } else {
            IsData = true;

            tagsJson['data']['data'].forEach((value1) {
              addLotParam(value1);
//print("action==>${value1['action']['btn']['order']['btn']}");
              //addOrderLot(value1['action']['btn']['order']['parameter_to_pass']);
              //addLotDetal(value1['action']['btn']['detail']['parameter_to_pass']);
            });
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

  Future<bool> fetchLotDetail(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData = false;
    try {
      lotDetailList.clear();

      await Api()
          .getPostData(
              send_post_data, params, false, load, contexta, _scaffoldKey,
              isfullresponce: true)
          .then((value) {
        if (value.toString() != "null") {
          var tagsJson = jsonDecode(value);

          if (!tagsJson['status']) {
            IsData = false;
          } else {
            IsData = true;

            tagsJson['data'].forEach((value1) {
              addLotDetail(value1);
            });
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


  void addAlterLotDetail(Map<String, dynamic> json) {
    alterLotDetailList.add(AlterLotDetail.fromJson(json));
  }

  List<AlterLotDetail> getAlterLotDetailList() {
    return alterLotDetailList;
  }

  Future<bool> fetchAlterLotProcess(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData = false;
    alterLotDetailList.clear();
    try {

      await Api()
          .getPostData(
          send_post_data, params, false, load, contexta, _scaffoldKey,
          isfullresponce: true)
          .then((value) {

            print("value====${value}");
        if (value.toString() != "null") {
          var tagsJson = jsonDecode(value);
          if (!tagsJson['status']) {
            IsData = false;
          } else {
            IsData = true;
            addAlterLotDetail(tagsJson);
          /*  tagsJson.forEach((value1) {

            });*/
          }
        }
        notifyListeners();
      });
      return IsData;
    } catch (err, trace) {
      debugPrint(trace.toString());
      notifyListeners();
      return IsData;
    }
  }
}

class LotModelParam {
  String lotno, chalantotal, designo, processqty, oredrqty, reaminqty, date;
  Map<String, dynamic> btns;
  LotModelParam({
    this.lotno,
    this.chalantotal,
    this.designo,
    this.processqty,
    this.oredrqty,
    this.reaminqty,
    this.date,
    this.btns,
  });

  factory LotModelParam.fromJson(Map<String, dynamic> json) => LotModelParam(
        lotno: json["lotno"],
        chalantotal: json["chalantotal"],
        designo: json["designo"],
        processqty: json["processqty"],
        oredrqty: json["oredrqty"],
        reaminqty: json["reaminqty"],
        date: json["date"],
        btns: json['action']['btn'],
      );
}

class LotDetail {
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
  String chalan_log_id;
  String chalan_log_from;
  String chalan_log_to;
  String chalan_log_qty;
  String chalan_log_status;
  String chalan_log_desc;
  String chalan_log_Added_on;

  LotDetail(
      {this.chalan_id,
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
      this.chalan_log_id,
      this.chalan_log_from,
      this.chalan_log_to,
      this.chalan_log_qty,
      this.chalan_log_status,
      this.chalan_log_desc,
      this.chalan_log_Added_on});

  factory LotDetail.fromJson(Map<String, dynamic> json) => LotDetail(
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
        chalan_log_id: json["chalan_log_id"],
        chalan_log_from: json["chalan_log_from"],
        chalan_log_to: json["chalan_log_to"],
        chalan_log_qty: json["chalan_log_qty"],
        chalan_log_status: json["chalan_log_status"],
        chalan_log_desc: json["chalan_log_desc"],
        chalan_log_Added_on: json["chalan_log_Added_on"],
      );
}

class AlterLotDetail {
  bool status;
  String message, new_alter_chalan_no;
  List<FetchParty> partyList;

  AlterLotDetail(
      {this.status, this.message, this.new_alter_chalan_no, this.partyList});

  factory AlterLotDetail.fromJson(Map<String, dynamic> map) =>
      AlterLotDetail(
        status: map["status"],
        message: map["message"],
        new_alter_chalan_no: map["new_alter_chalan_no"],
        partyList: List<FetchParty>.from(
            map['data'].map((x) => FetchParty.fromJson(x))),
      );
}

class FetchParty {
  String admin_id, admin_og_name, type_name;

  FetchParty({this.admin_id, this.admin_og_name, this.type_name});

  factory FetchParty.fromJson(Map<String, dynamic> map) => FetchParty(
        admin_id: map["admin_id"],
        admin_og_name: map["admin_og_name"],
        type_name: map["type_name"],
      );
}
