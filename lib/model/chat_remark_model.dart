import 'dart:convert';

import 'package:fepic_stock/utility/api.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class ChatRemarkModel with ChangeNotifier {
  List<ChatRemarkModelParam> chatRemarkModelList=[];

  final _fetchRemarkChat = BehaviorSubject<List<ChatRemarkModelParam>>();
  Observable<List<ChatRemarkModelParam>> get getAllChatRemark => _fetchRemarkChat.stream;

  void addData(Map<String,dynamic> json)
  {
    chatRemarkModelList.add(ChatRemarkModelParam.fromJson(json));
  }
  
  void setData(List<ChatRemarkModelParam> list)
  {
    chatRemarkModelList=list;
  }

  List<ChatRemarkModelParam> getList() {
    return chatRemarkModelList;
  }

  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData=false;
    try {
      print("CONTEXT ${contexta}");

      if (params['page'].toString() == "1") {
        chatRemarkModelList.clear();
      }
      chatRemarkModelList.clear();


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
            _fetchRemarkChat.add(chatRemarkModelList);
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

class ChatRemarkModelParam {
  String remark_id;
  String remark_sent_by;
  String remark_desc;
  String remark_chalan_id;
  String remark_complete_status;
  String remark_Added_on;
  String admin_id;
  String admin_og_name;
  String sent_remark_by;

  ChatRemarkModelParam(
      {this.remark_id,
      this.remark_sent_by,
      this.remark_desc,
      this.remark_chalan_id,
      this.remark_complete_status,
      this.remark_Added_on,
      this.admin_id,
      this.admin_og_name,
      this.sent_remark_by});

  factory ChatRemarkModelParam.fromJson(Map<String, dynamic> json) =>
      ChatRemarkModelParam(
        remark_id: json["remark_id"],
        remark_sent_by: json["remark_sent_by"],
        remark_desc: json["remark_desc"],
        remark_chalan_id: json["remark_chalan_id"],
        remark_complete_status: json["remark_complete_status"],
        remark_Added_on: json["remark_Added_on"],
        admin_id: json["admin_id"],
        admin_og_name: json["admin_og_name"],
        sent_remark_by: json["sent_remark_by"],
      );
}
