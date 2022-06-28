import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/api.dart';
import 'package:rxdart/rxdart.dart';


class MessageModel with ChangeNotifier {
  List<MessageModelParam> messageModelList = [];
  List<RunChalanDetailParam> runChalanDetailList = [];
  List<PartChalanDetailParam> partChalanDetailList = [];
  List<NotificationDetail> notificationDetail = [];
  List<NotificationAcceptResponse> notificationAccept = [];

  final _fetchMessageModel = BehaviorSubject<List<MessageModelParam>>();
  Observable<List<MessageModelParam>> get getAllMessageModel => _fetchMessageModel.stream;
  final _hasMoreDealsFetcher = BehaviorSubject<bool>();
  final _isLoadingPartyFetcher = BehaviorSubject<bool>();

  void setList(List<MessageModelParam> list) {
    messageModelList = list;
  }

  void addData(Map<String, dynamic> singledata) {
    messageModelList.add(MessageModelParam.fromJson(singledata));
  }

  void addRunData(Map<String, dynamic> singledata) {
    runChalanDetailList.add(RunChalanDetailParam.fromJson(singledata));
  }
  void addNotificationData(Map<String, dynamic> singledata) {
    notificationDetail.add(NotificationDetail.fromJson(singledata));
  }
  void addNotificationResponse(Map<String, dynamic> singledata) {
    notificationAccept.add(NotificationAcceptResponse.fromJson(singledata));
  }

  void addPartData(Map<String, dynamic> singledata) {
    partChalanDetailList.add(PartChalanDetailParam.fromJson(singledata));
  }


  List<MessageModelParam> getList() {
    return messageModelList;
  }

  List<RunChalanDetailParam> getRunChalanDetailList() {
    return runChalanDetailList;
  }

  List<NotificationDetail> getNotificationDetailList() {
    return notificationDetail;
  }

  List<NotificationAcceptResponse> getNotificationAcceptRespnse() {
    return notificationAccept;
  }

  List<PartChalanDetailParam> getPartChalanDetailList() {
    return partChalanDetailList;
  }


  Future<MessageModelParam> add_post(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreData) async {
    MessageModelParam messageModelParam;

    try {
      messageModelList.clear();

      await Api()
          .getPostData(send_post_data, params, false, load, contexta, _scaffoldKey,
          isfullresponce: true)
          .then((value) {
        //log("user Type==tre=${value}");
        if (value.toString() != "null") {

          var tagsJson = jsonDecode(value);
          if(isMoreData && params['btn_type']=="Run")
            {
              runChalanDetailList.clear();
              addRunData(tagsJson['data']);
            }
         else if(isMoreData && params['btn_type']=="Part" || isMoreData && params['btn_type']=="Complete")
          {
            partChalanDetailList.clear();
            addPartData(tagsJson['data']);
          }
          if(isMoreData && params['btn_type']=="notification_detail")
           {
             notificationDetail.clear();
             addNotificationData(tagsJson['data']);
           }
          if(isMoreData && params['btn_type']=="notification_accept")
          {
            notificationAccept.clear();
            addNotificationResponse(tagsJson['data']);
          }
          messageModelList.insert(0, MessageModelParam(status: tagsJson['status'],message: tagsJson['message']));
          messageModelParam=messageModelList[0];

        }

        notifyListeners();
      });

      return messageModelParam;
    } catch (err, trace) {
      debugPrint(trace.toString());

      notifyListeners();
      return messageModelParam;
    }
  }
}

class MessageModelParam {
  bool status;
  String message;

  MessageModelParam({
    this.status,
    this.message,


  });

  factory MessageModelParam.fromJson(Map<String, dynamic> json) => MessageModelParam(
    status: json["status"] ,
    message: json["message"],
  );


}
class RunChalanDetailParam{
  String notification_id,chalanNo,lotNo,date,product,subproduct,dNo,pcs,sentby;

