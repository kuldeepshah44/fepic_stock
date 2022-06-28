import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/api.dart';
import 'package:rxdart/rxdart.dart';


class SubProductModel with ChangeNotifier {
  List<SubProductModelParam> subProductModelList = [];

  final _fetchSubProduct = BehaviorSubject<List<SubProductModelParam>>();
  Observable<List<SubProductModelParam>> get getAllSubProduct => _fetchSubProduct.stream;
  final _hasMoreDealsFetcher = BehaviorSubject<bool>();
  final _isLoadingPartyFetcher = BehaviorSubject<bool>();

  void setList(List<SubProductModelParam> list) {
    subProductModelList = list;
  }

  void addData(Map<String, dynamic> singledata) {
    subProductModelList.add(SubProductModelParam.fromJson(singledata));
  }

  List<SubProductModelParam> getList() {
    return subProductModelList;
  }


  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {

    bool IsData=false;
    try {
      subProductModelList.clear();


          subProductModelList.insert(0, SubProductModelParam(
              sub_product_id: "-1", sub_product_name: "Select Sub Product"));



      await Api()
          .getPostData(getCommon, params, false, load, contexta, _scaffoldKey,
          isfullresponce: true)
          .then((value) {
        log("reponse==tre=${value}");
        if (value.toString() != "null") {

          var tagsJson = jsonDecode(value);

          if (!tagsJson['status']) {
            IsData = false;
          } else {
            IsData = true;
            tagsJson['data'].forEach((value1) {
              addData(value1);
            });

          }
          _fetchSubProduct.add(subProductModelList);
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

class SubProductModelParam {
  String sub_product_id;
  String sub_product_name;
  String product_id;
  String sub_product_Added_on; 
  String product_name;

  SubProductModelParam({
    this.sub_product_id,
    this.sub_product_name,
    this.product_id,
    this.sub_product_Added_on,
    this.product_name,

  });

  factory SubProductModelParam.fromJson(Map<String, dynamic> json) => SubProductModelParam(
    sub_product_id: json["sub_product_id"] ,
    sub_product_name: json["sub_product_name"],
    product_id: json["product_id"],
    sub_product_Added_on: json["sub_product_Added_on"],
    product_name: json["product_name"],
  );

  Map<String, dynamic> toJson() => {
    "sub_product_id": sub_product_id,
    "sub_product_name": sub_product_name,
    "product_id": product_id,
    "sub_product_Added_on": sub_product_Added_on,   
    "product_name": product_name,
  };
}