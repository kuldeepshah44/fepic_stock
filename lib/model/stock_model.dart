import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/api.dart';
import 'package:rxdart/rxdart.dart';

class StockModel with ChangeNotifier {
  List<StockModelParam> stockModelList = [];

  final _fetchStockModelData = BehaviorSubject<List<StockModelParam>>();

  Observable<List<StockModelParam>> get getAllStockData =>
      _fetchStockModelData.stream;
  final _hasMoreDealsFetcher = BehaviorSubject<bool>();
  final _isLoadingPartyFetcher = BehaviorSubject<bool>();

  void setList(List<StockModelParam> list) {
    stockModelList = list;
  }

  void addData(Map<String, dynamic> singledata) {
    stockModelList.add(StockModelParam.fromJson(singledata));
  }

  List<StockModelParam> getList() {
    return stockModelList;
  }

  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
//    StockModelParam userPartyModelParam;
    bool IsData = false;
    try {
      stockModelList.clear();

      await Api()
          .getPostData(getCommon, params, false, load, contexta, _scaffoldKey,
              isfullresponce: true)
          .then((value) {
        //log("user Type==tre=${value}");
        if (value.toString() != "null") {
          var tagsJson = jsonDecode(value);
          if (!tagsJson['status']) {
            IsData = false;
          } else {
            IsData = true;
            tagsJson['data'].forEach((value1) {
              addData(value1);
            });
            _fetchStockModelData.add(stockModelList);
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

class StockModelParam {
  String stock_id;
  String stock_lot_no;
  String stock_lot_qty;
  String stock_Added_On;
  String stock_financial_year;

  StockModelParam({
    this.stock_id,
    this.stock_lot_no,
    this.stock_lot_qty,
    this.stock_Added_On,
    this.stock_financial_year,
  });

  factory StockModelParam.fromJson(Map<String, dynamic> json) =>
      StockModelParam(
        stock_id: json["stock_id"],
        stock_lot_no: json["stock_lot_no"],
        stock_lot_qty: json["stock_lot_qty"],
        stock_Added_On: json["stock_Added_On"],
        stock_financial_year: json["stock_financial_year"],
      );
}
