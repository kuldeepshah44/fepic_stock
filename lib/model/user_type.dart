import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/api.dart';
import 'package:rxdart/rxdart.dart';


class UserTypeModel with ChangeNotifier {
  List<UserTypeModelParam> userTypeModelList = [];

  final _fetchUserType = BehaviorSubject<List<UserTypeModelParam>>();
  Observable<List<UserTypeModelParam>> get getAllUserType => _fetchUserType.stream;
  final _hasMoreDealsFetcher = BehaviorSubject<bool>();
  final _isLoadingPartyFetcher = BehaviorSubject<bool>();

  void setList(List<UserTypeModelParam> list) {
    userTypeModelList = list;
  }

  void addData(Map<String, dynamic> singledata) {
    userTypeModelList.add(UserTypeModelParam.fromJson(singledata));
  }

  List<UserTypeModelParam> getList() {
    return userTypeModelList;
  }


  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {

    bool IsData=false;
    try {
      userTypeModelList.clear();

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
            _fetchUserType.add(userTypeModelList);
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

class UserTypeModelParam {
  String admin_type_id;
  String type_name;
 
  UserTypeModelParam({
    this.admin_type_id,
    this.type_name,
    

  });

  factory UserTypeModelParam.fromJson(Map<String, dynamic> json) => UserTypeModelParam(
    admin_type_id: json["admin_type_id"] ,
    type_name: json["type_name"],
  );

  Map<String, dynamic> toJson() => {
    "admin_type_id": admin_type_id,
    "type_name": type_name,
    
  };
}