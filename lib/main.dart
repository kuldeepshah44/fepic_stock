import 'package:fepic_stock/activity/login.dart';
import 'package:fepic_stock/model/chalan_model.dart';
import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/notification_model.dart';
import 'package:fepic_stock/model/order_model.dart';
import 'package:fepic_stock/model/party_model.dart';
import 'package:fepic_stock/model/user_chalan_model.dart';
import 'package:fepic_stock/model/user_party_model.dart';
import 'package:fepic_stock/utility/get_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/sub_category_model.dart';
import 'package:fepic_stock/screen/homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/alter_chalan_model.dart';
import 'model/chalan_detail_model.dart';
import 'model/chat_remark_model.dart';
import 'model/color_model.dart';
import 'model/financialYearModal.dart';
import 'model/lot_model.dart';
import 'model/product_model.dart';
import 'model/remark_model.dart';
import 'model/stock_model.dart';
import 'model/sub_product_model.dart';
import 'model/user_type.dart';
import 'model/year_model.dart';

void main() {
  YearModel _yearModel = YearModel();
  SubCategoryModel _subCategoryModel = SubCategoryModel();
  ColorModel _colorModel = ColorModel();
  UserModel _userModel = UserModel();
  PartyModel _partyModel = PartyModel();
  ProductModel _productModel = ProductModel();
  SubProductModel _subProductModel = SubProductModel();
  UserTypeModel _userTypeModel = UserTypeModel();
  ChalanModel _financialYearModel = ChalanModel();
  AlterChalanModel _alterChalanModel = AlterChalanModel();
  MessageModel _messageModel = MessageModel();
  RemarkModel  _remarkModel= RemarkModel();
  UserPartyModel  _userPartyModel= UserPartyModel();
  StockModel  _stockModel= StockModel();
  ChalanDetailModel  _chalanDetailModel= ChalanDetailModel();
  ChatRemarkModel  _chatRemarkModel= ChatRemarkModel();
  LotModel  _lotModel= LotModel();
  NotificationModel  _notification= NotificationModel();
  UserChalanModel  _userChalanModel= UserChalanModel();
  ChalanListModel  _chalanListModel= ChalanListModel();
  OrderModel  _orderModel= OrderModel();

  GetResponse getResponse = GetResponse();
  runApp(new MultiProvider(
      providers: [
        ChangeNotifierProvider<SubCategoryModel>.value(
            value: _subCategoryModel),
        ChangeNotifierProvider<YearModel>.value(value: _yearModel),
        ChangeNotifierProvider<UserModel>.value(value: _userModel),
        ChangeNotifierProvider<ColorModel>.value(value: _colorModel),
        ChangeNotifierProvider<PartyModel>.value(value: _partyModel),
        ChangeNotifierProvider<ProductModel>.value(value: _productModel),
        ChangeNotifierProvider<SubProductModel>.value(value: _subProductModel),
        ChangeNotifierProvider<UserTypeModel>.value(value: _userTypeModel),
        ChangeNotifierProvider<ChalanModel>.value(value: _financialYearModel),
        ChangeNotifierProvider<MessageModel>.value(value: _messageModel),
        ChangeNotifierProvider<AlterChalanModel>.value(value: _alterChalanModel),
        ChangeNotifierProvider<RemarkModel>.value(value: _remarkModel),
        ChangeNotifierProvider<UserPartyModel>.value(value: _userPartyModel),
        ChangeNotifierProvider<StockModel>.value(value: _stockModel),
        ChangeNotifierProvider<ChalanDetailModel>.value(value: _chalanDetailModel),
        ChangeNotifierProvider<ChatRemarkModel>.value(value: _chatRemarkModel),
        ChangeNotifierProvider<LotModel>.value(value: _lotModel),
        ChangeNotifierProvider<NotificationModel>.value(value: _notification),
        ChangeNotifierProvider<UserChalanModel>.value(value: _userChalanModel),
        ChangeNotifierProvider<ChalanListModel>.value(value: _chalanListModel),
        ChangeNotifierProvider<OrderModel>.value(value: _orderModel),
      ],
      child: GetMatrialApp(
          builder: (context, child) {
            //print("ashish");
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child);
          },
          home: MyApp(
            getResponse: getResponse,
          ),
          debugShowCheckedModeBanner: false)));
}

class MyApp extends StatelessWidget {
  GetResponse getResponse;

  MyApp({Key key, this.getResponse})
      : super(
          key: key,
        );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        getResponse: getResponse,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  GetResponse getResponse;

  MyHomePage({Key key, this.getResponse}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

YearModel yearModel;
  ChalanModel financialYearModel;
  UserModel userModel;
  SharedPreferences prefs;
  bool IsLogin=false;
  var uid;
  //GetResponse getResponse;
  @override
  void initState() {
    super.initState();

    yearModel = Provider.of<YearModel>(context, listen: false);
    financialYearModel = Provider.of<ChalanModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
    getUser();
    // widget.getResponse.fetchPartyList();
    // subcatlogs();
    getYear();
    getFinancialYear();

    Future.delayed(Duration(seconds: 2)).whenComplete(() {
      if (!IsLogin) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            LoginForm()), (Route<dynamic> route) => false);
      }
      else {
        //bool IsLogin=userModel.IsLogin() as bool;
        // print("Is Login==${IsLogin}");
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }), (route) => false);
      }
    }
    );

    _animationController =
        AnimationController(duration: const Duration(seconds: 4), vsync: this)
          ..repeat(reverse: true);
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn);
  }

  void getUser()
  async {
    IsLogin=await userModel.IsLogin();
    if(IsLogin==null)
      {
        IsLogin=false;
        uid="0";
      }
    else
      {
        uid= await userModel.getUserId();
      }
    print("IsLogin==${IsLogin}");
    print("uid==${uid}");

  }

  @override
  void dispose() {
    // _sub?.cancel();
    _animationController.dispose();
    super.dispose();
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

  Future<void> getYear() async {
    print("fetchListFinancialYearProcess");
    Map<String,dynamic> param=new Map();
    param['api_name']="fetchListFinancialYearProcess";
    bool isload = await yearModel.fetchYear(context, param, scaffoldKey, false, false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: Image.asset(
                  "images/logo.png",
                  width: MediaQuery.of(context).size.width / 2 + 50,
                  height: MediaQuery.of(context).size.width / 2 + 50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
