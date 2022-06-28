import 'dart:async';

import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/stock_model.dart';
import 'package:fepic_stock/model/user_party_model.dart';
import 'package:fepic_stock/model/user_type.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

class StockMasterActivity extends StatefulWidget {
  @override
  _ProductMasterActivityState createState() => _ProductMasterActivityState();
}

class _ProductMasterActivityState extends State<StockMasterActivity> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  StockModel stockMaster;
  MessageModel messageModel;
  int page = 1;
  List<bool> isSelected = [];
  List<bool> IsComplete = [];
  bool IsEditTextError = false;

  @override
  void initState() {
    super.initState();
    stockMaster = Provider.of<StockModel>(context, listen: false);
    messageModel = Provider.of<MessageModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserParty(true);
    });
  }

  void getAllUserType() {
    Map<String, dynamic> map = new Map();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: Text("Stock",
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
          /*IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: ()
            {
              addDialog();
            },
          )*/
        ],
      ),
      body: Container(
        color: background,
        child: Column(
          children: [
            Container(
              color: btncolor,
              padding: EdgeInsets.all(10),

              child: Row(
                children: [

                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Center(
                        child: Text("Lot No",
                            style: TextStyle(
                                fontFamily: 'Libre',
                                fontWeight: FontWeight.bold,
                                fontSize:
                                SizeConfig.safeBlockHorizontal * 4.0,
                                color: white,
                                letterSpacing: 0.2)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Stock Quantity",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Libre',
                              fontWeight: FontWeight.bold,
                              fontSize:
                              SizeConfig.safeBlockHorizontal * 4.0,
                              color: white,
                              letterSpacing: 0.2)),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Date",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Libre',
                              fontWeight: FontWeight.bold,
                              fontSize:
                              SizeConfig.safeBlockHorizontal * 4.0,
                              color: white,
                              letterSpacing: 0.2)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LazyLoadScrollView(
                scrollOffset: 10,
                onEndOfPage: () {
                  page = page + 1;
                  getAllUserType();
                },
                child: StreamBuilder(
                  stream: stockMaster.getAllStockData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.length > 0) {
                      return ListView.builder(
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
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
                                    child: Row(
                                      children: [

                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              snapshot.data[index].stock_lot_no,
                                              style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                      4.0,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              snapshot.data[index].stock_lot_qty,
                                              style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                      4.0,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              snapshot.data[index].stock_Added_On,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                      4.0,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                        ),

                                      ],
                                    ),
                                  )),
                            );
                          });
                    } else {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 100),
                          child: Text(""),
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

  void show_Dialog(String id, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text(
              "Are you sure delete Party ?",
              style: TextStyle(color: Colors.black, fontSize: 16),
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
      "api_name": "removePartyProcess",
    };
    MessageModelParam IsData =
    await messageModel.add_post(context, param, scaffoldState, true, false);
    if (!IsData.status) {
      //message="No Data";
    } else {
      Share().show_Dialog(
          context, IsData.message, "Delete Party", IsData.status);

      getUserParty(false);
    }
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController userEditTypeController = new TextEditingController();
  TextEditingController useraddTypeController = new TextEditingController();

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
                              child: Text("Update Party",
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
                              labelText: "Party Name",
                              fillColor: Colors.white70),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter party name';
                            }
                            return null;
                          },
                          onSaved: (value) {},
                        ),
                      ),
                      IsEditTextError
                          ? Text(
                        "Please enter party name !",
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

  addDialog() {
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
                              child: Text("Add Party",
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
                          controller: useraddTypeController,
                          // keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              prefixIcon: Icon(Icons.verified_user, size: 20),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              labelText: "Party Name",
                              fillColor: Colors.white70),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter party name !';
                            }
                            return null;
                          },
                          onSaved: (value) {},
                        ),
                      ),
                      IsEditTextError
                          ? Text(
                        "Please enter party name !",
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
                                "Add Party",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                if (useraddTypeController.text == "") {
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
                                  addType(useraddTypeController.text);
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

  Future<void> editType(String id, String type) async {
    Map<String, dynamic> param = {
      "editingUniqueId": id,
      "inputOrderPartyName": type,
      "api_name": "editPartyProcess",
    };
    MessageModelParam IsData =
    await messageModel.add_post(context, param, scaffoldState, true, false);
    if (!IsData.status) {
      //message="No Data";
    } else {
      Share().show_Dialog(
          context, IsData.message, "Edit User Type", IsData.status);

      getUserParty(false);
    }
  }
  Future<void> addType(String type) async {
    Map<String, dynamic> param = {
      "inputOrderPartyName": type,
      "api_name": "addPartyProcess",
    };
    MessageModelParam IsData =
    await messageModel.add_post(context, param, scaffoldState, true, false);
    if (!IsData.status) {
      //message="No Data";
    } else {
      useraddTypeController.text="";
      Share().show_Dialog(
          context, IsData.message, "Add Party", IsData.status);

      getUserParty(false);
    }
  }

  Future<void> getUserParty(bool status) async {
    print("user_type");
    Map<String, dynamic> param = {
      "type": "stock",
    };
    bool isload = await stockMaster.fetchList(
        context, param, scaffoldState, status, false);
  }
}
