import 'dart:async';
import 'dart:io';

import 'package:fepic_stock/activity/login.dart';
import 'package:fepic_stock/activity/master/notification_activity.dart';
import 'package:fepic_stock/activity/user_screen/new_list_activity.dart';
import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/financialYearModal.dart';
import 'package:fepic_stock/model/notification_model.dart';
import 'package:fepic_stock/model/party_model.dart';
import 'package:fepic_stock/model/product_model.dart';
import 'package:fepic_stock/model/user_type.dart';
import 'package:fepic_stock/utility/pushnotification.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fepic_stock/activity/cartActivity.dart';
import 'package:fepic_stock/activity/categoryActivity.dart';
import 'package:fepic_stock/activity/homeActivity.dart';
import 'package:fepic_stock/activity/profileActivity.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/widget/bootomBar.dart';
import 'package:fepic_stock/widget/widget.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:fepic_stock/model/sub_category_model.dart';
import 'package:fepic_stock/utility/config.dart';

import 'commonWidget/commonWidget.dart';
import 'drawerScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UserModel userModel;
  //ChalanModel chalanModel;
  var uid;
  var login_type;
  String username = "";
  String financialYear;
  NotificationModel notificationModel;

  SubCategoryModel subCategoryModel;
  PartyModel partyModel;
  ProductModel productModel;
  UserTypeModel userTypeModel;
  ChalanModel financialYearModel;

  @override
  void initState() {
    super.initState();
    //_subCategoryModel=Provider.of<SubCategoryModel>(context,listen: false);
    userModel = new UserModel();
    userModel = Provider.of<UserModel>(context, listen: false);
    notificationModel = Provider.of<NotificationModel>(context, listen: false);
    //chalanModel = Provider.of<ChalanModel>(context, listen: false);

    subCategoryModel = Provider.of<SubCategoryModel>(context, listen: false);
    partyModel = Provider.of<PartyModel>(context, listen: false);
    productModel = Provider.of<ProductModel>(context, listen: false);
    userTypeModel = Provider.of<UserTypeModel>(context, listen: false);
    financialYearModel = Provider.of<ChalanModel>(context, listen: false);
    //getFinancialYear();
    //PushNotification(context: context).getPushNotification(true);
    getUserSession();

    getProduct();
    getUserType();

    //subcatlogs();
  }

  Future<void> getUserSession() async {
    uid = await userModel.getUserId();
    login_type = await userModel.getUserType();
    username = await userModel.getPartyName();
    financialYear =await  Share().currentFinancialYear();
    print("uid==home==${uid}==login_type==${login_type}");
    setState(() {});
    PushNotification(context: context).getPushNotification(
        false, scaffoldKey, notificationModel, uid, financialYear);

    getParty();
  }

  Future<void> subcatlogs() async {
    Map<String, dynamic> param = {"flevel": "0", "cid": "", "p": "1"};
    subCategoryModel.fatchSubCategory(context, param, false);
  }

  Future<void> getParty() async {
    print("dg");
    Map<String, dynamic> param = {
      "type": "user",
      "party_name": username,
    };
    bool isload = await partyModel.fetchPartyList(
        context, param, scaffoldKey, false, false);
  }

  Future<void> getProduct() async {
    print("dg");
    Map<String, dynamic> param = {
      "type": "product",
    };
    bool isload =
        await productModel.fetchList(context, param, scaffoldKey, false, false);
  }

  Future<void> getUserType() async {
    print("user_type");
    Map<String, dynamic> param = {
      "type": "user_type",
    };
    bool isload = await userTypeModel.fetchList(
        context, param, scaffoldKey, false, false);
  }

  Future<void> getFinancialYear() async {
    print("get_year");
    Map<String, dynamic> param = {
      "type": "chalan",
      "value": "year",
    };
    bool isload = await financialYearModel.fetchList(
        context, param, scaffoldKey, false, false);
  }

  int _selectedIndex = 0;

  boombarTap(int tapIndex) {
    _selectedIndex = tapIndex;
    if (_selectedIndex == 3) {
      // Get.offAll(SignInPage());
    } else {
      if (scaffoldKey.currentState.isDrawerOpen) {
        scaffoldKey.currentState.openEndDrawer();
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        shadowColor: Colors.white,
        elevation: 0,
        title: Container(
            height: 45,
            child: Image.asset(
              "images/title.png",
              fit: BoxFit.contain,
            )),
        // title: _buildHeader(context, scaffoldKey),
        actions: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () async {
                  Get.to(NotificationMasterActivity());
                },
              ),
              Positioned(
                // draw a red marble
                top: 2,
                right: 2.0,
                child: InkWell(
                  onTap: () {
                  Get.to(NotificationMasterActivity());
                  },
                  child: StreamBuilder<int>(
                      stream: notificationModel.notificationCount,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != 0) {
                          print("data====${snapshot.data.toString()}");
                          return Card(
                              elevation: 0,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              color: Colors.redAccent,
                              child: Container(
                                  padding: EdgeInsets.all(2),
                                  constraints: BoxConstraints(minWidth: 20.0),
                                  child: Center(
                                      child: Text(
                                    snapshot.data.toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        backgroundColor: Colors.redAccent),
                                  ))));
                        } else
                          return Container();
                      }),
                ),
              )
            ],
          ),
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      /*bottomNavigationBar: BootomBar(
        ontap: boombarTap,
        activeIndex: _selectedIndex,

        //appModel: appModel,
      ),*/
      drawer: DrawerScreen(
        scfoldKey: scaffoldKey,
        ontap: boombarTap,
        uid: uid,
        login_type: login_type,
        username: username,
        current_year: financialYear,
      ),
      body: IndexedStack(
        children: [
          HomeActivity(),
          CategoryActivity(),
          CartActivity(),
          ProfileActivity(),
        ],
        index: _selectedIndex,
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':

        userModel.logOut();
        // Get.offAll(LoginForm());
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginForm()),
            (Route<dynamic> route) => false);

        break;
    }
  }

  Widget _buildHeader(
      BuildContext context, GlobalKey<ScaffoldState> scafoldkey) {
    return Container(
      // padding: EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            appname,
            style: TextStyle(
                fontFamily: 'Libre',
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.safeBlockHorizontal * 5.2,
                color: logocolor1,
                letterSpacing: 0.2),
          ),
          Text(
            appTag,
            style: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 3.2,
              color: logocolor2,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
              wordSpacing: 1,
              fontFamily: 'Allura',
            ),
          ),
        ],
      ),
    );
  }
}
