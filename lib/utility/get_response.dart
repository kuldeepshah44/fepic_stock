import 'dart:convert';

import 'package:fepic_stock/model/party_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import 'api.dart';

class GetResponse extends ChangeNotifier {


  //Party List

  final _fetchParty = BehaviorSubject<PartyModelParam>();
  Observable<PartyModelParam> get AllParty => _fetchParty.stream;
  fetchPartyList() async {
    Map map=new Map();
    map["type"]="user";
    final response = await Api().post(getCommon, map);
    print(response.body);
    //ProductModelParam abc = ProductModelParam.fromJson(json.decode(response.body));
    //_fetchParty.add(abc);
    //print("response=======${abc}");
  }


}

