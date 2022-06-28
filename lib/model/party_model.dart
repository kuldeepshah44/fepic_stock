import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/api.dart';
import 'package:rxdart/rxdart.dart';


class PartyModel with ChangeNotifier {
  List<PartyModelParam> partyModelList = [];

  final _fetchParty = BehaviorSubject<List<PartyModelParam>>();
  Observable<List<PartyModelParam>> get GetAllParty => _fetchParty.stream;
  final _hasMoreDealsFetcher = BehaviorSubject<bool>();
  final _isLoadingPartyFetcher = BehaviorSubject<bool>();

  void setProductList(List<PartyModelParam> list) {
    partyModelList = list;
  }

  void addData(Map<String, dynamic> singledata) {
    partyModelList.add(PartyModelParam.fromJson(singledata));
  }

  List<PartyModelParam> getPartyList() {
    return partyModelList;
  }


  Future<bool> fetchPartyList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData=false;
    try {
      partyModelList.clear();

      await Api()
          .getPostData(getCommon, params, false, load, contexta, _scaffoldKey,
          isfullresponce: true)
          .then((value) {

        //log("reponse==tre=${value}");
        if (value.toString() != "null") {
          var tagsJson = jsonDecode(value);
          if (!tagsJson['status']) {
            IsData = false;
          } else {
            IsData = true;

            tagsJson['data'].forEach((value1) {
              addData(value1);
            });
            partyModelList.removeWhere((element) => element.admin_og_name.toLowerCase()==params["party_name"].toString().toLowerCase());
            partyModelList.insert(
                0, PartyModelParam(admin_id: "-1", admin_og_name: "Select Party"));
            _fetchParty.add(partyModelList);
          }
        }
        notifyListeners();
      });

      return true;
    } catch (err, trace) {
      debugPrint(trace.toString());

      notifyListeners();
      return false;
    }
  }
}

class PartyModelParam {
  String admin_id;
  String admin_name;
  String admin_password;
  String admin_og_name;
  String admin_address;
  String admin_mobno;
  String admin_gstin;
  String admin_type;
  String admin_login_type;

  PartyModelParam({
    this.admin_id,
    this.admin_name,
    this.admin_password,
    this.admin_og_name,
    this.admin_address,
    this.admin_mobno,
    this.admin_gstin,
    this.admin_type,
    this.admin_login_type,
  });

  factory PartyModelParam.fromJson(Map<String, dynamic> json) => PartyModelParam(
    admin_id: json["admin_id"] == null ? null : json["admin_id"],
    admin_name: json["admin_name"] == null ? null : json["admin_name"],
    admin_password: json["admin_password"] == null ? null : json["admin_password"],
    admin_og_name: json["admin_og_name"] == null ? null : json["admin_og_name"],
    admin_address: json["admin_address"] == null ? null : json["admin_address"],
    admin_mobno: json["admin_mobno"] == null ? null : json["admin_mobno"],
    admin_gstin: json["admin_gstin"] == null ? null : json["admin_gstin"],
    admin_type: json["admin_type"] == null ? null : json["admin_type"],
    admin_login_type: json["admin_login_type"] == null ? null : json["admin_login_type"],
  );

  Map<String, dynamic> toJson() => {
    "admin_id": admin_id == null ? null : admin_id,
    "admin_name": admin_name == null ? null : admin_name,
    "admin_password": admin_password == null ? null : admin_password,
    "admin_og_name": admin_og_name == null ? null : admin_og_name,
    "admin_address": admin_address == null ? null : admin_address,
    "admin_mobno": admin_mobno == null ? null : admin_mobno,
    "admin_gstin": admin_gstin == null ? null : admin_gstin,
    "admin_type": admin_type == null ? null : admin_type,
    "admin_login_type": admin_login_type == null ? null : admin_login_type,
  };
}