  RunChalanDetailParam({
      this.notification_id,
      this.chalanNo,
      this.lotNo,
      this.date,
      this.product,
      this.subproduct,
      this.dNo,
      this.pcs,
      this.sentby,
     });
  factory RunChalanDetailParam.fromJson(Map<String,dynamic> jsonData)=>RunChalanDetailParam(
    notification_id: jsonData['notification_id'],
    chalanNo: jsonData['chalan_no'],
    lotNo: jsonData['lot_no'],
    date: jsonData['chalan_Added_on'],
    product: jsonData['product_name'],
    subproduct: jsonData['sub_product_name'],
    dNo: jsonData['product_design_no'],
    pcs: jsonData['chalan_qty'],
    sentby: jsonData['user_name'],

  );

}
class PartChalanDetailParam{
  String chalan_id;
  String chalan_no;
  String delivery_chalan_no;
  String lot_no;
  String chalan_sent_by;
  String chalan_sent_to;
  String product_id;
  String sub_product_id;
  String chalan_qty;
  String chalan_process_qty;
  String chalan_complete_qty;
  String chalan_remain_qty;
  String chalan_metere;
  String chalan_rate;
  String chalan_status;
  String chalan_main_status;
  String chalan_alter_accept;
  String chalan_Added_on;
  String chalan_Ended_On;
  String chalan_financial_year;

  PartChalanDetailParam({
    this.chalan_id,
    this.chalan_no,
    this.delivery_chalan_no,
    this.lot_no,
    this.chalan_sent_by,
    this.chalan_sent_to,
    this.product_id,
    this.sub_product_id,
    this.chalan_qty,
    this.chalan_process_qty,
    this.chalan_complete_qty,
    this.chalan_remain_qty,
    this.chalan_metere,
    this.chalan_rate,
    this.chalan_status,
    this.chalan_main_status,
    this.chalan_alter_accept,
    this.chalan_Added_on,
    this.chalan_Ended_On,
    this.chalan_financial_year,
  });
  factory PartChalanDetailParam.fromJson(Map<String,dynamic> json)=>PartChalanDetailParam(
    chalan_id: json["chalan_id"],
    chalan_no: json["chalan_no"],
    delivery_chalan_no: json["delivery_chalan_no"],
    lot_no: json["lot_no"],
    chalan_sent_by: json["chalan_sent_by"],
    chalan_sent_to: json["chalan_sent_to"],
    product_id: json["product_id"],
    sub_product_id: json["sub_product_id"],
    chalan_qty: json["chalan_qty"],
    chalan_process_qty: json["chalan_process_qty"],
    chalan_complete_qty: json["chalan_complete_qty"],
    chalan_remain_qty: json["chalan_remain_qty"],
    chalan_metere: json["chalan_metere"],
    chalan_rate: json["chalan_rate"],
    chalan_status: json["chalan_status"],
    chalan_main_status: json["chalan_main_status"],
    chalan_alter_accept: json["chalan_alter_accept"],
    chalan_Added_on: json["chalan_Added_on"],
    chalan_Ended_On: json["chalan_Ended_On"],
    chalan_financial_year: json["chalan_financial_year"],

  );

}
class NotificationDetail {
  String chalanNo,lotNo,date,product,subproduct,dNo,pcs,sentby;
  NotificationDetail({
    this.chalanNo,
    this.lotNo,
    this.date,
    this.product,
    this.subproduct,
    this.dNo,
    this.pcs,
    this.sentby,
  });
  factory NotificationDetail.fromJson(Map<String,dynamic> jsonData)=>NotificationDetail(
    chalanNo: jsonData['chalanno'],
    lotNo: jsonData['lotno'],
    date: jsonData['date'],
    product: jsonData['product'],
    subproduct: jsonData['subproduct'],
    dNo: jsonData['designno'],
    pcs: jsonData['qty'],
    sentby: jsonData['sentby'],

  );
}
class NotificationAcceptResponse {
  String chalanNo,lotNo,date,product,subproduct,dNo,pcs,sentby;
  NotificationAcceptResponse({
    this.chalanNo,
    this.lotNo,
    this.date,
    this.product,
    this.subproduct,
    this.dNo,
    this.pcs,
    this.sentby,
  });
  factory NotificationAcceptResponse.fromJson(Map<String,dynamic> jsonData)=>NotificationAcceptResponse(
    chalanNo: jsonData['chalanNo'],
    lotNo: jsonData['lotNo'],
    date: jsonData['date'],
    product: jsonData['product'],
    subproduct: jsonData['subproduct'],
    dNo: jsonData['dNo'],
    pcs: jsonData['pcs'],
    sentby: jsonData['sentby'],

  );
}