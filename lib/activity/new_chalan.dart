import 'package:fepic_stock/activity/login.dart';
import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/color_model.dart';
import 'package:fepic_stock/model/financialYearModal.dart';
import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/party_model.dart';
import 'package:fepic_stock/model/product_model.dart';
import 'package:fepic_stock/model/sub_product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';

import 'package:get/get.dart';
import 'package:fepic_stock/utility/share.dart';

import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import 'add_color.dart';
import 'add_party.dart';
import 'add_product.dart';
import 'add_sub_product.dart';

class NewChalan extends StatefulWidget {
  @override
  _NewChalanState createState() => _NewChalanState();
}

class _NewChalanState extends State<NewChalan> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  TextEditingController chalanNoController = new TextEditingController();
  TextEditingController lotNoController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();
  TextEditingController meterController = new TextEditingController();
  TextEditingController rateController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  PartyModel partyModel;
  ProductModel productModel;
  SubProductModel subProductModel;
  ColorModel colorModel;
  UserModel userModel;
  MessageModel messageModel;

  ///bool IsSubProductLoading = false;
  //bool IsSubProductLoading1 = false;

  String selectedParty = "-1";
  String selectedProduct = "-1";
  String selectedProduct_name = "Select Product";
  String selectedSubProduct = "-1";
  String selectedColor = "-1";
  String selectedColorName = "";
  String selectedID = "";
  ColorModelParam selectedColorList;

  ProductModelParam selectProductList;
  PartyModelParam selectedPartyList;
  SubProductModelParam selectedSubProductList;
  List<int> selectedItems = [];

  var chalan_no;
  var lot_no;

  ChalanModel chalanModel;
  Chalan_Lot_No chalan_lot_no;
  var uid;
  var login_type;
  var financialYear;
  String username;




  @override
  void initState() {
    super.initState();

    partyModel = Provider.of<PartyModel>(context, listen: false);
    productModel = Provider.of<ProductModel>(context, listen: false);
    subProductModel = Provider.of<SubProductModel>(context, listen: false);
    colorModel = Provider.of<ColorModel>(context, listen: false);
    chalanModel = Provider.of<ChalanModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
    messageModel = Provider.of<MessageModel>(context, listen: false);


    getUserSession();
    //getSubProduct("");
  }
  Future<void> getUserSession() async {
    uid = await userModel.getUserId();
    login_type = await userModel.getUserType();
    username = await userModel.getPartyName();
    financialYear = await  Share().currentFinancialYear();
    print("uid====${uid}==login_type==${login_type}");
    getChalanNo(false);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: Text("New Chalan",
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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [background, background],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: TextFormField(
                              controller: chalanNoController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  prefixIcon: Icon(Icons.format_list_numbered,
                                      size: 20),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  labelText: "Chalan No",
                                  fillColor: Colors.white70),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please chalan no';
                                }
                                return null;
                              },
                              onSaved: (value) {},
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {
                                  getChalanNo(true);
                                },
                                child: Container(
                                  child: Icon(Icons.refresh),
                                ))),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        controller: lotNoController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            prefixIcon: Icon(Icons.linear_scale, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Lot No",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please lot no';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Expanded(flex: 5, child: partyDropDownList()),
                        Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {
                                  Get.to(AddNewParty()).then((value) {
                                    getParty();
                                  });
                                },
                                child: Container(
                                  child: Icon(Icons.add_circle_outline),
                                ))),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Expanded(flex: 5, child: productDropDownList()),
                        Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {
                                  Get.to(AddNewProduct()).then((value){
                                    getProduct();
                                  });
                                },
                                child: Container(
                                  child: Icon(Icons.add_circle_outline),
                                ))),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Expanded(flex: 5, child: subProductDropDownList()),
                        Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {
                                  Get.to(AddNewSubProduct(
                                    product_id: selectedProduct,
                                    product_name: selectedProduct_name,
                                  )).then((value) {
                                    getSubProduct(selectedProduct);
                                  });
                                },
                                child: Container(
                                  child: Icon(Icons.add_circle_outline),
                                ))),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Expanded(flex: 4, child: colorDropDownList()),
                        Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {
                                  Get.to(AddColor(
                                    product_id: selectedProduct,
                                    product_name: selectedProduct_name,
                                  )).then((value) {
                                    getColor(selectedProduct);
                                  });
                                },
                                child: Container(
                                  child: Icon(Icons.add_circle_outline),
                                ))),
                       /* Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {

                                  Get.to(AddColor(IsEditColor: true,colorDetail: selectedColorList,)).then((value) {
                                    selectedColorList=value;
                                    getColor(selectedProduct);
                                  });

                                },
                                child: Container(
                                  child: Icon(Icons.edit),
                                ))),*/
                      ],
                    ),
                    SizedBox(height: 15.0),



                    Container(
                      child: TextFormField(
                        // keyboardType: TextInputType.number,
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: Icon(Icons.scatter_plot, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Quantity",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter quantity';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        // keyboardType: TextInputType.number,
                        controller: meterController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: Icon(Icons.device_hub, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Meter",
                            fillColor: Colors.white70),
                        /*validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter meter';
                          }
                          return null;
                        },*/
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        // keyboardType: TextInputType.number,
                        controller: rateController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: Icon(Icons.multiline_chart, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Rate",
                            fillColor: Colors.white70),
                        /*  validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter rate';
                          }
                          return null;
                        },*/
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    RaisedButton(
                      //color: Colors.red,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      splashColor: Colors.grey,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          addNewChalan();
                        }
                      },
                      child: Text("Add Chalan"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget partyDropDownList() {
    return StreamBuilder(
      stream: partyModel.GetAllParty,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
         /* if (snapshot.data[0].admin_id != "-1") {
            (snapshot.data as List<PartyModelParam>).insert(
                0, PartyModelParam(admin_id: "-1", admin_og_name: "Select Party"));          }
*/
         // (snapshot.data as List<PartyModelParam>).removeWhere((element) => element.admin_og_name.toLowerCase()==username.toLowerCase());

          return Container(
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
                  hint: Text("Select Party"),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).dividerColor,
                  ),
                  onChanged: (PartyModelParam newValue) {
                    setState(() {
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

  Widget productDropDownList() {
    return StreamBuilder(
      stream: productModel.getAllProduct,
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          return Container(
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
                child: DropdownButton<ProductModelParam>(
                  value: selectProductList != null
                      ? selectProductList
                      : snapshot.data[0],
                  hint: Text("Select Product"),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).dividerColor,
                  ),
                  onChanged: (ProductModelParam newValue) {
                    setState(() {

                      selectedSubProduct = "-1";
                      selectedColor = "-1";
                      selectedColorName="";
                      selectedID="";

                      selectProductList = newValue;
                      print(newValue);
                      selectedProduct = newValue.product_id;
                      selectedProduct_name = newValue.product_name;


                      print("product id==${newValue.product_id}");
                      getSubProduct(newValue.product_id);
                      getColor(newValue.product_id);
                    });
                  },
                  items: snapshot.data
                      .map<DropdownMenuItem<ProductModelParam>>((value) {
                    // print("kya aayya ${value.label.toString()}");
                    return DropdownMenuItem<ProductModelParam>(
                      value: value,
                      child: Text(value.product_name),
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

  Widget subProductDropDownList() {
    List<String> demo = ["Select Sub Product"];
    return Container(
      child: StreamBuilder(
        stream: subProductModel.getAllSubProduct,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return Container(
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
                  child: DropdownButton<SubProductModelParam>(
                    value: selectedSubProductList != null
                        ? selectedSubProductList
                        : snapshot.data[0],
                    hint: Text("Select Sub Product"),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).dividerColor,
                    ),
                    onChanged: (SubProductModelParam newValue) {
                      setState(() {
                        // cou = newValue;
                        selectedSubProductList = newValue;
                        selectedSubProduct = newValue.sub_product_id;
                        print("selectedSubProductList=${selectedSubProduct}");
                      });
                    },
                    items: snapshot.data
                        .map<DropdownMenuItem<SubProductModelParam>>((value) {
                      // print("kya aayya ${value.label.toString()}");
                      return DropdownMenuItem<SubProductModelParam>(
                        value: value,
                        child: Text(value.sub_product_name),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          } else {
            return Container(
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
                  child: DropdownButton<String>(
                    value: "Select Sub Product",
                    hint: Text("Select Sub Product"),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).dividerColor,
                    ),
                    onChanged: (String newValue) {
                      setState(() {});
                    },
                    items: demo.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget subProductDropDownList1() {
    List<String> demo = ["Select Sub Product"];
    return Container(
      child: StreamBuilder(
        stream: subProductModel.getAllSubProduct,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(color: Colors.black, width: 0.4),
                borderRadius: BorderRadius.all(Radius.circular(
                    5.0) //                 <--- border radius here
                ),
              ),
              child: SearchableDropdown.multiple(
                items: snapshot.data
                    .map<DropdownMenuItem<SubProductModelParam>>((value) {

                  return DropdownMenuItem<SubProductModelParam>(
                    value: value,
                    child: Text(value.sub_product_name),
                  );
                }).toList(),
               // selectedItems: selectedItems,
                selectedItems: selectedItems,
                hint: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Select any"),
                ),
                searchHint: "Select any",
                onChanged: (SubProductModelParam value) {
                  setState(() {
                    print(value);

                    print("selectedItems999999999=${value}");
                  });
                },

                closeButton: (selectedItems) {
                  return (selectedItems.isNotEmpty
                      ? "Save ${selectedItems.length == 1 ? '"' + "abc" + '"' : '(' + selectedItems.length.toString() + ')'}"
                      : "Save without selection");
                },
                isExpanded: true,
              ),
            );
          } else {
            return Container(
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
                  child: DropdownButton<String>(
                    value: "Select Sub Product",
                    hint: Text("Select Sub Product"),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).dividerColor,
                    ),
                    onChanged: (String newValue) {
                      setState(() {});
                    },
                    items: demo.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }


  Widget colorDropDownList() {
    List<String> demo = ["Select Color"];
    return Container(
      child: StreamBuilder(
        stream: colorModel.getAllColor,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return Container(
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
                  child: DropdownButton<ColorModelParam>(
                    value: selectedColorList != null
                        ? selectedColorList
                        : snapshot.data[0],
                    hint: Text("Select Color"),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).dividerColor,
                    ),
                    onChanged: (ColorModelParam newValue) {
                      setState(() {
                        // cou = newValue;
                        selectedColorList = newValue;
                        selectedColor = newValue.product_id;
                        selectedColorName=newValue.color_name;
                        selectedID=newValue.id;
                        print("selectedColor=${selectedColor}");
                      });
                    },
                    items: snapshot.data
                        .map<DropdownMenuItem<ColorModelParam>>((value) {
                      // print("kya aayya ${value.label.toString()}");
                      return DropdownMenuItem<ColorModelParam>(
                        value: value,
                        child: Text(value.color_name),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          } else {
            return Container(
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
                  child: DropdownButton<String>(
                    value: "Select Color",
                    hint: Text("Select Color"),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).dividerColor,
                    ),
                    onChanged: (String newValue) {
                      setState(() {});
                    },
                    items: demo.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }


  Future<void> getSubProduct(String pid) async {
    print("dg");
    Map<String, dynamic> param = {
      "type": "sub_product",
      "value": pid,
    };
    /*  setState(() {
      IsSubProductLoading1=true;
    });*/
    bool isload = await subProductModel.fetchList(
        context, param, scaffoldState, true, false);

  //  IsSubProductLoading = isload;
   // IsSubProductLoading1 = false;
    print("isload===${isload}");



    setState(() {});
  }


  Future<void> getColor(String pid) async {
    selectedColorList=null;
    selectedColor="-1";
    print("dg");
    Map<String, dynamic> param = {
    "type": "color_master",
    "value": pid,
    };
    /*  setState(() {
      IsSubProductLoading1=true;
    });*/
    bool isload = await colorModel.fetchColorList(
        context, param, scaffoldState, true, false);

  //  IsSubProductLoading = isload;
  //  IsSubProductLoading1 = false;
    print("isload===${isload}");
    setState(() {});
  }

  Future<void> getChalanNo(bool IsRefres) async {
    print("dg");
    Map<String, dynamic> param = {
      "type": "chalan",
      "value": "chalan_no",
    };

    chalan_lot_no = await chalanModel.getChalanNo(
        context, param, scaffoldState, IsRefres, false);

    chalanNoController.text = chalan_lot_no.chalan_no.toString();
    lotNoController.text = chalan_lot_no.lot_no.toString();
    chalan_no = chalan_lot_no.chalan_no.toString();
    lot_no = chalan_lot_no.lot_no.toString();
    print("chalan_no===${chalan_no},lot_no==${lot_no}");
    setState(() {});
  }



  Future<void> addNewChalan() async {
    if (chalanNoController.text == "") {
      Share().error_message(scaffoldState, "Please Enter Chalan No !", false);
      return;
    } else if (lotNoController.text == "") {
      Share().error_message(scaffoldState, "Please Enter Lot No !", false);
      return;
    } else if (selectedParty == "-1") {
      Share().error_message(scaffoldState, "Please Select Party !", false);
      return;
    } else if (selectedProduct == "-1") {
      Share().error_message(scaffoldState, "Please Select Product !", false);
      return;
    } else if (selectedSubProduct == "-1") {
      Share()
          .error_message(scaffoldState, "Please Select Sub Product !", false);
      return;
    } else if (quantityController.text == "") {
      Share().error_message(scaffoldState, "Please Enter Quantity !", false);
      return;
    }
    else if (quantityController.text == "0") {
      Share().error_message(scaffoldState, "Please Enter Quantity !", false);
      return;
    }

    else {

      if(meterController.text=="")
        {
          meterController.text="0";
        }
      if(rateController.text=="")
      {
        rateController.text="0";
      }

      uid = await userModel.getUserId();
      if (uid != null) {
        Map<String, dynamic> map = new Map();
        map['fromreprocess'] = 'false';
        map['inputChalanNo'] = chalanNoController.text;
        map['inputLotNo'] = lotNoController.text;
        map['deliverychalanno'] = "0";
        map['loginUser'] = uid;
        map['selectparty'] = selectedParty;
        map['selectproduct'] = selectedProduct;
        map['selectsubproduct'] = selectedSubProduct;
        map['inputChalanQty'] = quantityController.text;
        map['inputChalanMeter'] = meterController.text;
        map['inputChalanRate'] = rateController.text;
        map['api_name'] = "addChalanProcess";



        MessageModelParam IsData = await messageModel.add_post(
            context, map, scaffoldState, true, false);
        if (IsData.status) {
          setState(() {
            selectedPartyList.admin_id = "-1";
            selectedPartyList.admin_name = "Select Party";
            selectedParty = "-1";

            selectProductList.product_id = "-1";
            selectProductList.product_name = "Select Product";
            selectedProduct_name = "Select Product";
            selectedProduct = "-1";

            selectedSubProductList.sub_product_id = "-1";
            selectedSubProductList.sub_product_name = "Select Sub Product";
            selectedSubProduct = "-1";

            quantityController.text = "";
            meterController.text="";
            rateController.text="";

            getChalanNo(false);
          });
        }
        Share()
            .show_Dialog(context, IsData.message, "Add Chalan", IsData.status);
      } else {
        Get.offAll(LoginForm());
      }
    }
  }

  void showDialog1() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Dialog Title'),
              content: Text('This is my content'),
            ));
  }

  Future<void> getParty() async {
    print("dg");
    Map<String, dynamic> param = {
      "type": "user",
      "party_name":username,
    };
    bool isload = await partyModel.fetchPartyList(
        context, param, scaffoldState, false, false);
  }
  Future<void> getProduct() async {
    print("dg");
    Map<String, dynamic> param = {
      "type": "product",
    };
    bool isload =
    await productModel.fetchList(context, param, scaffoldState, false, false);
  }
}
