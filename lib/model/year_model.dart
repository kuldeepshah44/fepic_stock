import 'dart:convert';

import 'package:fepic_stock/utility/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YearModel with ChangeNotifier
{
  YearModelData yearmodelDataList;
  SharedPreferences prefs;
  void addJson(Map<String,dynamic> json)
  {
     YearModelData.fromJson(json);
  }


  Future<bool> fetchYear(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData = false;

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
            yearmodelDataList = YearModelData.fromJson(tagsJson);
            setCurrentYear(yearmodelDataList);
            print("current_financial_year====${yearmodelDataList.current_financial_year}");

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

  Future<void> setCurrentYear(YearModelData yearmodelDataList)
  async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("current_year", yearmodelDataList.current_financial_year);
  }

  Future<String> getCurrentYear()
  async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("current_year");
  }

}
class YearModelData{
  bool status;
  String message,current_financial_year;

  YearModelData({this.status, this.message, this.current_financial_year});
factory YearModelData.fromJson(Map<String,dynamic> map)=>YearModelData(
  status: map["status"],
  message: map["message"],
  current_financial_year: map["current_financial_year"],
);
}