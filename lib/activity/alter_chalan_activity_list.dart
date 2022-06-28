import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/alter_chalan_model.dart';
import 'package:fepic_stock/model/financialYearModal.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

class AlterChalanList extends StatefulWidget {
  @override
  _AlterChalanListState createState() => _AlterChalanListState();
}

class _AlterChalanListState extends State<AlterChalanList> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

  //final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey = GlobalKey<LiquidPullToRefreshState>();
  AlterChalanModel alterChalanModel;
  UserModel userModel;
 // ChalanModel chalanModel;

  String message = "";
  int page = 1;
  String datastatus = "";
  var uid;
  var login_type;
  String financialYear;

  @override
  void initState() {
    alterChalanModel = AlterChalanModel();
    // userTypeModel = Provider.of<UserTypeModel>(context, listen: false);
    alterChalanModel = Provider.of<AlterChalanModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
    //chalanModel = Provider.of<ChalanModel>(context, listen: false);
    getUserSession();
  }

  Future<void> getUserSession() async {
    uid = await userModel.getUserId();
    login_type = await userModel.getUserType();
    financialYear =await  Share().currentFinancialYear();
    print("uid====${uid}==login_type==${login_type}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAlterChalan(datastatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: Text("Alter Chalan List",
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
              return {'All', 'New', 'Pending', 'Complete'}.map((String choice) {
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
                  stream: alterChalanModel.getAllAlterChalan,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.length > 0) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            String status = snapshot.data[index]
                                .Alter_chalan_master_status;
                            if (status == "DoneComplete") {
                              status = "Complete";
                            }
                            else if (status.toLowerCase() == "pending") {
                              status = "Pending";
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
                                          colors: [
                                            white,white
                                          ],
                                          begin: const FractionalOffset(
                                              0.0, 0.0),
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
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                                3.5,
                                                            color: black,
                                                            letterSpacing: 0.2)),
                                                    Text(snapshot.data[index]
                                                        .Alter_chalan_master_Added_on,
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
                                            )
                                          ],
                                        ),
                                        // Divider(color: Colors.black,),

                                        Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(),),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .end,
                                                  children: [
                                                    Text("Chalan No : ",
                                                        style: TextStyle(
                                                            fontFamily: 'Libre',
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                                3.5,
                                                            color: logocolor2,
                                                            letterSpacing: 0.2)),
                                                    Text(snapshot.data[index]
                                                        .Alter_chalan_master_chalan_no,
                                                        style: TextStyle(
                                                            fontFamily: 'Libre',
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                                3.5,
                                                            color: logocolor2,
                                                            letterSpacing: 0.2)),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                        Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(),),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .end,
                                                  children: [
                                                    Text("Lot No : ",
                                                        style: TextStyle(
                                                            fontFamily: 'Libre',
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                                3.5,
                                                            color: black,
                                                            letterSpacing: 0.2)),
                                                    Text(snapshot.data[index]
                                                        .Alter_chalan_master_lot_no,
                                                        style: TextStyle(
                                                            fontFamily: 'Libre',
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                                3.5,
                                                            color: black,
                                                            letterSpacing: 0.2)),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                        Divider(),
                                        Row(
                                          children: [
                                            Text("Party Name : ",
                                                style: TextStyle(
                                                    fontFamily: 'Libre',
                                                    //  fontWeight: FontWeight.bold,
                                                    fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                        3.5,
                                                    color: black,
                                                    letterSpacing: 0.2)),
                                            Text(
                                                snapshot.data[index].admin_name,
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
                                          children: [
                                            Text(
                                                "Quantity : ", style: TextStyle(
                                                fontFamily: 'Libre',
                                                // fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig
                                                    .safeBlockHorizontal * 3.5,
                                                color: black,
                                                letterSpacing: 0.2)),
                                            Text(snapshot.data[index]
                                                .Alter_chalan_master_qty,
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
                                          children: [
                                            Text("Complete Quantity : ",
                                                style: TextStyle(
                                                    fontFamily: 'Libre',
                                                    //  fontWeight: FontWeight.bold,
                                                    fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                        3.5,
                                                    color: black,
                                                    letterSpacing: 0.2)),
                                            Text(snapshot.data[index]
                                                .Alter_chalan_master_complete_qty,
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
                                          children: [
                                            Text("Status : ", style: TextStyle(
                                                fontFamily: 'Libre',
                                                //fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig
                                                    .safeBlockHorizontal * 4.2,
                                                color: black,
                                                letterSpacing: 0.2)),
                                            Text(status, style: TextStyle(
                                                fontFamily: 'Libre',
                                                fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig
                                                    .safeBlockHorizontal * 3.0,
                                                color: status == "Complete"
                                                    ? Colors.green
                                                    : status == "Pending"
                                                    ? Colors.deepOrange
                                                    : logocolor,
                                                letterSpacing: 0.2)),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 100),
                          child: Text(message,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
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
      case 'All':
        datastatus = "";
        getAlterChalan(datastatus);
        break;
      case 'New':
        datastatus = "New";
        getAlterChalan(datastatus);
        break;
      case 'Pending':
        datastatus = "Pending";
        getAlterChalan(datastatus);
        break;
      case 'Complete':
        datastatus = "Completed";
        getAlterChalan(datastatus);
        break;
    }
  }

  Future<void> getAlterChalan(String id) async {
    message="";
    print("alter");

    Map<String,dynamic> map=new Map();
    map['session_admin_id']=uid;
    map['session_admin_login_type']=login_type;
    map['alterListFilterType']=id;
    map['sessionYear']=financialYear;
    map['page']=page.toString();
    map['api_name']="viewAllAlter";

    print(map);
    bool IsData = await alterChalanModel.fetchList(context, map, scaffoldState, true, false);

    if (!IsData) {
      message = "No Data Found !";
    }
    print("alter===${IsData}");
    setState(() {});
  }

}
