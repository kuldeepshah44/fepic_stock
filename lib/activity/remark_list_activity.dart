import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/alter_chalan_model.dart';
import 'package:fepic_stock/model/financialYearModal.dart';
import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/remark_model.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

class RemarkListActivity extends StatefulWidget {
  @override
  _RemarkListActivityState createState() => _RemarkListActivityState();
}

class _RemarkListActivityState extends State<RemarkListActivity> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  //final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey = GlobalKey<LiquidPullToRefreshState>();
  RemarkModel remarkModel;
//ChalanModel chalanModel;
  String message="";
  int page=1;
  String datastatus="";
  UserModel userModel;
  List<bool> isSelected=[];
  List<bool> IsComplete=[];


  var uid;
  var login_type;
  var financialYear;
MessageModel messageModel;
  @override
  void initState() {
    remarkModel = RemarkModel();
    userModel = UserModel();

    // userTypeModel = Provider.of<UserTypeModel>(context, listen: false);
    remarkModel = Provider.of<RemarkModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
   // chalanModel = Provider.of<ChalanModel>(context, listen: false);
    messageModel = Provider.of<MessageModel>(context, listen: false);
    getUserSession();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //getAlterChalan(datastatus);
    });
  }

  Future<void> getUserSession() async {
    uid = await userModel.getUserId();
    login_type = await userModel.getUserType();
    financialYear =await  Share().currentFinancialYear();
    print("uid====${uid}==login_type==${login_type}");
    getAlterChalan(datastatus);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: Text("Remark List",
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
              return {'All','Pending','Complete'}.map((String choice) {
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
                 // scrollOffset: 10,
                onEndOfPage: () {
                  page = page + 1;
                 // getAlterChalan(datastatus);
                },
                child: StreamBuilder(
                  stream: remarkModel.getAllRemark,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.length > 0) {


                      return ListView.builder(
                          shrinkWrap: true,
                         // physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            isSelected.add(false);
                            IsComplete.add(false);
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
                                                fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                color: black,
                                                letterSpacing: 0.2)),
                                            Text(snapshot.data[index].remark_Added_on,style: TextStyle(
                                                fontFamily: 'Libre',
                                                // fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig.safeBlockHorizontal * 3.0,
                                                color: black,
                                                letterSpacing: 0.2)),
                                          ],
                                        ),
                                        Row(
                                            children: [
                                              Expanded(
                                                flex:1,
                                                child: Container(),),
                                              Expanded(
                                                flex:1,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text("Chalan No : ",style: TextStyle(
                                                        fontFamily: 'Libre',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                        color: logocolor2,
                                                        letterSpacing: 0.2)),
                                                    Text(snapshot.data[index].chalan_no,style: TextStyle(
                                                        fontFamily: 'Libre',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                        color: logocolor2,
                                                        letterSpacing: 0.2)),
                                                  ],
                                                ),
                                              ),]),
                                        Row(
                                            children: [
                                              Expanded(
                                                flex:1,
                                                child: Container(),),
                                              Expanded(
                                                flex:1,
                                                child:  Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text("Lot No : ",style: TextStyle(
                                                        fontFamily: 'Libre',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                        color: black,
                                                        letterSpacing: 0.2)),
                                                    Text(snapshot.data[index].lot_no,style: TextStyle(
                                                        fontFamily: 'Libre',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                        color: black,
                                                        letterSpacing: 0.2)),
                                                  ],
                                                ),
                                              ),]),
                                        Divider(),
                                        Row(
                                          children: [
                                            Text("Design No : ",style: TextStyle(
                                                fontFamily: 'Libre',
                                                fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                color: black,
                                                letterSpacing: 0.2)),
                                            Text(snapshot.data[index].product_design_no,style: TextStyle(
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
                                            Text(snapshot.data[index].admin_og_name,style: TextStyle(
                                                fontFamily: 'Libre',
                                                //fontWeight: FontWeight.bold,
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
                                            Text(snapshot.data[index].chalan_financial_year,style: TextStyle(
                                                fontFamily: 'Libre',
                                                // fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                color: black,
                                                letterSpacing: 0.2)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Send By : ",style: TextStyle(
                                                fontFamily: 'Libre',
                                                fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                color: black,
                                                letterSpacing: 0.2)),
                                            Text(snapshot.data[index].admin_og_name,style: TextStyle(
                                                fontFamily: 'Libre',
                                                // fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                color: black,
                                                letterSpacing: 0.2)),
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [

                                            Expanded(
                                              flex:1,
                                              child: Text("Remark : ",style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.0,
                                                  color: kShrineBrown600,
                                                  letterSpacing: 0.2)),
                                            ),
                                            Expanded(
                                              flex:4,
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(snapshot.data[index].remark_desc,style: TextStyle(
                                                    fontFamily: 'Libre',
                                                    //fontWeight: FontWeight.bold,
                                                    fontSize: SizeConfig.safeBlockHorizontal * 3.0,
                                                    color: black,
                                                    letterSpacing: 0.2)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        snapshot.data[index].remark_complete_status=="0" && login_type=="1" ? Divider():Container(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [

                                            snapshot.data[index].remark_complete_status=="0" && login_type=="1" ? RaisedButton(
                                              color: green,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20.0)),
                                              onPressed: () {
                                                show_Dialog(snapshot.data[index].remark_id,index);
                                              },
                                              child: Text(
                                                "Complete",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ):Container(),

                                           /* snapshot.data[index].remark_complete_status=="0" && login_type=="1" ? Container(
                                              child: InputChip(
                                                label: Text(isSelected[index] ? "Completed":"Complete"),
                                                labelStyle: TextStyle(color: Colors.white),
                                                backgroundColor: kTextColor,


                                                onSelected: !IsComplete[index] ? (bool value){
                                                  setState(() {
                                                    isSelected[index]=value;
                                                    show_Dialog(snapshot.data[index].remark_id,index);
                                                  });
                                                }:null,
                                                selected: isSelected[index],
                                                selectedColor: Colors.green,
                                              ),
                                            ):Container()
*/
                                          ],
                                        ),

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
                          child: Text(message,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
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
        datastatus="";
        getAlterChalan(datastatus);
        break;
      case 'Pending':
        datastatus="Pending";
        getAlterChalan(datastatus);
        break;
      case 'Complete':
        datastatus="Complete";
        getAlterChalan(datastatus);
        break;
    }
  }
  Future<void> getAlterChalan(String id) async {

    message="";
    print("alter");
    Map<String, dynamic> param = {
      "page": page.toString(),
      "session_admin_login_type":login_type.toString(),
      "session_admin_id":uid.toString(),
      "sessionYear": financialYear,
      "remarkListFilterType": id,
      "api_name": "viewAllRemarkProcess",
    };



    bool IsData = await remarkModel.fetchList(
        context, param, scaffoldState, true, false);
    if(!IsData)
    {
      message="No Data Found !";
    }
    print("alter===${IsData}");
    setState(() {});
  }

  void show_Dialog(String id,int index)
  {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Completed"),
            content: Text("Are you sure completed ?",style: TextStyle(color:  Colors.black,fontSize: 16),),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isSelected[index]=false;
                  });
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  completeTask(id,index);
                },
              )
            ],
          );
        } );
  }

  Future<void> completeTask(String id,int index)
  async {
    Map<String, dynamic> param = {
      "idsToComplete":id,
      "api_name": "completeMultipleRemarkProcess",
    };
    MessageModelParam  IsData= await messageModel.add_post(
        context, param, scaffoldState, true, false);
    if(!IsData.status)
    {
      message="No Data Found !";
    }
    else
      {
        setState(() {
          IsComplete[index]=true;
        });

      }

  }

}
