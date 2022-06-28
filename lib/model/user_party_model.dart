import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/api.dart';
import 'package:rxdart/rxdart.dart';


class UserPartyModel with ChangeNotifier {
  List<UserPartyModelParam> userPartyModelList = [];

  final _fetchUserPartyModel = BehaviorSubject<List<UserPartyModelParam>>();
  Observable<List<UserPartyModelParam>> get getAllUserParty => _fetchUserPartyModel.stream;
  final _hasMoreDealsFetcher = BehaviorSubject<bool>();
  final _isLoadingPartyFetcher = BehaviorSubject<bool>();

  void setList(List<UserPartyModelParam> list) {
    userPartyModelList = list;
  }

  void addData(Map<String, dynamic> singledata) {
    userPartyModelList.add(UserPartyModelParam.fromJson(singledata));
  }

  List<UserPartyModelParam> getList() {
    return userPartyModelList;
  }


  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
//    UserPartyModelParam userPartyModelParam;
    bool IsData=false;
    try {
      userPartyModelList.clear();

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
            IsData = true;            tagsJson['data'].forEach((value1) {
              addData(value1);
            });
            _fetchUserPartyModel.add(userPartyModelList);

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

class UserPartyModelParam {
  String party_id;
  String party_name;

  UserPartyModelParam({
    this.party_id,
    this.party_name,
  });

  factory UserPartyModelParam.fromJson(Map<String, dynamic> json) => UserPartyModelParam(
    party_id: json["party_id"] ,
    party_name: json["party_name"],
  );


}