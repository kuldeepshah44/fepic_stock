import 'dart:async';
import 'dart:io';

import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/chat_remark_model.dart';
import 'package:fepic_stock/model/financialYearModal.dart';
import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/party_model.dart';
import 'package:fepic_stock/model/user_chalan_model.dart';
import 'package:fepic_stock/utility/chat_theme.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class UserChalanList extends StatefulWidget {
  String title;
bool IsLoader;
  UserChalanList({Key key, this.title,this.IsLoader=true})
      : super(key: key);
  @override
  _UserChalanListState createState() => _UserChalanListState();
}

class _UserChalanListState extends State<UserChalanList> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  List<bool> IsSeenMessage = [];
  int page = 1;
  UserModel userModel;
  ChatRemarkModel chatRemarkModel;

  StreamController refreshAllUserChalanList = StreamController.broadcast();
  StreamController refreshLotDetailList = StreamController.broadcast();
  StreamController refreshChatList = StreamController.broadcast();
  var uid;
  var login_type;
  var financialYear;
  MessageModel messageModel;
  //ChalanModel chalanModel;
  UserChalanModel userChalanModel;
  String datastatus = "Pending";
  TextEditingController quantityController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();
  TextEditingController comQuantityController = new TextEditingController();
  TextEditingController rateController = new TextEditingController();
  TextEditingController deleveryChalanNoController = new TextEditingController();
  bool IsChatSend = false;
  ScrollController chatListScrollController = ScrollController();

  PartyModel partyModel;
  PartyModelParam selectedPartyList;
  String selectedParty = "-1";
  bool IsQuantityError=false;
  bool IsEditTextError1 = false;
  String error_message = "";
