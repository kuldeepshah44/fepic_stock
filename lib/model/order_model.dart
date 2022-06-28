import 'dart:convert';
import 'dart:developer';

import 'package:fepic_stock/utility/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class OrderModel with ChangeNotifier {
  List<OrderModelData> orderModelList = [];

  final _fetchOrderList = BehaviorSubject<List<OrderModelData>>();
  Observable<List<OrderModelData>> get getAllOrderList => _fetchOrderList.stream;

  void addData(Map<String, dynamic> singledata) {
    orderModelList.add(OrderModelData.fromJson(singledata));
  }

  List<OrderModelData> getOrderList()
  {
    return orderModelList;
  }

  Future<bool> fetchList(BuildContext contexta, Map params,
      GlobalKey<ScaffoldState> _scaffoldKey, bool load, isMoreProduct) async {
    bool IsData = false;
    try {
      String valueType = params['value'].toString();
      if( params['page']=="1") {
        orderModelList.clear();
      }
      orderModelList.clear();
      await Api()
          .getPostData(send_post_data, params, false, load, contexta, _scaffoldKey,
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
            _fetchOrderList.sink.add(orderModelList);
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

class OrderModelData {
  String order_id,
      order_lot_no,
      order_party_id,
      order_qty,
      order_delivery_qty,
      order_remain_qty,
      order_Added_On,
      order_financial_year,
      party_id,
      party_name,
      party_Added_on;

  OrderModelData(
      {this.order_id,
      this.order_lot_no,
      this.order_party_id,
      this.order_qty,
      this.order_delivery_qty,
      this.order_remain_qty,
      this.order_Added_On,
      this.order_financial_year,
      this.party_id,
      this.party_name,
      this.party_Added_on});

  factory OrderModelData.fromJson(Map<String, dynamic> map) => OrderModelData(
        order_id: map['order_id'],
        order_lot_no: map['order_lot_no'],
        order_party_id: map['order_party_id'],
        order_qty: map['order_qty'],
        order_delivery_qty: map['order_delivery_qty'],
        order_remain_qty: map['order_remain_qty'],
        order_Added_On: map['order_Added_On'],
        order_financial_year: map['order_financial_year'],
        party_id: map['party_id'],
        party_name: map['party_name'],
        party_Added_on: map['party_Added_on'],
      );
}
