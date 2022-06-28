import 'dart:async';

import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/financialYearModal.dart';
import 'package:fepic_stock/model/lot_model.dart';
import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/order_model.dart';
import 'package:fepic_stock/model/user_party_model.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class OrderMasterActivity extends StatefulWidget {
  @override
  _OrderMasterActivityState createState() => _OrderMasterActivityState();
}

class _OrderMasterActivityState extends State<OrderMasterActivity> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
  GlobalKey<LiquidPullToRefreshState>();
  TextEditingController messageController = new TextEditingController();
  OrderModel orderModel;
  MessageModel messageModel;
  //ChalanModel chalanModel;
  UserPartyModel userPartyModel;
  UserPartyModelParam selectedPartyList;
  String selectedParty = "-1";
  int page = 1;
  UserModel userModel;
  StreamController refreshAllLotList = StreamController.broadcast();
  StreamController refreshLotDetailList = StreamController.broadcast();
  var uid;
  var login_type;
  var financialYear;
  bool IsQuantityError = false;
  String message="";

  @override
  void initState() {
    super.initState();
    orderModel = Provider.of<OrderModel>(context, listen: false);
    messageModel = Provider.of<MessageModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
   // chalanModel = Provider.of<ChalanModel>(context, listen: false);
    userPartyModel = Provider.of<UserPartyModel>(context, listen: false);

    getUserSession();
    getUserParty(false);
    /*  WidgetsBinding.instance.addPostFrameCallback((_) {

    });*/
  }

  Future<void> getUserSession() async {
    uid = await userModel.getUserId();
    login_type = await userModel.getUserType();
    financialYear =await  Share().currentFinancialYear();
    print("uid====${uid}==login_type==${login_type}");
    getAllOrderList(true);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: Text("Order List",
            style: TextStyle(
                fontFamily: 'Libre',
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockHorizontal * 4.2,
                color: black,
                letterSpacing: 0.2)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [white, white],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        elevation: 1.0,
        actions: [
          IconButton(icon: Icon(Icons.refresh),
          onPressed: (){
            getAllOrderList(true);
          },
          )
        ],
      ),
      body: Container(
        color: background,
        child: StreamBuilder(
          stream: refreshAllLotList.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: LazyLoadScrollView(
                      scrollDirection: Axis.vertical,
                      // scrollOffset: 50,
                      onEndOfPage: () async {
                        page = page + 1;
                        print("CALLING API ${page}");
                        // await getAllOrderList(true);
                      },
                      child: LiquidPullToRefresh(
                        color: background,
                        backgroundColor: mTextDisplayColor,
                        key: _refreshIndicatorKey,
                        // key if you want to add
                        onRefresh: () async {
                          page = 1;
                          getAllOrderList(true);
                        },
                        showChildOpacityTransition: false,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: orderModel.getOrderList().length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(
                                          left: 5, right: 5, top: 5),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              white,white
                                            ],
                                            begin:
                                            const FractionalOffset(0.0, 0.0),
                                            end: const FractionalOffset(1.0, 0.0),
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp),
                                        //  shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(30.0))
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Text("Date : ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                              Text(
                                                  orderModel
                                                      .getOrderList()[index]
                                                      .order_Added_On,
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Text("Lot No : ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          3.5,
                                                      color: logocolor2,
                                                      letterSpacing: 0.2)),
                                              Text(
                                                  orderModel
                                                      .getOrderList()[index]
                                                      .order_lot_no,
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          3.5,
                                                      color: logocolor2,
                                                      letterSpacing: 0.2)),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Text("Party Name : ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      //fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                              Text(
                                                  orderModel
                                                      .getOrderList()[index]
                                                      .party_name,
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                            ],
                                          ),

                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      color: btncolor,
                                                      padding: EdgeInsets.all(5),
                                                      child: Center(
                                                        child: Text(
                                                          "Order Quantity",
                                                          style: TextStyle(
                                                              color:
                                                              Colors.white),
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    color: btncolor,
                                                    padding: EdgeInsets.all(5),
                                                    child: Center(
                                                      child: Text(
                                                        "Delivery Quantity",
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      color: btncolor,
                                                      padding: EdgeInsets.all(5),
                                                      child: Center(
                                                        child: Text(
                                                          "Remain Quantity",
                                                          style: TextStyle(
                                                              color:
                                                              Colors.white),
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 5, bottom: 5),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                          color: Colors.black,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        orderModel
                                                            .getOrderList()[index]
                                                            .order_qty,
                                                        style: TextStyle(
                                                            fontFamily: 'Libre',
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                                3.5,
                                                            color: black,
                                                            letterSpacing: 0.2),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 5, bottom: 5),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                          color: Colors.black,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        orderModel
                                                            .getOrderList()[index]
                                                            .order_delivery_qty,
                                                        style: TextStyle(
                                                            fontFamily: 'Libre',
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                                3.5,
                                                            color: black,
                                                            letterSpacing: 0.2),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 5, bottom: 5),
                                                    child: Center(
                                                        child: Text(
                                                          orderModel
                                                              .getOrderList()[index]
                                                              .order_remain_qty,
                                                          style: TextStyle(
                                                              fontFamily: 'Libre',
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                                  3.5,
                                                              color: black,
                                                              letterSpacing: 0.2),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [


                                              RaisedButton(
                                                color: green,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                                onPressed: () {
                                                  orderView(orderModel.getOrderList()[index]);
                                                },
                                                child: Text(
                                                  "Delivery",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Container(
                  child: Text(message,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: black),),
                ),
              );
            }
          },
        ),
      ),
    );
  }

 

  bool IsChatSend = false;
  String errorMessage = "";

  orderView(OrderModelData orderModelData) {
    messageController.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState1) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: hhhh,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text("Order",
                                  style: TextStyle(
                                      fontFamily: 'Libre',
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                      SizeConfig.safeBlockHorizontal * 4.2,
                                      color: white,
                                      letterSpacing: 0.2)),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          controller: messageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              prefixIcon: Icon(Icons.scatter_plot, size: 15),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              labelText: "Quantity",
                              hintText: 'Enter Quantity',
                              fillColor: Colors.white70),
                          onChanged: (value) {
                            setState1(() {
                              if (value.length > 0) {
                                IsChatSend = true;
                              } else {
                                IsChatSend = false;
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),


                      Column(
                        children: [
                          RaisedButton(
                            color: IsChatSend ? green : Colors.black38,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            onPressed: () {
                              if (messageController.text == "") {
                                setState1(() {
                                  IsQuantityError = true;
                                  errorMessage = "Please enter quantityr !";
                                });
                                Timer timer =
                                new Timer(new Duration(seconds: 3), () {
                                  if (mounted) {
                                    setState1(() {
                                      IsQuantityError = false;
                                    });
                                  }
                                });
                                return;
                              } else {
                                Navigator.pop(context);
                                orderProcess(
                                   orderModelData,
                                    messageController.text);
                              }
                            },
                            child: Text(
                              "Delivery",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      IsQuantityError
                          ? Container(
                        margin: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            "${errorMessage}",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }),
          );
        });
  }

  Widget partyType(StateSetter setState1) {
    return StreamBuilder(
      stream: userPartyModel.getAllUserParty,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data[0].party_id != "-1") {
            (snapshot.data as List<UserPartyModelParam>).insert(
                0,
                UserPartyModelParam(
                    party_id: "-1", party_name: "Select Party"));
          }

          return Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white70,
              border: Border.all(color: Colors.black, width: 0.4),
              borderRadius: BorderRadius.all(Radius.circular(
                  5.0) //                 <--- border radius here
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<UserPartyModelParam>(
                  value: selectedPartyList != null
                      ? selectedPartyList
                      : snapshot.data[0],
                  hint: Text("Select User"),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).dividerColor,
                  ),
                  onChanged: (UserPartyModelParam newValue) {
                    setState1(() {
                      // cou = newValue;
                      selectedPartyList = newValue;
                      selectedParty = newValue.party_id;
                      print("select party ${selectedParty}");
                    });
                  },
                  items: snapshot.data
                      .map<DropdownMenuItem<UserPartyModelParam>>((value) {
                    //print("kya aayya ${value.admin_name.toString()}");
                    return DropdownMenuItem<UserPartyModelParam>(
                      value: value,
                      child: Text(value.party_name),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future<void> getUserParty(bool status) async {
    print("user_type");
    Map<String, dynamic> param = {
      "type": "party",
    };
    bool isload = await userPartyModel.fetchList(
        context, param, scaffoldState, status, false);
  }

  Future<void> getAllOrderList(bool status) async {
    message="";
    Map<String, dynamic> param = {
      "searchField": "",
      "sessionYear": financialYear,
      "page": page.toString(),
      "api_name": "viewOrderProcess",
    };

    bool Isload =
    await orderModel.fetchList(context, param, scaffoldState, status, false);
    if (Isload) {
      refreshAllLotList.add({});
    }
    else
      {
        message="Not Found Data !";
      }
    setState(() {

    });
  }
 

  Future<void> orderProcess(var value,String quantity) async {
    Map<String, dynamic> map = new Map();
    map['order_remain_qty'] = value.order_remain_qty;
    map['orderIdForDelivery'] = value.order_id;
    map['inputDeliveryOrderQty'] =quantity;
    map['api_name'] = "deliveryOrderProcess";

    MessageModelParam data =
    await messageModel.add_post(context, map, scaffoldState, true, false);
    if (data.status) {
      messageController.text = "";
      getAllOrderList(false);
    }
    Share().show_Dialog(context, data.message, "Order Process", data.status);
  }
}
