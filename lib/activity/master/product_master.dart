import 'dart:async';

import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/product_model.dart';
import 'package:fepic_stock/model/user_type.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

import '../add_product.dart';

class ProductMasterActivity extends StatefulWidget {

  @override
  _ProductMasterActivityState createState() => _ProductMasterActivityState();


}

class _ProductMasterActivityState extends State<ProductMasterActivity> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  ProductModel productModel;
  MessageModel messageModel;
  int page = 1;
  List<bool> isSelected = [];
  List<bool> IsComplete = [];
  bool IsEditTextError = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController userEditTypeController = new TextEditingController();
  TextEditingController useraddTypeController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    productModel = Provider.of<ProductModel>(context, listen: false);
    messageModel = Provider.of<MessageModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProduct(true);
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
        title: Text("Product",
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
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: ()
            {
              Get.to(AddNewProduct()).then((value) {
                getProduct(false);
              });
             // addDialog();
            },
          )
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
                        child: Text("Product Name",
                            style: TextStyle(
                                fontFamily: 'Libre',
                                fontWeight: FontWeight.bold,
                                fontSize:
                                SizeConfig.safeBlockHorizontal * 3.0,
                                color: white,
                                letterSpacing: 0.2)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text("HSN Code",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Libre',
                                fontWeight: FontWeight.bold,
                                fontSize:
                                SizeConfig.safeBlockHorizontal * 3.0,
                                color: white,
                                letterSpacing: 0.2)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text("Design No",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Libre',
                                fontWeight: FontWeight.bold,
                                fontSize:
                                SizeConfig.safeBlockHorizontal * 3.0,
                                color: white,
                                letterSpacing: 0.2)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Edit",
                          style: TextStyle(
                              fontFamily: 'Libre',
                              fontWeight: FontWeight.bold,
                              fontSize:
                              SizeConfig.safeBlockHorizontal * 3.0,
                              color: white,
                              letterSpacing: 0.2)),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Remove",
                          style: TextStyle(
                              fontFamily: 'Libre',
                              fontWeight: FontWeight.bold,
                              fontSize:
                              SizeConfig.safeBlockHorizontal * 3.0,
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
                  stream: productModel.getAllProduct,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.length > 0) {
                      return ListView.builder(
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                          //  isSelected.add(false);
                         //   IsComplete.add(false);
                            return snapshot.data[index].product_id !="-1" ? GestureDetector(
                              onTap: () {},
                              child: Card(
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(8),

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
                                              snapshot.data[index].product_name,
                                              style: TextStyle(
                                                  fontFamily: 'Libre',
                                                 // fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                      4.0,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                        ),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                              snapshot.data[index].product_HSN,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                      3.0,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                              snapshot.data[index].product_design_no,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Libre',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                      3.0,
                                                  color: black,
                                                  letterSpacing: 0.2)),
                                        ),

                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                             Get.to(AddNewProduct(IsEditProduct: true,productDetail: snapshot.data[index],)).then((value) {
                                               getProduct(false);
                                             });
                                            },
                                          ),
                                        ),

                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                            icon: Icon(Icons.remove_circle,color: Colors.red,),
                                            onPressed: () {
                                              // show_Dialog(snapshot.data[index].admin_id,index);
                                              show_Dialog(
                                                  snapshot.data[index]
                                                      .product_id,
                                                  index);
                                            },
                                          ),

                                          /* child: InputChip(
                                            label: Text(isSelected[index]
                                                ? "Deleted"
                                                : "Delete"),
                                            labelStyle:
                                            TextStyle(color: Colors.white),
                                            backgroundColor: kTextColor,
                                            onSelected: !IsComplete[index]
                                                ? (bool value) {
                                              setState(() {
                                                isSelected[index] = value;
                                                show_Dialog(
                                                    snapshot.data[index]
                                                        .admin_type_id,
                                                    index);
                                              });
                                            }
                                                : null,
                                            selected: isSelected[index],
                                            selectedColor: Colors.red,
                                          ),*/
                                        ),
                                      ],
                                    ),
                                  )),
                            ):Container();
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
              "Are you sure delete product ?",
              style: TextStyle(color: Colors.red, fontSize: 16,fontWeight: FontWeight.bold),
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
      "api_name": "removeProductProcess",
    };
    MessageModelParam IsData =
    await messageModel.add_post(context, param, scaffoldState, true, false);
    if (!IsData.status) {
      //message="No Data";
    } else {
      Share().show_Dialog(
          context, IsData.message, "Delete Product", IsData.status);
    /*  setState(() {
        IsComplete[index] = true;
      });*/
      getProduct(false);
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
                              child: Text("Add User Type",
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
                                "Add",
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

      getProduct(false);
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
      useraddTypeController.text="";
      Share().show_Dialog(
          context, IsData.message, "Add User Type", IsData.status);

      getProduct(false);
    }
  }

  Future<void> getProduct(bool status) async {
    print("user_type");
    Map<String, dynamic> param = {
      "type": "product",
     // "type_list": "list",

    };
    bool isload = await productModel.fetchList(
        context, param, scaffoldState, status, false);
  }
}
