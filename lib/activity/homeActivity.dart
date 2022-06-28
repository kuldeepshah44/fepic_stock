import 'dart:async';
import 'dart:io';

import 'package:fepic_stock/activity/new_chalan.dart';
import 'package:fepic_stock/activity/remark_list_activity.dart';
import 'package:fepic_stock/activity/user_screen/new_list_activity.dart';
import 'package:fepic_stock/activity/user_screen/user_chalan_list.dart';
import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/financialYearModal.dart';
import 'package:fepic_stock/model/notification_model.dart';
import 'package:fepic_stock/model/party_model.dart';
import 'package:fepic_stock/utility/api.dart';
import 'package:fepic_stock/utility/color_override.dart';
import 'package:fepic_stock/utility/pushnotification.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:get/get.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'alter_chalan_activity_list.dart';
import 'new_reprocess_chalan.dart';

class HomeActivity extends StatefulWidget {
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  List<Map<String, dynamic>> financialyearselect = [];
  List selectfinancialyear;

  List<String> adminList = ["New", "Reprocess", "Alter", "Remark"];
  List<String> adminListLable = [
    "Generate New",
    "Reprocess",
    "Alter List",
    "Remark List"
  ];
  List<String> userList = [
    "New",
    "Pending",
    "Running",
    "Done",
    "Alter",
    "Remark"
  ];
  List<String> userListLabel = [
    "New List",
    "Pending List",
    "Running List",
    "Done",
    "List Alter",
    "List Remark"
  ];

  List<String> mainList = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // List<String> userList = ["New", "Reprocess", "Alter", "Remark"];
  PartyModel partyModel;
  UserModel userModel;
  ChalanModel chalanModel;
  ChalanModelParam selectFinancialYearList;
  String selectedYear = "Select Financial Year";

  //ChalanModel chalanModel;
  var uid;
  var login_type;
  String financial_year = "";
  String username = "";

  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;
  NotificationModel notificationModel;

  @override
  void initState() {
    super.initState();
    selectfinancialyear = [];
    notificationModel = Provider.of<NotificationModel>(context, listen: false);
    partyModel = Provider.of<PartyModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);

    chalanModel = Provider.of<ChalanModel>(context, listen: false);
    //chalanModel = Provider.of<ChalanModel>(context, listen: false);

