import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/api.dart';
import 'package:rxdart/rxdart.dart';


class ProductModel with ChangeNotifier {
  List<ProductModelParam> productModelList = [];

  final _fetchProduct = BehaviorSubject<List<ProductModelParam>>();
  Observable<List<ProductModelParam>> get getAllProduct => _fetchProduct.stream;
  final _hasMoreDealsFetcher = BehaviorSubject<bool>();
  final _isLoadingPartyFetcher = BehaviorSubject<bool>();

  void setList(List<ProductModelParam> list) {
    productModelList = list;
  }

  void addData(Map<String, dynamic> singledata) {
    productModelList.add(ProductModelParam.fromJson(singledata));
  }

  List<ProductModelParam> getList() {
    return productModelList;
  }


  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
bool IsData=false;
    try {
      print("CONTEXT ${contexta}");
      productModelList.clear();
      if(params['type_list'] !="list") {
        productModelList.insert(
            0,
            ProductModelParam(
                product_id: "-1", product_name: "Select Product",product_HSN: "",product_design_no: "1"));

        _fetchProduct.add(productModelList);
      }
      await Api()
          .getPostData(getCommon, params, false, load, contexta, _scaffoldKey,
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
            _fetchProduct.add(productModelList);
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

class ProductModelParam {
  String product_id;
  String product_name;
  String product_HSN;
  String product_design_no;
  String product_Added_on; 

  ProductModelParam({
    this.product_id,
    this.product_name,
    this.product_HSN,
    this.product_design_no,
    this.product_Added_on,   
  });

  factory ProductModelParam.fromJson(Map<String, dynamic> json) => ProductModelParam(
    product_id: json["product_id"] ,
    product_name: json["product_name"],
    product_HSN: json["product_HSN"],
    product_design_no: json["product_design_no"],
    product_Added_on: json["product_Added_on"],
   
  );

  Map<String, dynamic> toJson() => {
    "product_id": product_id,
    "product_name": product_name,
    "product_HSN": product_HSN,
    "product_design_no": product_design_no,
    "product_Added_on": product_Added_on,
  };
}