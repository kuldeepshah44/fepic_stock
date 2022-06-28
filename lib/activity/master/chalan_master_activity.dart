import 'dart:async';
import 'dart:io';
import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/chalan_detail_model.dart';
import 'package:fepic_stock/model/chalan_model.dart';
import 'package:fepic_stock/model/chat_remark_model.dart';
import 'package:fepic_stock/model/financialYearModal.dart';
import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/party_model.dart';
import 'package:fepic_stock/model/year_model.dart';
import 'package:fepic_stock/utility/chat_theme.dart';

import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import '../add_party.dart';

class ChalanMasterNewActivity extends StatefulWidget {
  @override
  _ChalanMasterNewActivityState createState() => _ChalanMasterNewActivityState();
}

class _ChalanMasterNewActivityState extends State<ChalanMasterNewActivity> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
  GlobalKey<LiquidPullToRefreshState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController userEditTypeController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();
  TextEditingController useraddTypeController = new TextEditingController();

  TextEditingController quantityController = new TextEditingController();
  TextEditingController comQuantityController = new TextEditingController();
  TextEditingController deleveryChalanNoController =
  new TextEditingController();
  TextEditingController rateController = new TextEditingController();

  YearModel _yearModel;
  ChalanListModel chalanModel;

  ChalanDetailModel chalanDetailModel;
  ChatRemarkModel chatRemarkModel;
  MessageModel messageModel;
  PartyModel partyModel;
  PartyModelParam selectedPartyList;
  String selectedParty = "-1";
  int page = 1;
  List<bool> isSelected = [];
  List<bool> IsSeenMessage = [];
  List<bool> IsComplete = [];
  bool IsEditTextError = false;
  String error_message = "";
  bool IsEditTextError1 = false;
  bool IsQuantityError = false;
  bool isLoading = false;
  UserModel userModel;
  var uid;
  var login_type;
  var financialYear;
  String username="";
  StreamController refreshChatList = StreamController.broadcast();
  StreamController refreshChatListForChalanDetail =
  StreamController.broadcast();
  StreamController refreshChatListForAll = StreamController.broadcast();
  ScrollController chatListScrollController = ScrollController();
  bool IsChatSend = false;
  ChalanModelData chalanModelParamSingleDetail;

  String chat_chalan_id="";
  String chat_receiver="";



  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool _fromTop = true;
  bool called = false;
  static const platform = MethodChannel('com.siliconleaf.fepic_stock');
  StreamSubscription iosSubscription;

  TextEditingController searController = new TextEditingController();
  bool IsClickSearch = false;

  @override
  void initState() {
    super.initState();
    _yearModel = Provider.of<YearModel>(context, listen: false);
    chalanModel = Provider.of<ChalanListModel>(context, listen: false);
    chalanDetailModel = Provider.of<ChalanDetailModel>(context, listen: false);
    chatRemarkModel = Provider.of<ChatRemarkModel>(context, listen: false);
    messageModel = Provider.of<MessageModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
    partyModel = Provider.of<PartyModel>(context, listen: false);
    getNotificationChat();
    getUserSession();
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
  }

  Future<void> getUserSession() async {
    uid = await userModel.getUserId();
    login_type = await userModel.getUserType();
    username = await userModel.getPartyName();
    financialYear = await _yearModel.getCurrentYear();
    print("uid====${uid}");
    getAllChalanList(true,datastatus,"");
  }

  ScrollController _scrollController = new ScrollController();
  String datastatus="";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: IsClickSearch
            ? Container(
          height: 70,
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
        ) :Text("Chalan List",
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
          IsClickSearch
              ? Container() :  IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              //  addDialog();
              getAllChalanList(true,datastatus,"");
            },
          ),
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
          IsClickSearch
              ? Container(): PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'All','New','Pending','Running','Completed Part','Completed',"Rejected"}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: refreshChatListForAll.stream,
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
                        if (!isLoading) {
                          isLoading = true;
                          page = page + 1;
                          print("CALLING API ${page}");
                          //await getAllChalanList(true);
                          isLoading = false;
                        }
                      },
                      child: LiquidPullToRefresh(
                        color: background,
                        backgroundColor: mTextDisplayColor,
                        key: _refreshIndicatorKey,
                        // key if you want to add
                        onRefresh: () async {
                          page = 1;
                          getAllChalanList(true,datastatus,"");
                        },
                        showChildOpacityTransition: false,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: chalanModel.getChalanList().length,
                            itemBuilder: (context, index) {
                              IsSeenMessage.add(false);
                              var now = new DateTime.now();
                              var formatter =
                              new DateFormat('yyyy-MM-dd hh:mm:ss');
                              String formattedDate = formatter.format(now);
                              //  print(formattedDate); // 2016-01-25

                              final tempDate1 =
                              new DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                                  chalanModel
                                      .getChalanList()[index]
                                      .chalan_Added_on);
                              final current_date =
                              new DateFormat("yyyy-MM-dd hh:mm:ss")
                                  .parse(formattedDate);
                              //  print("timer====${tempDate1}");

                              final difference =
                                  current_date.difference(tempDate1).inDays;
                              var fetch_day =
                                  int.parse(difference.toString()) + 1;
                              String status=chalanModel
                                  .getChalanList()[index]
                                  .chalan_status;
                              if (status ==
                                  "DoneComplete") {
                                status =
                                "Done";
                              }
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
                                            colors: [white,white],
                                            begin: const FractionalOffset(0.0, 0.0),
                                            end: const FractionalOffset(1.0, 0.0),
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp),
                                        //  shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(30.0))
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("Date : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                              Text(chalanModel.getChalanList()[index].chalan_Added_on,style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("Chalan No : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: logocolor2,
                                                  letterSpacing: 0.2)),
                                              Text(chalanModel.getChalanList()[index].chalan_no,style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: logocolor2,
                                                  letterSpacing: 0.2)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("Lot No : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                              Text(chalanModel.getChalanList()[index].lot_no,style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            children: [
                                              Text("Generated By : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                              Text(chalanModel.getChalanList()[index].sent_chalan_by,style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Party Name : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                              Text(chalanModel.getChalanList()[index].sent_chalan_to,style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Product Name : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                              Text(chalanModel.getChalanList()[index].product_name,style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Sub Product Name : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                              Flexible(
                                                child: Text(chalanModel.getChalanList()[index].sub_product_name,style: TextStyle(
                                                    fontFamily: 'Libre',
                                                    //fontWeight: FontWeight.bold,
                                                    fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                    color: black,
                                                    letterSpacing: 0.2)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Color : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                              Flexible(
                                                child: Text(chalanModel.getChalanList()[index].sub_product_name,style: TextStyle(
                                                    fontFamily: 'Libre',
                                                    //fontWeight: FontWeight.bold,
                                                    fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                    color: black,
                                                    letterSpacing: 0.2)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Container(

                                            padding: EdgeInsets.only(top: 5, bottom: 0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                      color: btncolor,
                                                      padding: EdgeInsets.all(5),
                                                      child: Center(
                                                        child: Text(
                                                          "Quantity",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(width: 2,),
                                                login_type=="1" ? Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    color: btncolor,
                                                    padding: EdgeInsets.all(5),
                                                    child: Center(
                                                      child: Text(
                                                        "Remain Quantity",
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ):Container(),
                                                login_type=="1" ?  SizedBox(width: 2,):Container(),
                                                Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                      color: btncolor,
                                                      padding: EdgeInsets.all(5),
                                                      child: Center(
                                                        child: Text(
                                                          "Part Complete Quantity",
                                                          style: TextStyle(color: Colors.white),
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
                                                  flex: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.only(top: 5,bottom: 5),
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
                                                        chalanModel.getChalanList()[index].chalan_qty,
                                                        style: TextStyle(
                                                            fontFamily: 'Libre',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                                3.5,
                                                            color: black,
                                                            letterSpacing: 0.2),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                login_type=="1" ? Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    padding: EdgeInsets.only(top: 5,bottom: 5),
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
                                                        chalanModel
                                                            .getChalanList()[index]
                                                            .chalan_remain_qty,
                                                        style: TextStyle(
                                                            fontFamily: 'Libre',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                                3.5,
                                                            color: black,
                                                            letterSpacing: 0.2),
                                                      ),
                                                    ),
                                                  ),
                                                ):Container(),

                                                Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                    padding: EdgeInsets.only(top: 5,bottom: 5),
                                                    child: Center(
                                                        child: Text(
                                                          chalanModel
                                                              .getChalanList()[index]
                                                              .chalan_complete_qty,
                                                          style: TextStyle(
                                                              fontFamily: 'Libre',
                                                              fontWeight: FontWeight.bold,
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
                                          SizedBox(height: 5,),

                                          Row(
                                            children: [
                                              Text("Meter : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                              Text(chalanModel
                                                  .getChalanList()[index]
                                                  .chalan_metere,style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Rate : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                              Text(chalanModel
                                                  .getChalanList()[index]
                                                  .chalan_rate,style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Keep Days : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                              Text("${fetch_day}",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                            ],
                                          ),

                                          Row(
                                            children: [
                                              Text("Financial Year : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                              Text(chalanModel
                                                  .getChalanList()[index]
                                                  .chalan_financial_year,style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("Status : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                              Text(status,style: TextStyle(
                                                  fontFamily: 'Libre',
                                                   fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: status=="Pending" ? hhhh :  status=="Running" ? Colors.orange : status=="Rejected" ? Colors.red:green,
                                                  letterSpacing: 0.2)),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              RaisedButton(
                                                color: hhhh,
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      12), // <-- Radius
                                                ),
                                                onPressed: () {
                                                  chalanModelParamSingleDetail =
                                                  chalanModel
                                                      .getChalanList()[
                                                  index];

                                                  getChalanDetail(
                                                      chalanModel
                                                          .getChalanList()[
                                                      index]
                                                          .chalan_id,
                                                      chalanModel
                                                          .getChalanList()[
                                                      index],
                                                      true);
                                                },
                                                child: Text(
                                                  "Detail",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .white),
                                                ),
                                              ),


                                              Stack(
                                                alignment:
                                                AlignmentDirectional
                                                    .center,
                                                children: <Widget>[
                                                  IconButton(
                                                    icon: Icon(Icons.chat),
                                                    onPressed: () async {
                                                      // addDialog();

                                                      getChatList(
                                                          chalanModel
                                                              .getChalanList()[
                                                          index]
                                                              .chalan_id,
                                                          chalanModel
                                                              .getChalanList()[
                                                          index]
                                                              .sent_chalan_to,
                                                          true,
                                                          index);
                                                    },
                                                  ),

                                                  chalanModel
                                                      .getChalanList()[
                                                  index]
                                                      .count_remark !=
                                                      "0" &&
                                                      !IsSeenMessage[
                                                      index]
                                                      ? Positioned(
                                                    // draw a red marble
                                                    top: 2,
                                                    right: 2.0,
                                                    child: InkWell(
                                                      onTap: () {
                                                        getChatList(
                                                            chalanModel
                                                                .getChalanList()[
                                                            index]
                                                                .chalan_id,
                                                            chalanModel
                                                                .getChalanList()[
                                                            index]
                                                                .chalan_sent_to,
                                                            true,
                                                            index);
                                                      },
                                                      child: Card(
                                                          elevation: 0,
                                                          clipBehavior: Clip
                                                              .antiAlias,
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                4.0),
                                                          ),
                                                          color: Colors
                                                              .redAccent,
                                                          child: Container(
                                                              padding: EdgeInsets.all(2),
                                                              constraints: BoxConstraints(minWidth: 20.0),
                                                              child: Center(
                                                                  child: Text(
                                                                    chalanModel
                                                                        .getChalanList()[
                                                                    index]
                                                                        .count_remark,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        12,
                                                                        fontWeight:
                                                                        FontWeight.w800,
                                                                        color: Colors.white,
                                                                        backgroundColor: Colors.redAccent),
                                                                  )))),
                                                    ),
                                                  )
                                                      : Container()
                                                ],
                                              ),

                                              int.parse( chalanModel
                                                  .getChalanList()[
                                              index]
                                                  .chalan_remain_qty) <
                                                  0 && login_type=="1"
                                                  ? IconButton(
                                                icon: Icon(Icons.send),
                                                onPressed: () async {
                                                  remainQuantityDialog(chalanModel
                                                      .getChalanList()[
                                                  index]
                                                      .chalan_id);
                                                },
                                              )
                                                  : Container(),
                                            ],
                                          ),

                                        ],
                                      ),
                                    )
                                ),
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

  void handleClick(String value) {
    switch (value) {
      case 'All':
        datastatus="";
        getAllChalanList(true,datastatus,"");
        break;
      case 'New':
        datastatus="New";
        getAllChalanList(true,datastatus,"");
        break;
      case 'Pending':
        datastatus="Pending";
        getAllChalanList(true,datastatus,"");
        break;
      case 'Running':
        datastatus="Running";
        getAllChalanList(true,datastatus,"");
        break;
      case 'Completed Part':
        datastatus="DonePart";
        getAllChalanList(true,datastatus,"");
        break;
      case 'Completed':
        datastatus="DoneComplete";
        getAllChalanList(true,datastatus,"");
        break;
      case 'Rejected':
        datastatus="Rejected";
        getAllChalanList(true,datastatus,"");
        break;

    }
  }

  chatOpen(String chalan_id, String reciver) {
    IsChatSend = false;
    messageController.text="";
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState1) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: hhhh,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text("Chat (${reciver})",
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
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                getChatList(chalan_id, reciver, false, -1);
                              },
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
                          controller: chatListScrollController,
                          physics: BouncingScrollPhysics(),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: StreamBuilder(
                                stream: refreshChatList.stream,
                                builder: (context, snapshot) {
                                  return ListView.builder(
                                    // reverse: true,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                      chatRemarkModel.getList().length,
                                      itemBuilder: (context, int index) {
                                        final message =
                                        chatRemarkModel.getList()[index];
                                        bool isMe = chatRemarkModel
                                            .getList()[index]
                                            .remark_sent_by ==
                                            uid;

//ddd, MMM dd yyyy

                                        final chatDate1 = new DateFormat(
                                            "yyyy-MM-dd hh:mm:ss")
                                            .parse(chatRemarkModel
                                            .getList()[index]
                                            .remark_Added_on);

                                        var formatter = new DateFormat(
                                            'dd MMM yyyy hh:mm:ss');
                                        String chatDate =
                                        formatter.format(chatDate1);

                                        return Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: isMe
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                                children: [
                                                  if (!isMe)
                                                    CircleAvatar(
                                                      radius: 15,
                                                      child: Text(
                                                          "${reciver[0].toUpperCase()}"),
                                                      /* backgroundImage: AssetImage(
                                                      "images/logo.png"),*/
                                                    ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    constraints: BoxConstraints(
                                                        maxWidth: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width *
                                                            0.6),
                                                    decoration: BoxDecoration(
                                                        color: isMe
                                                            ? hhhh
                                                            : Colors.grey[200],
                                                        borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              16),
                                                          topRight:
                                                          Radius.circular(
                                                              16),
                                                          bottomLeft:
                                                          Radius.circular(
                                                              isMe
                                                                  ? 12
                                                                  : 0),
                                                          bottomRight:
                                                          Radius.circular(
                                                              isMe
                                                                  ? 0
                                                                  : 12),
                                                        )),
                                                    child: Text(
                                                      chatRemarkModel
                                                          .getList()[index]
                                                          .remark_desc,
                                                      style: MyTheme
                                                          .bodyTextMessage
                                                          .copyWith(
                                                          color: isMe
                                                              ? Colors.white
                                                              : Colors.grey[
                                                          800]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Row(
                                                  mainAxisAlignment: isMe
                                                      ? MainAxisAlignment.end
                                                      : MainAxisAlignment.start,
                                                  children: [
                                                    if (!isMe)
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                    Icon(
                                                      Icons.done_all,
                                                      size: 20,
                                                      color: MyTheme
                                                          .bodyTextTime.color,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      "${chatDate}",
                                                      style:
                                                      MyTheme.bodyTextTime,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                }),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.insert_emoticon,
                                      color: Colors.grey[500],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: messageController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Type your message ...',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[500]),
                                        ),
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
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            CircleAvatar(
                              backgroundColor: IsChatSend
                                  ? hhhh
                                  : Colors.black26,
                              child: IconButton(
                                onPressed: IsChatSend
                                    ? () {
                                  setState1(() {
                                    IsChatSend = false;
                                  });
                                  sendChat(chalan_id,
                                      messageController.text, reciver);
                                }
                                    : null,
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  void show_Dialog(String id, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text(
              "Are you sure delete user ?",
              style: TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isSelected[index] = false;
                  });
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteType(id, index);
                },
              )
            ],
          );
        });
  }

  Future<void> deleteType(String id, int index) async {
    Map<String, dynamic> param = {
      "idsToDelete": id,
      "api_name": "removeUserProcess",
    };
    MessageModelParam IsData =
    await messageModel.add_post(context, param, scaffoldState, true, false);
    if (!IsData.status) {
      //message="No Data";
    } else {
      Share()
          .show_Dialog(context, IsData.message, "Delete User", IsData.status);
      /* setState(() {
        IsComplete[index] = true;
      });*/
      getAllChalanList(false,datastatus,"");
    }
  }

  editDialog(String id, String type) {
    userEditTypeController.text = type;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState1) {
                return Form(
                  key: _formKey,
                  child: Card(
                    elevation: 5,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        color: Colors.black54,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text("Edit",
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
                        margin: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: userEditTypeController,
                          // keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              prefixIcon: Icon(Icons.verified_user, size: 20),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              labelText: "User Type",
                              fillColor: Colors.white70),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter user type';
                            }
                            return null;
                          },
                          onSaved: (value) {},
                        ),
                      ),
                      IsEditTextError
                          ? Text(
                        "Please enter user type !",
                        style: TextStyle(color: Colors.red),
                      )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              color: Colors.black54,
                              child: Text(
                                "Update",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                if (userEditTypeController.text == "") {
                                  setState1(() {
                                    IsEditTextError = true;
                                  });
                                  Timer timer =
                                  new Timer(new Duration(seconds: 3), () {
                                    if (mounted) {
                                      setState1(() {
                                        IsEditTextError = false;
                                      });
                                    }
                                  });
                                  return;
                                }

                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  Navigator.pop(context);
                                  editType(id, userEditTypeController.text);
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                );
              }));
        });
  }

  viewChalanDetail(ChalanModelData chalanModelParam) {
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
                            child: Text("Chalan Detail",
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
                          stream: refreshChatListForChalanDetail.stream,
                          builder: (context, snapshot) {
                            return ListView.builder(
                              // reverse: true,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: chalanDetailModel.getList().length,
                                itemBuilder: (context, int index) {

                                  int lastindex =
                                      chalanDetailModel.getList().length - 1;
                                  print("lastindex===${lastindex}");
                                  return Container(
                                    margin: EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Card(
                                      color: Colors.transparent,
                                      elevation: 0,
                                      child: Container(
                                        // padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(
                                            left: 5, right: 5, top: 5),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                background.withOpacity(0.3),
                                                background
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
                                                MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      padding: EdgeInsets.all(5),
                                                      color: Colors.grey[400],
                                                      child: Text("Quantity  ",
                                                          style: TextStyle(
                                                              fontFamily: 'Libre',
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                                  3.5,
                                                              color: black,
                                                              letterSpacing: 0.2)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                        chalanDetailModel
                                                            .getList()[index]
                                                            .chalan_log_qty,
                                                        style: TextStyle(
                                                            fontFamily: 'Libre',
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                                4,
                                                            color: black,
                                                            letterSpacing: 0.2)),
                                                  ),
                                                ]),
                                            Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      padding: EdgeInsets.all(5),
                                                      color: Colors.grey[400],
                                                      child: Text("Detail : ",
                                                          style: TextStyle(
                                                              fontFamily: 'Libre',
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                                  3.5,
                                                              color: black,
                                                              letterSpacing: 0.2)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                        chalanDetailModel
                                                            .getList()[index]
                                                            .chalan_log_desc,
                                                        style: TextStyle(
                                                            fontFamily: 'Libre',
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                                3.2,
                                                            color: black,
                                                            letterSpacing: 0.2)),
                                                  ),
                                                ]),
                                            Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      padding: EdgeInsets.all(5),
                                                      color: Colors.grey[400],
                                                      child: Text("Date",
                                                          style: TextStyle(
                                                              fontFamily: 'Libre',
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                                  3.5,
                                                              color: black,
                                                              letterSpacing: 0.2)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                        chalanDetailModel
                                                            .getList()[index]
                                                            .chalan_log_Added_on,
                                                        style: TextStyle(
                                                            fontFamily: 'Libre',
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                                3.5,
                                                            color: kTextColor,
                                                            letterSpacing: 0.2)),
                                                  ),
                                                ]),
                                            Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  chalanDetailModel
                                                      .getList()[index]
                                                      .chalan_log_status ==
                                                      "Pending" &&
                                                      lastindex == index
                                                      ? Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10, right: 5),
                                                      child: Column(
                                                        children: [
                                                          RaisedButton(
                                                            color: hhhh,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  12), // <-- Radius
                                                            ),
                                                            onPressed: () {
                                                              selectedPartyList =
                                                              null;
                                                              selectedParty =
                                                              "-1";

                                                              getRunProcess(
                                                                  chalanDetailModel
                                                                      .getList()[
                                                                  index]
                                                                      .chalan_id,
                                                                  "Run");
                                                            },
                                                            child: Text(
                                                              "Run",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                      : Container(),
                                                  chalanDetailModel
                                                      .getList()[index]
                                                      .chalan_log_status ==
                                                      "Running" &&
                                                      lastindex == index
                                                      ? Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10, right: 5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          RaisedButton(
                                                            color: hhhh,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  12), // <-- Radius
                                                            ),
                                                            onPressed: () {
                                                              selectedPartyList =
                                                              null;
                                                              selectedParty =
                                                              "-1";

                                                              getRunProcess(
                                                                  chalanDetailModel
                                                                      .getList()[
                                                                  index]
                                                                      .chalan_id,
                                                                  "Part");
                                                            },
                                                            child: Text(
                                                                "Part",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          RaisedButton(
                                                            color: hhhh,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  12), // <-- Radius
                                                            ),
                                                            onPressed: () {
                                                              selectedPartyList =
                                                              null;
                                                              selectedParty =
                                                              "-1";
                                                              getRunProcess(
                                                                  chalanDetailModel
                                                                      .getList()[
                                                                  index]
                                                                      .chalan_id,
                                                                  "Complete");
                                                            },
                                                            child: Text(
                                                                "Part Complete",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                      : Container(),
                                                  chalanDetailModel
                                                      .getList()[index]
                                                      .chalan_log_status ==
                                                      "DonePart" &&
                                                      lastindex == index
                                                      ? Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10, right: 5),
                                                      child: Column(
                                                        children: [
                                                          RaisedButton(
                                                            color:
                                                            Colors.cyan,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  12), // <-- Radius
                                                            ),
                                                            onPressed: () {
                                                              selectedPartyList =
                                                              null;
                                                              selectedParty =
                                                              "-1";
                                                              getRunProcess(
                                                                  chalanDetailModel
                                                                      .getList()[
                                                                  index]
                                                                      .chalan_id,
                                                                  "Part");
                                                            },
                                                            child: Text(
                                                                "Part",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                      : Container(),
                                                ]),
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

  runProcess() {
    messageController.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState1) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: hhhh,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Text("Run",
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
                        Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: ListView(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              children: [
                                Card(
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
                                              background
                                            ],
                                            begin: const FractionalOffset(0.0, 0.0),
                                            end: const FractionalOffset(1.0, 0.0),
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp),
                                        //  shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(30.0))
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Row(
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
                                                      messageModel
                                                          .getRunChalanDetailList()[
                                                      0]
                                                          .date,
                                                      style: TextStyle(
                                                          fontFamily: 'Libre',
                                                          // fontWeight: FontWeight.bold,
                                                          fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                              3.0,
                                                          color: black,
                                                          letterSpacing: 0.2)),
                                                ],
                                              )
                                            ],
                                          ),
                                          // Divider(color: Colors.black,),

                                          Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Chalan No : ",
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
                                                        messageModel
                                                            .getRunChalanDetailList()[
                                                        0]
                                                            .chalanNo,
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
                                                )
                                              ]),

                                          Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Lot No : ",
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
                                                        messageModel
                                                            .getRunChalanDetailList()[
                                                        0]
                                                            .lotNo,
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
                                              ]),

                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Text("Product : ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                              Text(
                                                  messageModel
                                                      .getRunChalanDetailList()[0]
                                                      .product,
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
                                            MainAxisAlignment.start,
                                            children: [
                                              Text("Sub Product : ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                              Text(
                                                  messageModel
                                                      .getRunChalanDetailList()[0]
                                                      .subproduct,
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
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Text("Design No : ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                              Text(
                                                  messageModel
                                                      .getRunChalanDetailList()[0]
                                                      .dNo,
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
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Text("Pieces : ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                              Text(
                                                  messageModel
                                                      .getRunChalanDetailList()[0]
                                                      .pcs,
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
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Text("Sent By : ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          4.2,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                              Text(
                                                  messageModel
                                                      .getRunChalanDetailList()[0]
                                                      .sentby,
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          3.0,
                                                      color: logocolor,
                                                      letterSpacing: 0.2)),
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                                SizedBox(height: 10,),
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: TextFormField(
                                    controller: messageController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6.0),
                                        ),
                                        prefixIcon:
                                        Icon(Icons.scatter_plot, size: 15),
                                        filled: true,
                                        hintStyle:
                                        TextStyle(color: Colors.grey[800]),
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
                                Column(
                                  children: [
                                    RaisedButton(
                                      color: IsChatSend ? hhhh : Colors.black38,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20.0)),
                                      onPressed: IsChatSend ? () {
                                        Navigator.pop(context);
                                        run_process(
                                            messageModel
                                                .getRunChalanDetailList()[0]
                                                .notification_id,
                                            messageController.text);
                                      }:null,
                                      child: Text(
                                        "Run",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
        });
  }

  Future<void> getRunProcess(String chalan_id, String type) async {
    Map<String, dynamic> map = new Map();
    map['chalan_id'] = chalan_id;
    map['btn_type'] = type;
    map['api_name'] = "fetchDetailForButtonProcess";
    MessageModelParam data = await messageModel
        .add_post(context, map, scaffoldState, true, true)
        .then((value) {
      if (value.status) {
        if (type == "Run") {
          runProcess();
        } else if (type == "Part" || type == "Complete") {
          partComplateProcess(type);
        }
      }
    });
  }

  partComplateProcess(String type) {
    quantityController.text =
        messageModel.getPartChalanDetailList()[0].chalan_qty;
    if (type == "Complete") {
      comQuantityController.text =
          messageModel.getPartChalanDetailList()[0].chalan_process_qty;
    } else {
      comQuantityController.text = "";
    }
    rateController.text = messageModel.getPartChalanDetailList()[0].chalan_rate;
    deleveryChalanNoController.text = "";

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState1) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: hhhh,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text("Forward Process",
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
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: ListView(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              partyDropDownList(setState1),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: TextFormField(
                                  controller: quantityController,
                                  enabled: false,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      prefixIcon:
                                      Icon(Icons.scatter_plot, size: 15),
                                      filled: true,
                                      hintStyle: TextStyle(color: Colors.grey[800]),
                                      labelText: "Quantity",
                                      hintText: 'Enter Quantity',
                                      fillColor: Colors.white70),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: TextFormField(
                                  controller: comQuantityController,
                                  enabled: type == "Complete" ? false : true,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      prefixIcon:
                                      Icon(Icons.scatter_plot, size: 15),
                                      filled: true,
                                      hintStyle: TextStyle(color: Colors.grey[800]),
                                      labelText: "Complete Quantity",
                                      hintText: 'Enter Complete Quantity',
                                      fillColor: Colors.white70),
                                  onChanged: (value) {
                                    setState1(() {
                                      if (int.parse(value) >
                                          int.parse(messageModel
                                              .getPartChalanDetailList()[0]
                                              .chalan_process_qty)) {
                                        IsQuantityError = true;
                                        error_message =
                                        "Please enter a value less than or equal to ${messageModel.getPartChalanDetailList()[0].chalan_process_qty}";
                                      } else {
                                        IsQuantityError = false;
                                      }
                                    });
                                  },
                                ),
                              ),
                              IsQuantityError
                                  ? Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Center(
                                  child: Text(
                                    "Please enter a value less than or equal to ${messageModel.getPartChalanDetailList()[0].chalan_process_qty}",
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
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: TextFormField(
                                  controller: deleveryChalanNoController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      prefixIcon:
                                      Icon(Icons.scatter_plot, size: 15),
                                      filled: true,
                                      hintStyle: TextStyle(color: Colors.grey[800]),
                                      labelText: "Delivery Chalan No",
                                      hintText: 'Enter Delivery Chalan No',
                                      fillColor: Colors.white70),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: TextFormField(
                                  controller: rateController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      prefixIcon:
                                      Icon(Icons.scatter_plot, size: 15),
                                      filled: true,
                                      hintStyle: TextStyle(color: Colors.grey[800]),
                                      labelText: "Rate",
                                      hintText: 'Enter Rate',
                                      fillColor: Colors.white70),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  RaisedButton(
                                    color: hhhh,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0)),
                                    onPressed: () {
                                      if (selectedParty == "-1") {
                                        setState1(() {
                                          IsEditTextError1 = true;
                                          error_message = "Please select user !";
                                        });
                                        Timer timer =
                                        new Timer(new Duration(seconds: 3), () {
                                          if (mounted) {
                                            setState1(() {
                                              IsEditTextError1 = false;
                                            });
                                          }
                                        });
                                        return;
                                      }
                                      if (quantityController.text == "") {
                                        setState1(() {
                                          IsEditTextError1 = true;
                                          error_message = "Please enter quantity !";
                                        });
                                        Timer timer =
                                        new Timer(new Duration(seconds: 3), () {
                                          if (mounted) {
                                            setState1(() {
                                              IsEditTextError1 = false;
                                            });
                                          }
                                        });
                                        return;
                                      } else if (comQuantityController.text == "") {
                                        setState1(() {
                                          IsEditTextError1 = true;
                                          error_message =
                                          "Please enter complete quantity !";
                                        });
                                        Timer timer =
                                        new Timer(new Duration(seconds: 3), () {
                                          if (mounted) {
                                            setState1(() {
                                              IsEditTextError1 = false;
                                            });
                                          }
                                        });
                                        return;
                                      } else if (IsQuantityError) {
                                        setState1(() {
                                          IsEditTextError1 = true;
                                          error_message =
                                          "Please enter a value less than or equal to ${messageModel.getPartChalanDetailList()[0].chalan_process_qty}";
                                        });
                                        Timer timer =
                                        new Timer(new Duration(seconds: 3), () {
                                          if (mounted) {
                                            setState1(() {
                                              IsEditTextError1 = false;
                                            });
                                          }
                                        });
                                        return;
                                      } else if (deleveryChalanNoController.text ==
                                          "") {
                                        setState1(() {
                                          IsEditTextError1 = true;
                                          error_message =
                                          "Please enter delivery chalan no !";
                                        });
                                        Timer timer =
                                        new Timer(new Duration(seconds: 3), () {
                                          if (mounted) {
                                            setState1(() {
                                              IsEditTextError1 = false;
                                            });
                                          }
                                        });
                                        return;
                                      } else {
                                        Navigator.pop(context);

                                        partCompleteProcess(
                                            type,
                                            comQuantityController.text,
                                            deleveryChalanNoController.text,
                                            rateController.text);
                                      }
                                    },
                                    child: Text(
                                      "Send",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              IsEditTextError1
                                  ? Center(
                                child: Text(
                                  error_message,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }));
        });
  }

  Widget partyDropDownList(StateSetter setState1) {
    return StreamBuilder(
      stream: partyModel.GetAllParty,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          /*if (snapshot.data[0].admin_id != "-1") {
            (snapshot.data as List<PartyModelParam>).insert(
                0, PartyModelParam(admin_id: "-1", admin_og_name: "Select User"));
          }*/

         // (snapshot.data as List<PartyModelParam>).removeWhere((element) => element.admin_og_name.toLowerCase()==username.toLowerCase());

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
                child: DropdownButton<PartyModelParam>(
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
                  onChanged: (PartyModelParam newValue) {
                    setState1(() {
                      // cou = newValue;
                      selectedPartyList = newValue;
                      selectedParty = newValue.admin_id;
                      print("select party ${selectedParty}");
                    });
                  },
                  items: snapshot.data
                      .map<DropdownMenuItem<PartyModelParam>>((value) {
                    //print("kya aayya ${value.admin_name.toString()}");
                    return DropdownMenuItem<PartyModelParam>(
                      value: value,
                      child: Text(value.admin_og_name),
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

  remainQuantityDialog(String chalan_id) {
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
                              child: Text("Send Remain Quantity",
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
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          controller: messageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              prefixIcon:
                              Icon(Icons.scatter_plot, size: 15),
                              filled: true,
                              hintStyle:
                              TextStyle(color: Colors.grey[800]),
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
                      SizedBox(height: 10,),
                      RaisedButton(
                        color: IsChatSend ? hhhh : Colors.black26,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20.0)),
                        onPressed: () {
                          Navigator.pop(context);
                          remainProcessing(chalan_id,messageController.text);

                        },
                        child: Text(
                          "Run",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  );
                }),
          );
        });
  }

  remainProcessing(String chalan_id,String quantity)
  async {
    Map<String,dynamic> map=new Map();
    map['session_admin_id']=uid;
    map['chalan_id']=chalan_id;
    map['qty_to_send']=quantity;
    map['api_name']="sendRemainQtyProcess";

    MessageModelParam IsData =
    await messageModel.add_post(context, map, scaffoldState, true, false);
    if (!IsData.status) {
      //message="No Data";
    } else {
      useraddTypeController.text = "";
      Share()
          .show_Dialog(context, IsData.message, "Send Remain Qty", IsData.status);

      getAllChalanList(false,datastatus,"");
    }

  }

  Future<void> editType(String id, String type) async {
    Map<String, dynamic> param = {
      "userTypeId": id,
      "userTypeValue": type,
      "api_name": "editUserTypeProcess",
    };
    MessageModelParam IsData =
    await messageModel.add_post(context, param, scaffoldState, true, false);
    if (!IsData.status) {
      //message="No Data";
    } else {
      Share().show_Dialog(
          context, IsData.message, "Edit User Type", IsData.status);

      getAllChalanList(false,datastatus,"");
    }
  }

  Future<void> addType(String type) async {
    Map<String, dynamic> param = {
      "inputUserType": type,
      "api_name": "addTypeProcess",
    };
    MessageModelParam IsData =
    await messageModel.add_post(context, param, scaffoldState, true, false);
    if (!IsData.status) {
      //message="No Data";
    } else {
      useraddTypeController.text = "";
      Share()
          .show_Dialog(context, IsData.message, "Add User Type", IsData.status);

      getAllChalanList(false,datastatus,"");
    }
  }

  Future<void> getAllChalanList(bool status,String filter,String search) async {
    Map<String, dynamic> param = {
      "searchField": search,
      "lotNoFilter": "",
      "dateFilter": "",
      "userFilter": "",
      "productFilter": "",
      "chalanFilter": "",
      "statusFilter": filter,
      "processFilter": "",
      "financialyearFilter": "",
      "session_admin_login_type": login_type,
      "session_admin_id": uid.toString(),
      "sessionYear": financialYear,
      "page": page.toString(),
      "api_name":"viewAllReportProcess",
    };




    bool Isload = await chalanModel.fetchList(
        context, param, scaffoldState, status, false);
    if (Isload) {
      refreshChatListForAll.add({});
    }
  }

  void _onChange(String value) {
    if (value.isNotEmpty) {
      if (value.length > 0) {
        getAllChalanList(true,datastatus,value);
      }
    }
  }

  Future<void> getChalanDetail(
      String chalan_id, ChalanModelData chalanModelParam, bool status) async {
    Map<String, dynamic> map = new Map();
    map['searchField'] = '';
    map['chalan_id'] = chalan_id;
    map['api_name'] = "viewChalanDetailProcess";

    bool data = await chalanDetailModel.fetchList(
        context, map, scaffoldState, status, false);

    if (data) {
      print("I am in");
      if (status) {
        viewChalanDetail(chalanModelParam);
      } else {
        print("refresf==========");
        refreshChatListForChalanDetail.add({});
      }
    }
  }

  Future<void> getChatList(
      String chalan_id, String reciver, bool status, int index) async {
    Map<String, dynamic> map = new Map();
    map['session_admin_id'] = uid;
    map['chalan_id'] = chalan_id;
    map['api_name'] = "viewRemarkProcess";
    bool data = await chatRemarkModel.fetchList(
        context, map, scaffoldState, status, false);

    if (data) {
      if (status) {
        setState(() {
          chat_chalan_id=chalan_id;
          chat_receiver=reciver;
          IsSeenMessage[index] = true;
        });
        chatOpen(chalan_id, reciver);
      } else {
        refreshChatList.add({});
        chatListScrollController.animateTo(
            chatListScrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.linear);
      }
    }
  }

  Future<void> sendChat(
      String chalan_id, String message, String reciver) async {
    Map<String, dynamic> map = new Map();
    map['session_admin_id'] = uid;
    map['chalan_id'] = chalan_id;
    map['remarkMessage'] = message;
    map['api_name'] = "sendRemarkProcess";

    MessageModelParam data =
    await messageModel.add_post(context, map, scaffoldState, false, false);

    if (data.status) {
      messageController.text = "";
      getChatList(chalan_id, reciver, false, -1);

      //chatOpen();
    }
  }

  Future<void> run_process(String chalan_id, String quantity) async {
    Map<String, dynamic> map = new Map();
    map['session_admin_id'] = uid;
    map['notificationIdForRun'] = chalan_id;
    map['qtyToRun'] = quantity;
    map['api_name'] = "runLotProcess";
    MessageModelParam data =
    await messageModel.add_post(context, map, scaffoldState, true, false);
    if (data.status) {
      messageController.text = "";
      getChalanDetail(chalanModelParamSingleDetail.chalan_id,
          chalanModelParamSingleDetail, false);
    }
    Share().show_Dialog(context, data.message, "Forward Process", data.status);
  }

  Future<void> partCompleteProcess(
      String type, String cQantity, String chalan_no, String rate) async {
    Map<String, dynamic> map = new Map();
    map['chalanId'] = messageModel.getPartChalanDetailList()[0].chalan_id;
    map['partCompleteStatusGlobal'] = type;
    map['inputDoneLotQty'] = cQantity;
    map['selectpartytoforward'] = selectedParty;
    map['session_admin_id'] = uid;
    map['inputRate2'] = rate;
    map['inputDeliveryChalanNo'] = chalan_no;
    map['api_name'] = "sendCompleteLotProcess";

    MessageModelParam data =
    await messageModel.add_post(context, map, scaffoldState, true, false);
    if (data.status) {
      messageController.text = "";

      getChalanDetail(chalanModelParamSingleDetail.chalan_id,
          chalanModelParamSingleDetail, false);
    }
    Share().show_Dialog(context, data.message, "Forward Process", data.status);
  }

  void getNotificationChat()
  {
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {});
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

      _fcm.configure(onMessage: (Map<String, dynamic> message) async {
        called = true;
        String value1 = "";
        String flag = "";
        if (Platform.isIOS) {
          if (message['aps'] != null && message['aps']['alert'] != null) {
            message['notification'] = message['aps']['alert'];
          }
          if (message['notification'] != null) {
            message['data'] = message['notification'];
          }
        }
        value1 = message['data']['body'];
        flag = message['data']['type'];
        if (message['data']['image'] == null) {
          message['data']['image'] = "";
        }

        getData(flag);

      }, onLaunch: (Map<String, dynamic> message) async {
        called = true;
        String value1 = "";
        String flag = "";
        if (Platform.isIOS) {
          if (message['aps'] != null && message['aps']['alert'] != null) {
            message['notification'] = message['aps']['alert'];
          }
          if (message['notification'] != null) {
            message['data'] = message['notification'];
          }
        }
        value1 = message['data']['body'];
        flag = message['data']['type'];
        //_onSubmitted(value1, 'launch', flag);
      }, onResume: (Map<String, dynamic> message) async {
        called = true;
        String value1 = "";
        String flag = "";
        if (Platform.isIOS) {
          if (message['aps'] != null && message['aps']['alert'] != null) {
            message['notification'] = message['aps']['alert'];
          }
          if (message['notification'] != null) {
            message['data'] = message['notification'];
          }
        }
        value1 = message['data']['body'];
        flag = message['data']['type'];
        //_onSubmitted(value1, 'resume', flag);
      });
  }
  void getData(String type) {
    if(type=="chat")
    {
      if(chat_chalan_id !="") {
        getChatList(chat_chalan_id, chat_receiver, false, -1);
      }
    }

  }
}
