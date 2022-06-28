import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/api.dart';
import 'package:rxdart/rxdart.dart';


class RemarkModel with ChangeNotifier {
  List<RemarkModelParam> remarkModelList = [];

  final _fetchRemark = BehaviorSubject<List<RemarkModelParam>>();
  Observable<List<RemarkModelParam>> get getAllRemark => _fetchRemark.stream;


  void setList(List<RemarkModelParam> list) {
    remarkModelList = list;
  }

  void addData(Map<String, dynamic> singledata) {
    remarkModelList.add(RemarkModelParam.fromJson(singledata));
  }

  List<RemarkModelParam> getList() {
    return remarkModelList;
  }


  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData=false;
    try {
      print("CONTEXT ${contexta}");

      if (params['page'].toString() == "1") {
        remarkModelList.clear();
      }
      remarkModelList.clear();


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
            _fetchRemark.add(remarkModelList);
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

class RemarkModelParam {
  String remark_id;
  String remark_sent_by;
  String remark_desc;
  String remark_chalan_id;
  String remark_complete_status;
  String remark_Added_on;
  String chalan_id;
  String chalan_no;
  String lot_no;
  String admin_og_name;
  String product_design_no;
  String chalan_financial_year;
  String chalan_status;

  RemarkModelParam({
    this.remark_id,
    this.remark_sent_by,
    this.remark_desc,
    this.remark_chalan_id,
    this.remark_complete_status,
    this.remark_Added_on,
    this.chalan_id,
    this.chalan_no,
    this.lot_no,
    this.admin_og_name,
    this.product_design_no,
    this.chalan_financial_year,
    this.chalan_status,
  });

  factory RemarkModelParam.fromJson(Map<String, dynamic> json) => RemarkModelParam(
    remark_id: json["remark_id"] ,
    remark_sent_by: json["remark_sent_by"],
    remark_desc: json["remark_desc"],
    remark_chalan_id: json["remark_chalan_id"],
    remark_complete_status: json["remark_complete_status"],
    remark_Added_on: json["remark_Added_on"],
    chalan_id: json["chalan_id"],
    chalan_no: json["chalan_no"],
    lot_no: json["lot_no"],
    admin_og_name: json["admin_og_name"],
    product_design_no: json["product_design_no"],
    chalan_financial_year: json["chalan_financial_year"],
    chalan_status: json["chalan_status"],

  );

}