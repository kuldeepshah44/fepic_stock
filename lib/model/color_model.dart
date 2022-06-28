import 'dart:convert';
import 'dart:developer';

import 'package:fepic_stock/utility/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ColorModel with ChangeNotifier
{
  List<ColorModelParam> colorModelParam = [];

  final _fetchColor = BehaviorSubject<List<ColorModelParam>>();
  Observable<List<ColorModelParam>> get getAllColor => _fetchColor.stream;

  void setList(List<ColorModelParam> list) {
    colorModelParam = list;
  }

  void addData(Map<String, dynamic> singledata) {
    colorModelParam.add(ColorModelParam.fromJson(singledata));
  }

  List<ColorModelParam> getList() {
    return colorModelParam;
  }


  Future<bool> fetchColorList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {

    bool IsData=false;
    try {
      colorModelParam.clear();
      colorModelParam.insert(0, ColorModelParam(id: "-1",
          product_id: "-1", color_name: "Select Color"));

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
          _fetchColor.add(colorModelParam);
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

class ColorModelParam {
  String id;
  String product_id;
  String color_name;
  String product_name;
  String product_HSN;
  String product_design_no;

  ColorModelParam({
    this.id,
    this.product_id,
    this.color_name,
    this.product_name,
    this.product_HSN,
    this.product_design_no,
  });

  factory ColorModelParam.fromJson(Map<String, dynamic> json) => ColorModelParam(
    id: json["id"] ,
    product_id: json["product_id"] ,
    color_name: json["color_name"],
    product_name: json["product_name"],
    product_HSN: json["product_HSN"],
    product_design_no: json["product_design_no"],

  );

  Map<String, dynamic> toJson() => {
    "product_id": product_id,
    "color_name": color_name,
    
  };
}