    getUserSession();

    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {});
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    //subcatlogs();
  }

  Future<void> getUserSession() async {
    uid = await userModel.getUserId();
    login_type = await userModel.getUserType();
    username = await userModel.getPartyName();
    financial_year = await Share().currentFinancialYear();
    selectedYear = financial_year;
    print("currentFinancialYear==home==${financial_year}");
    List abcd = selectedYear.split(",").toList();
    print("currentFinancialYear==home==${abcd.toString()}");
    selectfinancialyear = abcd;
    mainList = login_type == "1" ? adminList : userList;

//String dd=await  Share().currentFinancialYear();

    setState(() {});
    print("uid====${uid}==login_type==${financial_year}");
    PushNotification(context: context).getPushNotification(
        false, scaffoldKey, notificationModel, uid, financial_year);
    setState(() {});
    Share()
        .getAllNewUserNotificationList(
        context,
        scaffoldKey,
        notificationModel,
        uid.toString(),
        financial_year,
        false,
        1)
        .then((value) {
      setState(() {});
    });
    saveDeviceToken();
  }

  saveDeviceToken() async {
    String deviceId = await Share().getDeviceId();
    var filter = new Map<String, dynamic>();
    String fcmToken = await _fcm.getToken();
    print("token : " + fcmToken);
    filter['uid'] = uid.toString();
    filter['token'] = fcmToken.toString();
    filter['deviceId'] = deviceId.toString();
    filter['type'] = "token";

    if (fcmToken != null) {
      Map<String, String> headers = {
        "content-type": "application/x-www-form-urlencoded; charset=utf-8"
      };
      headers['content-type'] =
      'application/x-www-form-urlencoded; charset=utf-8';
      final response = await http.post(
        Uri.parse(send_post_data1),
        headers: headers,
        body: filter,
      );
    }
  }

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: background,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  // margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    /* image: DecorationImage(
                         image: AssetImage('assets/images/one.jpg'),
                         fit: BoxFit.cover
                     )*/
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient:
                        LinearGradient(begin: Alignment.bottomRight, colors: [
                          Colors.black.withOpacity(.4),
                          Colors.black.withOpacity(.2),
                        ])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Team Fepic",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          // margin: EdgeInsets.symmetric(horizontal: 40),

                          child: Center(
                              child: Text(
                                "Financial Year : " + financial_year,
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold),
                              )),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    child: Text("User : ${username}",style: TextStyle(color: kShrineBrown900,fontWeight: FontWeight.bold,fontSize: 16,),),
                  ),
                )
              ],
            ),

            SizedBox(
              height: 10,
            ),

            StreamBuilder(
                stream: chalanModel.getAllFinancialYear,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Column(
                      children: [
                        Align(
                            alignment:Alignment.topLeft,
                            child: Text("Financial Year")),
                        Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Expanded(
                              child: Center(
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  child:
                                  CircularProgressIndicator(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  financialyearselect = [];

                  chalanModel.getList().forEach((element) {
                    financialyearselect.add({
                      "display": element.chalan_financial_year,
                      "value": element.chalan_financial_year
                    });
                  });

                  return MultiSelectFormField(
                    autovalidate: false,
                    chipBackGroundColor: Colors.red,
                    chipLabelStyle:
                    TextStyle(fontWeight: FontWeight.bold),
                    dialogTextStyle:
                    TextStyle(fontWeight: FontWeight.bold),
                    checkBoxActiveColor: Colors.red,
                    checkBoxCheckColor: Colors.green,
                    dialogShapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(12.0))),
                    title: Text(
                      "Financial Year",
                      style: TextStyle(fontSize: 16),
                    ),
                    dataSource: financialyearselect,
                    textField: 'display',
                    valueField: 'display',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    hintWidget: Text('Please select Year'),
                    initialValue: selectfinancialyear,
                    onSaved: (value) {
                      //  if (value == null) return;
                      setState(() {
                        selectfinancialyear = value;
                        print(
                            "fincial year======${value}");
                        if (selectfinancialyear.length > 0 &&
                            selectfinancialyear != null) {
                          selectedYear =
                              selectfinancialyear.join(',');
                          print(
                              "fincial year======${selectedYear}");

                          setData(selectedYear);
                        }
                        else {
                          Share().show_Dialog(
                              context, "Please select atleast one financial year",
                              "Financial Year", false);
                        }
                      });
                    },
                  );
                }),
            /*PrimaryColorOverride(
              child: MultiSelectFormField(
                autovalidate: false,
                chipBackGroundColor: Colors.red,
                chipLabelStyle:
                TextStyle(fontWeight: FontWeight.bold),
                dialogTextStyle:
                TextStyle(fontWeight: FontWeight.bold),
                checkBoxActiveColor: Colors.red,
                checkBoxCheckColor: Colors.green,
                dialogShapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(12.0))),
                title: Text(
                  "Financial Year",
                  style: TextStyle(fontSize: 16),
                ),
                dataSource: financialyearselect,
                textField: 'display',
                valueField: 'display',
                okButtonLabel: 'OK',
                cancelButtonLabel: 'CANCEL',
                hintWidget: Text('Please select Year'),
                initialValue: selectfinancialyear,
                onSaved: (value) {
                  //  if (value == null) return;
                  setState(() {
                    selectfinancialyear = value;
                    print(
                        "fincial year======${value}");
                    if (selectfinancialyear.length > 0 &&
                        selectfinancialyear != null) {
                      selectedYear =
                          selectfinancialyear.join(',');
                      print(
                          "fincial year======${selectedYear}");

                      setData(selectedYear);
                    }
                    else {
                      Share().show_Dialog(
                          context, "Please select atleast one financial year",
                          "Financial Year", false);
                    }
                  });
                },
              ),
            ),*/
            SizedBox(
              height: 20,
            ),
            main(),
          ],
        ),
      ),
    );
  }

  Widget body() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: buildLisOfBlocks(),
    );
  }

  List<Widget> buildLisOfBlocks() {

  }

  Widget financialYearDropDownList() {
    return StreamBuilder(
      stream: chalanModel.getAllFinancialYear,
      builder: (context, snapshot) {
        /*   if (snapshot.hasData && snapshot.data[0].chalan_id != "-1") {
          (snapshot.data as List<ChalanModelParam>).insert(
              0,
              ChalanModelParam(
                  chalan_id: "-1",
                  chalan_financial_year: "Select Financial Year"));
        }*/
        if (snapshot.hasData) {
          return Container(
            width: MediaQuery
                .of(context)
                .size
                .width / 2,
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
                child: DropdownButton<ChalanModelParam>(
                  value: selectFinancialYearList != null
                      ? selectFinancialYearList
                      : snapshot.data[0],
                  hint: Text("Select Product"),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Theme
                        .of(context)
                        .dividerColor,
                  ),
                  onChanged: (ChalanModelParam newValue) {
                    setState(() {
                      selectFinancialYearList = newValue;
                      print(newValue);
                      selectedYear = newValue.chalan_financial_year;
                      setData(selectedYear);
                    });
                  },
                  items: snapshot.data
                      .map<DropdownMenuItem<ChalanModelParam>>((value) {
                    // print("kya aayya ${value.label.toString()}");
                    return DropdownMenuItem<ChalanModelParam>(
                      value: value,
                      child: Text(value.chalan_financial_year),
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

  Widget main() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: List.generate(mainList.length, (index) {
          return Card(
            color: Colors.transparent,
            elevation: 0,
            child: GestureDetector(
              onTap: () {
                if (login_type == "1") {
                  if (index == 0) {
                    Get.to(NewChalan());
                  } else if (index == 1) {
                    Get.to(NewReprocessChalan());
                  } else if (index == 2) {
                    Get.to(AlterChalanList());
                  } else if (index == 3) {
                    Get.to(RemarkListActivity());
                  }
                } else {
                  if (index == 0) {
                    Get.to(NewUserListActivity());
                  } else if (index == 1) {
                    Get.to(UserChalanList(
                      title: "Pending",
                    ));
                  } else if (index == 2) {
                    Get.to(UserChalanList(
                      title: "Running",
                    ));
                  } else if (index == 3) {
                    Get.to(UserChalanList(
                      title: "Done",
                    ));
                  } else if (index == 4) {
                    Get.to(AlterChalanList());
                  } else if (index == 5) {
                    Get.to(RemarkListActivity());
                  }
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [white, white],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                    //  shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(30.0))
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Center(
                    child: Text(mainList[index],
                        style: TextStyle(
                            color: black, fontWeight: FontWeight.bold)),
                  )),
            ),
          );
        }),
      ),
      /*  child: StreamBuilder(
      stream: partyModel.GetAllParty,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: List.generate(snapshot.data.length, (index) {
              return Card(
                color: Colors.transparent,
                elevation: 0,
                child: Container(
                    // margin: EdgeInsets.only(left: 20,right: 20),
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
                    child: Center(
                      child: Text(snapshot.data[index].admin_name,
                          style: TextStyle(
                              color: black, fontWeight: FontWeight.bold)),
                    )
                    ),
              );
            }),
          );
        } else {
          return Center(
              child: Container(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(),
          ));
        }
      },
    )*/
    );
  }

  Future<void> setData(String selectedYear) async {
    await Share().setCurrentYear(selectedYear);
    financial_year = await Share().currentFinancialYear();
  }
}
