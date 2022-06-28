import 'dart:async';

import 'package:fepic_stock/activity/screen_adapter/notification_layout.dart';
import 'package:fepic_stock/activity/user_screen/user_chalan_list.dart';
import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/financialYearModal.dart';
import 'package:fepic_stock/model/lot_model.dart';
import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/notification_model.dart';
import 'package:fepic_stock/model/user_party_model.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class NotificationMasterActivity extends StatefulWidget {
  @override
  _NotificationMasterActivityState createState() =>
      _NotificationMasterActivityState();
}

class _NotificationMasterActivityState
    extends State<NotificationMasterActivity> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  TextEditingController messageController = new TextEditingController();
  NotificationModel notificationModel;
  MessageModel messageModel;
 // ChalanModel chalanModel;
  UserPartyModel userPartyModel;
  UserPartyModelParam selectedPartyList;
  String selectedParty = "-1";
  int page = 1;
  UserModel userModel;
  StreamController refreshAllNotificationList = StreamController.broadcast();
  StreamController refreshLotDetailList = StreamController.broadcast();
  var uid;
  var login_type;
  var financialYear;
  bool IsQuantityError = false;
  String message="";


  TextEditingController searController = new TextEditingController();
  bool IsClickSearch = false;
  @override
  void initState() {
    super.initState();
    notificationModel = Provider.of<NotificationModel>(context, listen: false);
    messageModel = Provider.of<MessageModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
    //chalanModel = Provider.of<ChalanModel>(context, listen: false);
    userPartyModel = Provider.of<UserPartyModel>(context, listen: false);

    getUserSession();
    // getUserParty(false);
    /*  WidgetsBinding.instance.addPostFrameCallback((_) {

    });*/
  }

  Future<void> getUserSession() async {
    uid = await userModel.getUserId();
    login_type = await userModel.getUserType();
    financialYear =await  Share().currentFinancialYear();
    print("uid====${uid}==login_type==${login_type}");
    getAllNotificationList(true,"");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title:  IsClickSearch
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
        ) :Text("Notification List",
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
              ? Container()
              : IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              getAllNotificationList(true,"");
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
                  stream: refreshAllNotificationList.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: notificationModel.getList().length,
                          itemBuilder: (context, index) {
                            /*return NotificationLayout(notificationModelParam:notificationModel.getList()[index],index: index,onAcceptClick: onAcceptClick,onDetailClick: onDetailClick,);*/
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Row(
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
                                                            letterSpacing:
                                                                0.2)),
                                                    Text(
                                                        notificationModel
                                                            .getList()[index]
                                                            .notification_Added_on,
                                                        style: TextStyle(
                                                            fontFamily: 'Libre',
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: SizeConfig
                                                                    .safeBlockHorizontal *
                                                                3.0,
                                                            color: black,
                                                            letterSpacing:
                                                                0.2)),
                                                  ],
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("From : ",
                                                style: TextStyle(
                                                    fontFamily: 'Libre',
                                                    //  fontWeight: FontWeight.bold,
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        3.5,
                                                    color: black,
                                                    letterSpacing: 0.2)),
                                            Text(
                                                notificationModel
                                                    .getList()[index]
                                                    .admin_og_name,
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
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text("Notification : ",
                                                  style: TextStyle(
                                                      fontFamily: 'Libre',
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          3.5,
                                                      color: black,
                                                      letterSpacing: 0.2)),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Text(
                                                  notificationModel
                                                      .getList()[index]
                                                      .notification_description,
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
                                          ],
                                        ),
                                        Divider(),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.end,
                                         children: [
                                           RaisedButton(
                                             color: hhhh,
                                             shape: RoundedRectangleBorder(
                                                 borderRadius:
                                                 BorderRadius.circular(20.0)),
                                             onPressed: () {

                                               getNotificationDetail(notificationModel.getList()[index].notification_id,index);
                                             },
                                             child: Text(
                                               "Detail",
                                               style:
                                               TextStyle(color: Colors.white),
                                             ),
                                           ),
                                          SizedBox(width: 10,),
                                           notificationModel.getList()[index].notification_type=="SendChalan" ? RaisedButton(
                                             color: green,
                                             shape: RoundedRectangleBorder(
                                                 borderRadius:
                                                 BorderRadius.circular(20.0)),
                                             onPressed: () {
                                               notificationAccept(notificationModel.getList()[index].notification_id);


                                             },
                                             child: Text(
                                               "Accept",
                                               style:
                                               TextStyle(color: Colors.white),
                                             ),
                                           ):Container(),
                                           SizedBox(width: 10,),
                                           notificationModel.getList()[index].notification_type=="SendChalan" ? RaisedButton(
                                             color: mErrorColor,
                                             shape: RoundedRectangleBorder(
                                                 borderRadius:
                                                 BorderRadius.circular(20.0)),
                                             onPressed: () {

                                               notificationReject(notificationModel.getList()[index].notification_id);
                                             },
                                             child: Text(
                                               "Reject",
                                               style:
                                               TextStyle(color: Colors.white),
                                             ),
                                           ):Container()
                                         ],
                                       )
                                      ],
                                    ),
                                  )),
                            );
                          });
                    } else {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 100),
                          child: Text(message,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),),
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

  /* viewChalanDetail() {
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
                                itemCount: notificationModel.getList().length,
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
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text("Date : ",style: TextStyle(
                                                    fontFamily: 'Libre',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                    color: black,
                                                    letterSpacing: 0.2)),
                                                Text( notificationModel
                                                    .getLotDetailList()[index].chalan_log_Added_on,style: TextStyle(
                                                    fontFamily: 'Libre',
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: SizeConfig.safeBlockHorizontal * 3.0,
                                                    color: black,
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
                                                Text( notificationModel
                                                    .getLotDetailList()[index].lot_no,style: TextStyle(
                                                    fontFamily: 'Libre',
                                                    fontWeight: FontWeight.bold,
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
                                                Text( notificationModel
                                                    .getLotDetailList()[index].chalan_no,style: TextStyle(
                                                    fontFamily: 'Libre',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: SizeConfig.safeBlockHorizontal * 3.5,
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
                                                      notificationModel
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
                                                      notificationModel
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
                                                          notificationModel
                                                              .getLotDetailList()[index]
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
  }*/

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

  Future<void> getAllNotificationList(bool status,String search) async {
    message="";
    Map<String, dynamic> param = {
      "searchField":search,
      "session_admin_id": uid,
      "sessionYear": financialYear,
      "page": page.toString(),
      "api_name": "viewAllNotificationProcess",
    };
    // print(param);

    bool Isload = await notificationModel.fetchList(
        context, param, scaffoldState, status, false);
    if (Isload) {
      refreshAllNotificationList.add({});
    }
    else
      {
        message="No Data Found !";
      }
    print("message====${message}");
    setState(() {

    });
  }


  void _onChange(String value) {
    if (value.isNotEmpty) {
      if (value.length > 0) {
        getAllNotificationList(true,value);
      }
    }
  }

  Future<void> getNotificationDetail(String notification_id,int index) async {
    Map<String, dynamic> map = new Map();
    map['notification_id'] = notification_id;
    map['session_admin_id'] = uid.toString();
    map['btn_type'] = "notification_detail";
    map['api_name'] = "showNotificationDetailProcess";
    MessageModelParam data = await messageModel
        .add_post(context, map, scaffoldState, true, true)
        .then((value) {
      if (value.status) {
        viewDetail(index);
      }
    });
    setState(() {

    });
  }

  viewDetail(int index) {

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

                                                fontSize: SizeConfig
                                                    .safeBlockHorizontal *
                                                    3.5,
                                                color: black,
                                                letterSpacing: 0.2)),
                                        Text(
                                            messageModel
                                                .getNotificationDetailList()[
                                            0]
                                                .date,
                                            style: TextStyle(
                                                fontFamily: 'Libre',
                                                fontWeight: FontWeight.bold,
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
                                                  .getNotificationDetailList()[
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
                                                  .getNotificationDetailList()[
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
                                            // fontWeight: FontWeight.bold,
                                            fontSize: SizeConfig
                                                .safeBlockHorizontal *
                                                3.5,
                                            color: black,
                                            letterSpacing: 0.2)),
                                    Text(
                                        messageModel
                                            .getNotificationDetailList()[0]
                                            .product,
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
                                  MainAxisAlignment.start,
                                  children: [
                                    Text("Sub Product : ",
                                        style: TextStyle(
                                            fontFamily: 'Libre',
                                            //  fontWeight: FontWeight.bold,
                                            fontSize: SizeConfig
                                                .safeBlockHorizontal *
                                                3.5,
                                            color: black,
                                            letterSpacing: 0.2)),
                                    Text(
                                        messageModel
                                            .getNotificationDetailList()[0]
                                            .subproduct,
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
                                  MainAxisAlignment.start,
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
                                        messageModel
                                            .getNotificationDetailList()[0]
                                            .dNo,
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
                                  MainAxisAlignment.start,
                                  children: [
                                    Text("Pieces : ",
                                        style: TextStyle(
                                            fontFamily: 'Libre',
                                            // fontWeight: FontWeight.bold,
                                            fontSize: SizeConfig
                                                .safeBlockHorizontal *
                                                3.5,
                                            color: black,
                                            letterSpacing: 0.2)),
                                    Text(
                                        messageModel
                                            .getNotificationDetailList()[0]
                                            .pcs,
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
                                  MainAxisAlignment.start,
                                  children: [
                                    Text("Sent By : ",
                                        style: TextStyle(
                                            fontFamily: 'Libre',
                                            // fontWeight: FontWeight.bold,
                                            fontSize: SizeConfig
                                                .safeBlockHorizontal *
                                                3.5,
                                            color: black,
                                            letterSpacing: 0.2)),
                                    Text(
                                        messageModel
                                            .getNotificationDetailList()[0]
                                            .sentby,
                                        style: TextStyle(
                                            fontFamily: 'Libre',
                                            fontWeight: FontWeight.bold,
                                            fontSize: SizeConfig
                                                .safeBlockHorizontal *
                                                3.5,
                                            color: logocolor,
                                            letterSpacing: 0.2)),
                                  ],
                                )
                              ],
                            ),
                          )),

                      notificationModel.getList()[index].notification_type=="SendChalan" ?Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          RaisedButton(
                            color: green,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20.0)),
                            onPressed: () {
                              Navigator.pop(context);
                              notificationAccept(notificationModel.getList()[index].notification_id);
                            },
                            child: Text(
                              "Accept",
                              style:
                              TextStyle(color: Colors.white),
                            ),
                          ),
                          RaisedButton(
                            color: mErrorColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20.0)),
                            onPressed: () {
                              Navigator.pop(context);
                              notificationReject(notificationModel.getList()[index].notification_id);
                            },
                            child: Text(
                              "Reject",
                              style:
                              TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ):Container(),
                      SizedBox(height: 10,)
                    ],
                  );
                }),
          );
        });
  }


  Future<void> notificationAccept(String notification_id) async {
    Map<String, dynamic> map = new Map();
    map['notification_id'] = notification_id;
    map['session_admin_id'] = uid.toString();
    map['btn_type'] = "notification_accept";
    map['api_name'] = "acceptNotificationProcess";
    MessageModelParam data = await messageModel
        .add_post(context, map, scaffoldState, true, true)
        .then((value) {
      if (value.status) {

       // Share().show_Dialog(context, value.message, "Notification", value.status);
        if(value.status)
        {
          Get.to(UserChalanList(
            title: "Pending",
          ));
        }
        getAllNotificationList(false,"");
      }
    });

  }

  Future<void> notificationReject(String notification_id) async {
    Map<String, dynamic> map = new Map();
    map['notification_id'] = notification_id;
    map['session_admin_id'] = uid.toString();
    //map['btn_type'] = "notification_accept";
    map['api_name'] = "rejectLotRequestProcess";
    MessageModelParam data = await messageModel
        .add_post(context, map, scaffoldState, true, true)
        .then((value) {
      if (value.status) {
        Share().show_Dialog(context, value.message, "Notification", value.status);
        getAllNotificationList(false,"");
      }
    });

  }

  onAcceptClick(data) {

  }
  onDetailClick(data) {
      print("data==${data}");
      getNotificationDetail(data["notification_id"],data["index"]);
  }
}