String message="";

  String chat_chalan_id="";
  String chat_receiver="";


  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool _fromTop = true;
  bool called = false;
  static const platform = MethodChannel('com.siliconleaf.fepic_stock');
  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    datastatus=widget.title;
    userChalanModel = new UserChalanModel();
    messageModel = Provider.of<MessageModel>(context, listen: false);
    chatRemarkModel = Provider.of<ChatRemarkModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
   // chalanModel = Provider.of<ChalanModel>(context, listen: false);
    userChalanModel = Provider.of<UserChalanModel>(context, listen: false);
    partyModel = Provider.of<PartyModel>(context, listen: false);
    getNotificationChat();
    getUserSession();
  }

  Future<void> getUserSession() async {
    uid = await userModel.getUserId();
    login_type = await userModel.getUserType();
    financialYear = await  Share().currentFinancialYear();
    print("uid====${uid}==login_type==${login_type}");
    getAllNewUserChalanList(datastatus);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: Text("${datastatus} List",
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
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Pending', 'Running', 'Done'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        color: background,
        child: Column(
          children: [
            Expanded(
              child: LazyLoadScrollView(
                scrollOffset: 10,
                onEndOfPage: () {
                  page = page + 1;
                  //getAlterChalan(datastatus);
                },
                child: StreamBuilder(
                  stream: refreshAllUserChalanList.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return LiquidPullToRefresh(
                        color: background,
                        backgroundColor: mTextDisplayColor,
                        key: _refreshIndicatorKey,
                        // key if you want to add
                        onRefresh: () async {
                          page = 1;
                          getAllNewUserChalanList(datastatus);
                        },
                        showChildOpacityTransition: false,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: datastatus == "Pending"
                                ? userChalanModel.getPendingList().length
                                : datastatus == "Running"
                                    ? userChalanModel.getRunningList().length
                                    : userChalanModel.getDoneList().length,
                            itemBuilder: (context, index) {
                              IsSeenMessage.add(false);
                              String chat_remaining = datastatus == "Pending"
                                  ? userChalanModel
                                      .getPendingList()[index]
                                      .chalan_count_remain
                                  : datastatus == "Running"
                                      ? userChalanModel
                                          .getRunningList()[index]
                                          .chalan_count_remain
                                      : userChalanModel
                                          .getDoneList()[index]
                                          .chalan_count_remain;

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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("Date : ",
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
                                                      0.2)),
                                              Text(
                                                  datastatus ==
                                                      "Pending"
                                                      ? userChalanModel
                                                      .getPendingList()[
                                                  index]
                                                      .chalanDetailParam
                                                      .chalan_Added_on
                                                      : datastatus ==
                                                      "Running"
                                                      ? userChalanModel
                                                      .getRunningList()[
                                                  index]
                                                      .chalanDetailParam
                                                      .chalan_Added_on
                                                      : userChalanModel
                                                      .getDoneList()[
                                                  index]
                                                      .chalanDetailParam
                                                      .chalan_Added_on,
                                                  style: TextStyle(
                                                      fontFamily:
                                                      'Libre',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          3.0,
                                                      color: black,
                                                      letterSpacing:
                                                      0.2)),
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
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
                                                  datastatus == "Pending"
                                                      ? userChalanModel
                                                      .getPendingList()[
                                                  index]
                                                      .chalanno
                                                      : datastatus == "Running"
                                                      ? userChalanModel
                                                      .getRunningList()[
                                                  index]
                                                      .chalanno
                                                      : userChalanModel
                                                      .getDoneList()[
                                                  index]
                                                      .chalanno,
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
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("Lot No : ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      //  fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                              Text(
                                                  datastatus == "Pending"
                                                      ? userChalanModel
                                                      .getPendingList()[
                                                  index]
                                                      .lotno
                                                      : datastatus == "Running"
                                                      ? userChalanModel
                                                      .getRunningList()[
                                                  index]
                                                      .lotno
                                                      : userChalanModel
                                                      .getDoneList()[
                                                  index]
                                                      .lotno,
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
                                          Divider(),
                                          Row(
                                            children: [
                                              Text("Design No : ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      //  fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                              Text(
                                                  datastatus == "Pending"
                                                      ? userChalanModel
                                                          .getPendingList()[
                                                              index]
                                                          .designno
                                                      : datastatus == "Running"
                                                          ? userChalanModel
                                                              .getRunningList()[
                                                                  index]
                                                              .designno
                                                          : userChalanModel
                                                              .getDoneList()[
                                                                  index]
                                                              .designno,
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
                                              Text("Pieces : ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      //  fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                              Text(
                                                  datastatus == "Pending"
                                                      ? userChalanModel
                                                          .getPendingList()[
                                                              index]
                                                          .pieces
                                                      : datastatus == "Running"
                                                          ? userChalanModel
                                                              .getRunningList()[
                                                                  index]
                                                              .pieces
                                                          : userChalanModel
                                                              .getDoneList()[
                                                                  index]
                                                              .pieces,
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

                                          Divider(),
                                          Container(
                                            height: 50,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  RaisedButton(
                                                    color: hhhh,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0)),
                                                    onPressed: () {
                                                      viewDetail(
                                                          false,
                                                          datastatus ==
                                                                  "Pending"
                                                              ? userChalanModel
                                                                  .getPendingList()[
                                                                      index]
                                                                  .chalanDetailParam
                                                              : datastatus ==
                                                                      "Running"
                                                                  ? userChalanModel
                                                                      .getRunningList()[
                                                                          index]
                                                                      .chalanDetailParam
                                                                  : userChalanModel
                                                                      .getDoneList()[
                                                                          index]
                                                                      .chalanDetailParam);
                                                    },
                                                    child: Text(
                                                      "Detail",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  datastatus == "Pending"
                                                      ? RaisedButton(
                                                          color: green,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                          onPressed: () {
                                                            viewDetail(
                                                                true,
                                                                datastatus ==
                                                                        "Pending"
                                                                    ? userChalanModel
                                                                        .getPendingList()[
                                                                            index]
                                                                        .chalanButtonTypeParam[
                                                                            0]
                                                                        .parameter_to_pass
                                                                    : datastatus ==
                                                                            "Running"
                                                                        ? userChalanModel
                                                                            .getRunningList()[
                                                                                index]
                                                                            .chalanDetailParam
                                                                        : userChalanModel
                                                                            .getDoneList()[index]
                                                                            .chalanDetailParam);
                                                          },
                                                          child: Text(
                                                            "Run",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : Container(),
                                                  datastatus == "Pending"
                                                      ? SizedBox(
                                                          width: 10,
                                                        )
                                                      : Container(),
                                                  datastatus == "Running"
                                                      ? ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount: userChalanModel
                                                              .getRunningList()[
                                                                  index]
                                                              .chalanButtonTypeParam
                                                              .length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemBuilder: (context,
                                                              index1) {
                                                            return Row(
                                                              children: [
                                                                RaisedButton(
                                                                  color: hhhh,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0)),
                                                                  onPressed:
                                                                      () {
                                                                        partComplateProcess(userChalanModel
                                                                            .getRunningList()[
                                                                        index]
                                                                            .chalanButtonTypeParam[
                                                                        index1]
                                                                            .btn_name,userChalanModel
                                                                            .getRunningList()[
                                                                        index]);
                                                                      },
                                                                  child: Text(
                                                                    userChalanModel
                                                                        .getRunningList()[
                                                                            index]
                                                                        .chalanButtonTypeParam[
                                                                            index1]
                                                                        .btn_name,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                              ],
                                                            );
                                                          })
                                                      : Container(),
                                                  Container(
                                                    color: Colors.deepPurple,
                                                    height: 40,
                                                    child: Stack(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .center,
                                                      children: <Widget>[
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.chat,
                                                            color: Colors.white,
                                                          ),
                                                          onPressed: () async {
                                                            IsChatSend = false;
                                                            messageController
                                                                .text = "";

                                                            String chalan_id = datastatus ==
                                                                    "Pending"
                                                                ? userChalanModel
                                                                    .getPendingList()[
                                                                        index]
                                                                    .chalanRemarkDetail
                                                                    .chalan_id
                                                                : datastatus ==
                                                                        "Running"
                                                                    ? userChalanModel
                                                                        .getRunningList()[
                                                                            index]
                                                                        .chalanRemarkDetail
                                                                        .chalan_id
                                                                    : userChalanModel
                                                                        .getDoneList()[
                                                                            index]
                                                                        .chalanRemarkDetail
                                                                        .chalan_id;

                                                            String receiver = datastatus ==
                                                                    "Pending"
                                                                ? userChalanModel
                                                                    .getPendingList()[
                                                                        index]
                                                                    .chalanDetailParam
                                                                    .admin_og_name
                                                                : datastatus ==
                                                                        "Running"
                                                                    ? userChalanModel
                                                                        .getRunningList()[
                                                                            index]
                                                                        .chalanDetailParam
                                                                        .admin_og_name
                                                                    : userChalanModel
                                                                        .getDoneList()[
                                                                            index]
                                                                        .chalanDetailParam
                                                                        .admin_og_name;

                                                            getChatList(
                                                                chalan_id,
                                                                receiver,
                                                                true,
                                                                index);
                                                          },
                                                        ),
                                                        chat_remaining != "0" &&
                                                                !IsSeenMessage[
                                                                    index]
                                                            ? Positioned(
                                                                // draw a red marble
                                                                top: 2,
                                                                right: 2.0,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    IsChatSend =
                                                                        false;
                                                                    messageController
                                                                        .text = "";

                                                                    String chalan_id = datastatus ==
                                                                            "Pending"
                                                                        ? userChalanModel
                                                                            .getPendingList()[
                                                                                index]
                                                                            .chalanRemarkDetail
                                                                            .chalan_id
                                                                        : datastatus ==
                                                                                "Running"
                                                                            ? userChalanModel.getRunningList()[index].chalanRemarkDetail.chalan_id
                                                                            : userChalanModel.getDoneList()[index].chalanRemarkDetail.chalan_id;

                                                                    String receiver = datastatus ==
                                                                            "Pending"
                                                                        ? userChalanModel
                                                                            .getPendingList()[
                                                                                index]
                                                                            .chalanDetailParam
                                                                            .admin_og_name
                                                                        : datastatus ==
                                                                                "Running"
                                                                            ? userChalanModel.getRunningList()[index].chalanDetailParam.admin_og_name
                                                                            : userChalanModel.getDoneList()[index].chalanDetailParam.admin_og_name;

                                                                    getChatList(
                                                                        chalan_id,
                                                                        receiver,
                                                                        true,
                                                                        index);
                                                                  },
                                                                  child: Card(
                                                                      elevation:
                                                                          0,
                                                                      clipBehavior:
                                                                          Clip
                                                                              .antiAlias,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4.0),
                                                                      ),
                                                                      color: Colors
                                                                          .redAccent,
                                                                      child: Container(
                                                                          padding: EdgeInsets.all(2),
                                                                          constraints: BoxConstraints(minWidth: 20.0),
                                                                          child: Center(
                                                                              child: Text(
                                                                            chat_remaining,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w800,
                                                                                color: Colors.white,
                                                                                backgroundColor: Colors.redAccent),
                                                                          )))),
                                                                ),
                                                              )
                                                            : Container()
                                                      ],
                                                    ),
                                                  ),

                                                  /*  RaisedButton(
                                                    color: remark,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20.0)),
                                                    onPressed: () {

                                                      String chalan_id=datastatus == "Pending" ? userChalanModel.getPendingList()[index].chalanRemarkDetail.chalan_id:
                                                      datastatus == "Running" ? userChalanModel.getRunningList()[index].chalanRemarkDetail.chalan_id:userChalanModel.getDoneList()[index].chalanRemarkDetail.chalan_id;

                                                      String receiver=datastatus == "Pending" ? userChalanModel.getPendingList()[index].chalanDetailParam.admin_og_name:
                                                      datastatus == "Running" ? userChalanModel.getRunningList()[index].chalanDetailParam.admin_og_name:userChalanModel.getDoneList()[index].chalanDetailParam.admin_og_name;


                                                      getChatList(
                                                          chalan_id,
                                                          receiver,
                                                          true,
                                                          index);

                                                    },
                                                    child: Text(
                                                      "Remark",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )*/
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              );
                            }),
                      );
                    } else {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 100),
                          child: Text(message,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: black),),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Pending':
        datastatus = "Pending";
        widget.IsLoader=true;
        getAllNewUserChalanList(datastatus);
        break;
      case 'Running':
        datastatus = "Running";
        widget.IsLoader=true;
        getAllNewUserChalanList(datastatus);
        break;
      case 'Done':
        datastatus = "Done";
        widget.IsLoader=true;
        getAllNewUserChalanList(datastatus);
        break;
    }
  }

  viewDetail(bool IsRun, var detail) {
    quantityController.text = "";
    IsChatSend = false;
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
                          child: Text("Detail",
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
                  Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [background.withOpacity(0.3), background],
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
                                Row(
                                  children: [
                                    Text("Date : ",
                                        style: TextStyle(
                                            fontFamily: 'Libre',
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    3.5,
                                            color: black,
                                            letterSpacing: 0.2)),
                                    Text(detail.chalan_Added_on,
                                        style: TextStyle(
                                            fontFamily: 'Libre',
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    3.0,
                                            color: black,
                                            letterSpacing: 0.2)),
                                  ],
                                )
                              ],
                            ),
                            // Divider(color: Colors.black,),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
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
                                      Text(detail.chalan_no,
                                          style: TextStyle(
                                              fontFamily: 'Libre',
                                              fontWeight: FontWeight.bold,
                                              fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                  3.5,
                                              color: logocolor2,
                                              letterSpacing: 0.2)),
                                    ],
                                  )
                                ]),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
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
                                      Text(detail.lot_no,
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
                                ]),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Product : ",
                                    style: TextStyle(
                                        fontFamily: 'Libre',
                                        // fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                3.5,
                                        color: black,
                                        letterSpacing: 0.2)),
                                Text(detail.product_name,
                                    style: TextStyle(
                                        fontFamily: 'Libre',
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                3.5,
                                        color: black,
                                        letterSpacing: 0.2)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Sub Product : ",
                                    style: TextStyle(
                                        fontFamily: 'Libre',
                                        //  fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                3.5,
                                        color: black,
                                        letterSpacing: 0.2)),
                                Text(detail.sub_product_name,
                                    style: TextStyle(
                                        fontFamily: 'Libre',
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                3.5,
                                        color: black,
                                        letterSpacing: 0.2)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Design No : ",
                                    style: TextStyle(
                                        fontFamily: 'Libre',
                                        //  fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                3.5,
                                        color: black,
                                        letterSpacing: 0.2)),
                                Text(detail.product_design_no,
                                    style: TextStyle(
                                        fontFamily: 'Libre',
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                3.5,
                                        color: black,
                                        letterSpacing: 0.2)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Pieces : ",
                                    style: TextStyle(
                                        fontFamily: 'Libre',
                                        // fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                3.5,
                                        color: black,
                                        letterSpacing: 0.2)),
                                Text(detail.chalan_qty,
                                    style: TextStyle(
                                        fontFamily: 'Libre',
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                3.5,
                                        color: black,
                                        letterSpacing: 0.2)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Sent By : ",
                                    style: TextStyle(
                                        fontFamily: 'Libre',
                                        // fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                3.5,
                                        color: black,
                                        letterSpacing: 0.2)),
                                Text(detail.admin_og_name,
                                    style: TextStyle(
                                        fontFamily: 'Libre',
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                3.5,
                                        color: logocolor,
                                        letterSpacing: 0.2)),
                              ],
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  IsRun
                      ? Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: quantityController,
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
                        )
                      : Container(),
                  IsRun
                      ? Column(
                          children: [
                            RaisedButton(
                              color: IsChatSend ? hhhh : Colors.black26,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              onPressed: IsChatSend
                                  ? () {
                                      print(
                                          "notification===${detail.notification_id}");
                                      Navigator.pop(context);
                                      run_process(detail.notification_id,
                                          quantityController.text);
                                    }
                                  : null,
                              child: Text(
                                "Run",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
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

  Future<void> getAllNewUserChalanList(String type) async {
    message="";
    Map<String, dynamic> param = {
      "searchField": "",
      "session_admin_id": uid,
      "sessionYear": financialYear,
      "list_status": type,
      "page": page.toString(),
      "api_name": "viewAllListProcess",
    };
    // print(param);

    bool Isload = await userChalanModel.fetchList(
        context, param, scaffoldState, widget.IsLoader, false);
    if (Isload) {
      refreshAllUserChalanList.add({});
    }
    else
      {
        message="No Data Found !";
      }
    setState(() {});
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
      quantityController.text = "";
      Share()
          .show_Dialog(context, data.message, "Forward Process", data.status);
      //getAllNewUserChalanList(datastatus);
      datastatus = "Running";
      getAllNewUserChalanList(datastatus);

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
          IsSeenMessage[index] = true;
          chat_chalan_id=chalan_id;
          chat_receiver=reciver;
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

  chatOpen(String chalan_id, String reciver) {
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
                              backgroundColor:
                                  IsChatSend ? hhhh : Colors.black26,
                              child: IconButton(
                                onPressed: IsChatSend
                                    ? () {
                                  setState1(() {
                                    IsChatSend=false;
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
      IsChatSend = false;
      messageController.text = "";
      getChatList(chalan_id, reciver, false, -1);

      //chatOpen();
    }
  }

  partComplateProcess(String type,var detail) {
    quantityController.text = detail.chalanDetailParam.chalan_qty;
    if (type == "Complete") {
      comQuantityController.text = detail.pieces;
    } else {
      comQuantityController.text = "";
    }
    rateController.text = "0";
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
                                          int.parse(detail.pieces)) {
                                        IsQuantityError = true;
                                        error_message =
                                        "Please enter a value less than or equal to ${detail.pieces}";
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
                                    "Please enter a value less than or equal to ${detail.pieces}",
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
                                          "Please enter a value less than or equal to ${detail.pieces}";
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
                                        print("chalan id=====${detail.chalanRemarkDetail.chalan_id}");

                                        partCompleteProcess(detail.chalanRemarkDetail.chalan_id,
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
        /*  if (snapshot.data[0].admin_id != "-1") {
            (snapshot.data as List<PartyModelParam>).insert(
                0, PartyModelParam(admin_id: "-1", admin_og_name: "Select User"));
          }*/

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

  Future<void> partCompleteProcess(String chalan_id,
      String type, String cQantity, String chalan_no, String rate) async {
    Map<String, dynamic> map = new Map();
    map['chalanId'] =chalan_id;
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
     // getAllNewUserChalanList(datastatus);
     /* getChalanDetail(chalanModelParamSingleDetail.chalan_id,
          chalanModelParamSingleDetail, false);*/
      widget.IsLoader=true;
      datastatus = "Done";
      getAllNewUserChalanList(datastatus);
    }
    //Share().show_Dialog(context, data.message, "Forward Process", data.status);


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
