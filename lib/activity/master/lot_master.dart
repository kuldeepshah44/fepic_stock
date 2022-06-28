import 'dart:async';
import 'dart:convert';

import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/financialYearModal.dart';
import 'package:fepic_stock/model/lot_model.dart';
import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/user_party_model.dart';
import 'package:fepic_stock/model/year_model.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class LotMasterActivity extends StatefulWidget {
  @override
  _LotMasterActivityState createState() => _LotMasterActivityState();
}

class _LotMasterActivityState extends State<LotMasterActivity> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  TextEditingController messageController = new TextEditingController();
  TextEditingController alterChalanNoController = new TextEditingController();
  LotModel lotModel;
  MessageModel messageModel;
  YearModel _yearModel;
  UserPartyModel userPartyModel;
  UserPartyModelParam selectedPartyList;
  FetchParty selectFetchParty = null;
  String selectedParty = "-1";
  String error_message = "-1";
  int page = 1;
  UserModel userModel;
  StreamController refreshAllLotList = StreamController.broadcast();
  StreamController refreshLotDetailList = StreamController.broadcast();
  var uid;
  var login_type;
  var financialYear;
  bool IsQuantityError1 = false;
  bool IsQuantityError = false;

  List<LotModelParam> searchResults;
  bool isSearched = false;

  void getSearchResult() {
    searchResults = lotModel.getLotList().where((element) {
      return element.lotno.toString().toLowerCase().contains("") ? true : false;
    }).toList();
  }

  TextEditingController searController = new TextEditingController();
  bool IsClickSearch = false;

  @override
  void initState() {
    super.initState();
    lotModel = Provider.of<LotModel>(context, listen: false);
    messageModel = Provider.of<MessageModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
    _yearModel = Provider.of<YearModel>(context, listen: false);
    userPartyModel = Provider.of<UserPartyModel>(context, listen: false);

    getUserSession();
    getUserParty(false);
    /*  WidgetsBinding.instance.addPostFrameCallback((_) {

    });*/
  }

  Future<void> getUserSession() async {
    uid = await userModel.getUserId();
    login_type = await userModel.getUserType();
    financialYear = await _yearModel.getCurrentYear();
    print("uid====${uid}==login_type==${login_type}");
    getAllLotList(true, "");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
          title: IsClickSearch
            ? Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              controller: searController,
              autofocus: searController.text == "" ? true : false,
              onSubmitted: _onChange,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: "Search",
              ),
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    IsClickSearch = false;
                    searController.text = "";
                  });
                }),
          ),
        ) :Text("Lot List",
            style: TextStyle(
                fontFamily: 'Libre',
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockHorizontal * 4.2,
                color: black,
                letterSpacing: 0.2)),
       /* title: Text("Lot List",
            style: TextStyle(
                fontFamily: 'Libre',
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockHorizontal * 4.2,
                color: black,
                letterSpacing: 0.2)),*/
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
        //backgroundColor: white,
        elevation: 1.0,
        actions: [
          /*IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.blue,
            ),
            onPressed: () {
              setState(() {
                searchView();
              });
            },
          )*/
          IsClickSearch
              ? Container()
              : IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.blue,
            ),
            onPressed: () {
              setState(() {
                IsClickSearch = true;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: refreshAllLotList.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: background,
              child: Column(
                children: [
                  Expanded(
                    child: LazyLoadScrollView(
                      scrollDirection: Axis.vertical,
                      // scrollOffset: 50,
                      onEndOfPage: () async {
                       // page = page + 1;
                        print("CALLING API ${page}");
                        // await getAllLotList(true);
                      },
                      child: LiquidPullToRefresh(
                        color: background,
                        backgroundColor: mTextDisplayColor,
                        key: _refreshIndicatorKey,
                        // key if you want to add
                        onRefresh: () async {
                          page = 1;
                          getAllLotList(true, "");
                        },
                        showChildOpacityTransition: false,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: lotModel.getLotList().length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5, top: 5),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [white, white],
                                                begin: const FractionalOffset(
                                                    0.0, 0.0),
                                                end: const FractionalOffset(
                                                    1.0, 0.0),
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              3.5,
                                                          color: black,
                                                          letterSpacing: 0.2)),
                                                  Text(
                                                      lotModel
                                                          .getLotList()[index]
                                                          .date,
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              3.5,
                                                          color: logocolor2,
                                                          letterSpacing: 0.2)),
                                                  Text(
                                                      lotModel
                                                          .getLotList()[index]
                                                          .lotno,
                                                      style: TextStyle(
                                                          fontFamily: 'Libre',
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                  Text("Total Chalan : ",
                                                      style: TextStyle(
                                                          fontFamily: 'Libre',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              3.5,
                                                          color: black,
                                                          letterSpacing: 0.2)),
                                                  Text(
                                                      lotModel
                                                          .getLotList()[index]
                                                          .chalantotal,
                                                      style: TextStyle(
                                                          fontFamily: 'Libre',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              3.5,
                                                          color: black,
                                                          letterSpacing: 0.2)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Design No : ",
                                                      style: TextStyle(
                                                          fontFamily: 'Libre',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              3.5,
                                                          color: black,
                                                          letterSpacing: 0.2)),
                                                  Text(
                                                      lotModel
                                                          .getLotList()[index]
                                                          .designo,
                                                      style: TextStyle(
                                                          fontFamily: 'Libre',
                                                          //fontWeight: FontWeight.bold,
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              3.5,
                                                          color: black,
                                                          letterSpacing: 0.2)),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
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
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Center(
                                                            child: Text(
                                                              "Process Quantity",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Center(
                                                          child: Text(
                                                            "Order Quantity",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
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
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Center(
                                                            child: Text(
                                                              "Remain Quantity",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            right: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            lotModel
                                                                .getLotList()[
                                                                    index]
                                                                .processqty,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Libre',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: SizeConfig
                                                                        .safeBlockHorizontal *
                                                                    3.5,
                                                                color: black,
                                                                letterSpacing:
                                                                    0.2),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            right: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            lotModel
                                                                .getLotList()[
                                                                    index]
                                                                .oredrqty,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Libre',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: SizeConfig
                                                                        .safeBlockHorizontal *
                                                                    3.5,
                                                                color: black,
                                                                letterSpacing:
                                                                    0.2),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5),
                                                        child: Center(
                                                            child: Text(
                                                          lotModel
                                                              .getLotList()[
                                                                  index]
                                                              .reaminqty,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Libre',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  3.5,
                                                              color: black,
                                                              letterSpacing:
                                                                  0.2),
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),


                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                height: 50,
                                                child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    shrinkWrap: true,
                                                    itemCount: lotModel
                                                        .getLotList()[index]
                                                        .btns
                                                        .keys
                                                        .toList()
                                                        .length,
                                                    itemBuilder:
                                                        (context, indx) {
                                                      return Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        child: RaisedButton(
                                                          color: lotModel.getLotList()[index].btns[lotModel.getLotList()[index].btns.keys.toList()[indx]][
                                                                          "btn"] ==
                                                                      "Accept" ||
                                                                  lotModel.getLotList()[index].btns[lotModel.getLotList()[index].btns.keys.toList()[indx]]
                                                                          [
                                                                          "btn"] ==
                                                                      "Complete"
                                                              ? green
                                                              : lotModel.getLotList()[index].btns[lotModel.getLotList()[index].btns.keys.toList()[indx]]
                                                                          [
                                                                          "btn"] ==
                                                                      "Order"
                                                                  ? Colors.cyan
                                                                  : lotModel.getLotList()[index].btns[lotModel.getLotList()[index].btns.keys.toList()[indx]]["btn"] ==
                                                                          "Alter"
                                                                      ? Colors
                                                                          .deepOrangeAccent
                                                                      : hhhh,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                          onPressed: () {
                                                            /*print(
                                                                "PARAMS ${jsonEncode(
                                                                    lotModel
                                                                        .getLotList()[index]
                                                                        .btns[lotModel
                                                                        .getLotList()[index]
                                                                        .btns
                                                                        .keys
                                                                        .toList()[indx]]["parameter_to_pass"])}");*/
                                                            String lot_no = lotModel
                                                                .getLotList()[
                                                                    index]
                                                                .btns[lotModel
                                                                    .getLotList()[
                                                                        index]
                                                                    .btns
                                                                    .keys
                                                                    .toList()[
                                                                indx]]["parameter_to_pass"]["lot_no"];
                                                            String chalan_financial_year = lotModel
                                                                    .getLotList()[
                                                                        index]
                                                                    .btns[lotModel
                                                                        .getLotList()[
                                                                            index]
                                                                        .btns
                                                                        .keys
                                                                        .toList()[
                                                                    indx]]["parameter_to_pass"]
                                                                [
                                                                "chalan_financial_year"];
                                                            String
                                                                lot_reamin_qty =
                                                                "";
                                                            String
                                                                stock_lot_qty =
                                                                "";
                                                            //acceptLotForAlterProcess
                                                            if (lotModel
                                                                    .getLotList()[
                                                                        index]
                                                                    .btns[lotModel
                                                                        .getLotList()[
                                                                            index]
                                                                        .btns
                                                                        .keys
                                                                        .toList()[
                                                                    indx]]["btn"] ==
                                                                "Order") {
                                                              lot_reamin_qty = lotModel
                                                                  .getLotList()[
                                                                      index]
                                                                  .btns[lotModel
                                                                      .getLotList()[
                                                                          index]
                                                                      .btns
                                                                      .keys
                                                                      .toList()[
                                                                  indx]]["parameter_to_pass"]["lot_reamin_qty"];
                                                              orderView(lot_no,
                                                                  lot_reamin_qty);
                                                            } else if (lotModel
                                                                    .getLotList()[
                                                                        index]
                                                                    .btns[lotModel
                                                                        .getLotList()[
                                                                            index]
                                                                        .btns
                                                                        .keys
                                                                        .toList()[
                                                                    indx]]["btn"] ==
                                                                "Accept") {
                                                              acceptLotForAlterProcess(
                                                                  lot_no
                                                                      .toString(),
                                                                  chalan_financial_year);
                                                            } else if (lotModel
                                                                    .getLotList()[
                                                                        index]
                                                                    .btns[lotModel
                                                                        .getLotList()[
                                                                            index]
                                                                        .btns
                                                                        .keys
                                                                        .toList()[
                                                                    indx]]["btn"] ==
                                                                "Detail") {
                                                              getChalanDetail(
                                                                  lot_no
                                                                      .toString(),
                                                                  chalan_financial_year,
                                                                  true);
                                                            } else if (lotModel
                                                                    .getLotList()[
                                                                        index]
                                                                    .btns[lotModel
                                                                        .getLotList()[
                                                                            index]
                                                                        .btns
                                                                        .keys
                                                                        .toList()[
                                                                    indx]]["btn"] ==
                                                                "Alter") {
                                                              getAlterLotProcess(
                                                                  lot_no
                                                                      .toString(),
                                                                  chalan_financial_year,
                                                                  true);
                                                            } else if (lotModel
                                                                    .getLotList()[
                                                                        index]
                                                                    .btns[lotModel
                                                                        .getLotList()[
                                                                            index]
                                                                        .btns
                                                                        .keys
                                                                        .toList()[
                                                                    indx]]["btn"] ==
                                                                "Complete") {
                                                              stock_lot_qty = lotModel
                                                                  .getLotList()[
                                                                      index]
                                                                  .btns[lotModel
                                                                          .getLotList()[
                                                                              index]
                                                                          .btns
                                                                          .keys
                                                                          .toList()[indx]]
                                                                      [
                                                                      "parameter_to_pass"]
                                                                      [
                                                                      "stock_lot_qty"]
                                                                  .toString();

                                                              completeBtn(
                                                                  lot_no,
                                                                  stock_lot_qty,
                                                                  chalan_financial_year);
                                                            }
                                                            print(
                                                                "lot No=${lot_no},financialYear=${chalan_financial_year},lot_reamin_qty=${lot_reamin_qty},stock_lot_qty=${stock_lot_qty}");
                                                          },
                                                          child: Text(
                                                            lotModel
                                                                .getLotList()[
                                                                    index]
                                                                .btns[lotModel
                                                                    .getLotList()[
                                                                        index]
                                                                    .btns
                                                                    .keys
                                                                    .toList()[
                                                                indx]]["btn"],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  viewChalanDetail() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState2) {
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
                        child: Text("Lot Detail List",
                            style: TextStyle(
                                fontFamily: 'Libre',
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockHorizontal * 4.2,
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
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: StreamBuilder(
                      stream: refreshLotDetailList.stream,
                      builder: (context, snapshot) {
                        return ListView.builder(
                            // reverse: true,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: lotModel.getLotDetailList().length,
                            itemBuilder: (context, int index) {
                              return Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                ),
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
                                            background.withOpacity(0.3),
                                            background.withOpacity(0.3)
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
                                      mainAxisSize: MainAxisSize.min,
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
                                                lotModel
                                                    .getLotDetailList()[index]
                                                    .chalan_log_Added_on,
                                                style: TextStyle(
                                                    fontFamily: 'Libre',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        3.0,
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
                                                    color: black,
                                                    letterSpacing: 0.2)),
                                            Text(
                                                lotModel
                                                    .getLotDetailList()[index]
                                                    .lot_no,
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text("Chalan No : ",
                                                style: TextStyle(
                                                    fontFamily: 'Libre',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        3.5,
                                                    color: logocolor2,
                                                    letterSpacing: 0.2)),
                                            Text(
                                                lotModel
                                                    .getLotDetailList()[index]
                                                    .chalan_no,
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
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("Sending Quantity  :  ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                              Text(
                                                  lotModel
                                                      .getLotDetailList()[index]
                                                      .chalan_qty,
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          4,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                            ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("Process Quantity    :  ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                              Text(
                                                  lotModel
                                                      .getLotDetailList()[index]
                                                      .chalan_log_qty,
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          4,
                                                      color: black,
                                                      letterSpacing: 0.2))
                                            ]),
                                        Container(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text("Detail : ",
                                                    style: TextStyle(
                                                        fontFamily: 'Libre',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                            3.5,
                                                        color: black,
                                                        letterSpacing: 0.2)),
                                                Expanded(
                                                  child: Text(
                                                      lotModel
                                                          .getLotDetailList()[
                                                              index]
                                                          .chalan_log_desc,
                                                      style: TextStyle(
                                                          fontFamily: 'Libre',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              3.2,
                                                          color: logocolor,
                                                          letterSpacing: 0.2)),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }

  bool IsChatSend = false;
  String errorMessage = "";

  searchView() {
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
                          child: Text("Alter Process",
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

                  TextField(
                      controller: searController,
                      autofocus: searController.text == "" ? true : false,
                      onSubmitted: _onChange,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: "Search",
                      )),

                  Column(
                    children: [
                      RaisedButton(
                        color: hhhh,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () {
                          Navigator.pop(context);
                          _onChange(searController.text);
                        },
                        child: Text(
                          "Search",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          );
        });
  }

  orderView(String lotno, String reaminqty) {
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
                  partyType(setState1),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      RaisedButton(
                        color: IsChatSend ? hhhh : Colors.black38,
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
                          } else if (selectedParty == "-1") {
                            setState1(() {
                              IsQuantityError = true;
                              errorMessage = "Please select party !";
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
                            orderProcess(reaminqty, lotno, selectedParty,
                                messageController.text);
                          }
                        },
                        child: Text(
                          "Order",
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
                ],
              );
            }),
          );
        });
  }

  alterView(String lot_no, String financialYear) {
    alterChalanNoController.text =
        lotModel.alterLotDetailList[0].new_alter_chalan_no;
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
                          child: Text("Alter Process",
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
                      controller: alterChalanNoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          prefixIcon: Icon(Icons.scatter_plot, size: 15),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          labelText: "Alter Chalan No",
                          hintText: 'Enter Alter Chalan No',
                          fillColor: Colors.white70),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  partyType1(setState1),
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
                        color: IsChatSend ? hhhh : Colors.black38,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () {
                          if (alterChalanNoController.text == "") {
                            setState1(() {
                              IsQuantityError = true;
                              errorMessage = "Please enter alter chalan no !";
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
                          } else if (selectedParty == "-1") {
                            setState1(() {
                              IsQuantityError = true;
                              errorMessage = "Please select party !";
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
                          } else if (messageController.text == "") {
                            setState1(() {
                              IsQuantityError = true;
                              errorMessage = "Please enter quantity !";
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

                            alterProcess(alterChalanNoController.text, lot_no,
                                selectedParty, messageController.text);
                          }
                        },
                        child: Text(
                          "Alter Process",
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
                ],
              );
            }),
          );
        });
  }

  completeBtn(String lotno, String stock_lot_qty, String financialYear) {
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
                          child: Text("Create Stock",
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
                          if (int.parse(value) > int.parse(stock_lot_qty)) {
                            IsQuantityError1 = true;
                            error_message =
                                "Please enter a value less than or equal to ${stock_lot_qty}";
                          } else {
                            IsQuantityError1 = false;
                          }
                        });
                      },
                    ),
                  ),
                  IsQuantityError1
                      ? Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Center(
                            child: Text(
                              "${error_message}",
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
                  Column(
                    children: [
                      RaisedButton(
                        color: IsChatSend ? hhhh : Colors.black38,
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
                            completeProcess(stock_lot_qty, lotno, financialYear,
                                messageController.text);
                          }
                        },
                        child: Text(
                          "Create Stock",
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
                ],
              );
            }),
          );
        });
  }

  Widget partyType1(StateSetter setState1) {
    lotModel.getAlterLotDetailList()[0].partyList.forEach((e) {
      print("name=====${e.admin_og_name}");
    });

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border.all(color: Colors.black, width: 0.4),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<FetchParty>(
            value: selectFetchParty != null
                ? selectFetchParty
                : lotModel.getAlterLotDetailList()[0].partyList[0],
            hint: Text("Select User"),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Theme.of(context).dividerColor,
            ),
            onChanged: (FetchParty newValue) {
              setState1(() {
                // cou = newValue;
                selectFetchParty = newValue;
                selectedParty = newValue.admin_id;
                print("select party ${selectedParty}");
              });
            },
            items: lotModel
                .getAlterLotDetailList()[0]
                .partyList
                .map<DropdownMenuItem<FetchParty>>((value) {
              //print("kya aayya ${value.admin_name.toString()}");
              return DropdownMenuItem<FetchParty>(
                value: value,
                child: Text(value.admin_og_name + " (" + value.type_name + ")"),
              );
            }).toList(),
          ),
        ),
      ),
    );
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

  Future<void> getAllLotList(bool status, String search) async {
    Map<String, dynamic> param = {
      "searchField": search.toString(),
      "session_admin_id": uid,
      "session_admin_login_type": login_type.toString(),
      "sessionYear": financialYear,
      "page": page.toString(),
      "api_name": "viewLotProcess",
    };
    // print(param);

    bool Isload =
        await lotModel.fetchList(context, param, scaffoldState, status, false);
    if (Isload) {
      refreshAllLotList.add({});
    }
  }

  void _onChange(String value) {
    if (value.isNotEmpty) {
      if (value.length > 0) {
        getAllLotList(true, value.toString());
      }
    }
  }

  Future<void> getChalanDetail(
      String lot_no, String financialYear, bool status) async {
    Map<String, dynamic> map = new Map();
    map['searchField'] = '';
    map['lot_no'] = lot_no;
    map['chalan_financial_year'] = financialYear;
    map['api_name'] = "viewLotDetailsProcess";

    bool data = await lotModel.fetchLotDetail(
        context, map, scaffoldState, status, false);
    if (data) {
      viewChalanDetail();
    }
  }

  Future<void> getAlterLotProcess(
      String lot_no, String financialYear, bool status) async {
    Map<String, dynamic> map = new Map();
    // map['searchField'] = '';
    map['lot_no'] = lot_no;
    map['chalan_financial_year'] = financialYear;
    map['session_admin_id'] = uid;
    map['api_name'] = "fetchAlterLotProcess";

    bool data = await lotModel.fetchAlterLotProcess(
        context, map, scaffoldState, status, false);
    if (data) {
      selectedParty = "-1";
      if (lotModel.getAlterLotDetailList()[0].partyList[0].admin_id != "-1") {
        lotModel.getAlterLotDetailList()[0].partyList.insert(
            0,
            FetchParty(
                admin_id: "-1",
                admin_og_name: "Select Party",
                type_name: "Type"));
      }
      alterView(lot_no, financialYear);
    }
  }

  Future<void> orderProcess(String lot_reamin_qty, String lot_no,
      String partyToOrder, String input_lot_qty) async {
    Map<String, dynamic> map = new Map();
    map['lot_reamin_qty'] = lot_reamin_qty;
    map['lot_no'] = lot_no;
    map['partyToOrder'] = partyToOrder;
    map['input_lot_qty'] = input_lot_qty;
    map['chalan_financial_year'] = financialYear;
    map['api_name'] = "createOrderProcess";

    MessageModelParam data =
        await messageModel.add_post(context, map, scaffoldState, true, false);
    if (data.status) {
      messageController.text = "";
      getAllLotList(false, "");
    }
    Share().show_Dialog(context, data.message, "Order Process", data.status);
  }

  Future<void> alterProcess(String inputAlterChalanNo, String lot_no,
      String partyToOrder, String input_lot_qty) async {
    Map<String, dynamic> map = new Map();
    map['inputAlterChalanNo'] = inputAlterChalanNo;
    map['lot_no'] = lot_no;
    map['selectUserForAlter'] = partyToOrder;
    map['inputAlterLotQty'] = input_lot_qty;
    map['chalan_financial_year'] = financialYear;
    map['api_name'] = "alterProcess";

    MessageModelParam data =
        await messageModel.add_post(context, map, scaffoldState, true, false);
    if (data.status) {
      messageController.text = "";
      alterChalanNoController.text = "";
      lotModel.getAlterLotDetailList()[0].partyList.clear();
      getAllLotList(false, "");
    }
    Share().show_Dialog(context, data.message, "Alter Process", data.status);
  }

  Future<void> completeProcess(String lot_stock_qty, String lot_no,
      String financialyear, String input_lot_qty) async {
    Map<String, dynamic> map = new Map();
    map['stock_lot_qty'] = lot_stock_qty;
    map['lot_no'] = lot_no;
    map['inputCompleteLotQty'] = input_lot_qty;
    map['chalan_financial_year'] = financialyear;
    map['api_name'] = "createOrderProcess";

    MessageModelParam data =
        await messageModel.add_post(context, map, scaffoldState, true, false);
    if (data.status) {
      messageController.text = "";
      getAllLotList(false, "");
    }
    Share()
        .show_Dialog(context, data.message, "Completed Process", data.status);
  }

  Future<void> acceptLotForAlterProcess(
      String lot_no, String financialyear) async {
    Map<String, dynamic> map = new Map();
    map['searchField'] = "";
    map['lot_no'] = lot_no;
    map['chalan_financial_year'] = financialyear;
    map['api_name'] = "acceptLotForAlterProcess";

    MessageModelParam data =
        await messageModel.add_post(context, map, scaffoldState, true, false);
    if (data.status) {
      messageController.text = "";
      getAllLotList(false, "");
    }
    Share().show_Dialog(context, data.message, "Accept Process", data.status);
  }
//acceptLotForAlterProcess
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
