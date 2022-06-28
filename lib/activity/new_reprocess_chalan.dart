import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/color_model.dart';
import 'package:fepic_stock/model/financialYearModal.dart';
import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/party_model.dart';
import 'package:fepic_stock/model/sub_product_model.dart';
import 'package:fepic_stock/utility/share.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

import 'add_color.dart';
import 'login.dart';

class NewReprocessChalan extends StatefulWidget {
  @override
  _NewReprocessChalanState createState() => _NewReprocessChalanState();
}

class _NewReprocessChalanState extends State<NewReprocessChalan> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  TextEditingController chalanNoController = new TextEditingController();
  TextEditingController productNameController = new TextEditingController();

  TextEditingController quantityController = new TextEditingController();
  TextEditingController meterController = new TextEditingController();
  TextEditingController rateController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  ChalanModel chalanModel;
  PartyModel partyModel;
  String selectedParty = "-1";
  String selectedYear = "Select Financial Year";
  String selectedLotNo = "Select Lot No";
  ChalanModelParam selectFinancialYearList;
  ChalanModelParam selectLotNoList;
  bool IsShowLotNo = false;
  bool IsShowSubProduct = false;

  SubProductModel subProductModel;
  String selectedSubProduct = "-1";
  String selectedProduct = "-1";
  var chalan_no;
  var uid;
  var login_type;
  var financialYear;
  Chalan_Lot_No chalan_lot_no;
  PartyModelParam selectedPartyList;
  SubProductModelParam selectedSubProductList;

  UserModel userModel;
  MessageModel messageModel;

  ColorModel colorModel;
  String selectedColor = "-1";
  String selectedColorName = "";
  String selectedID = "";
  ColorModelParam selectedColorList;

  @override
  void initState() {
    super.initState();
    userModel = new UserModel();
    chalanModel = Provider.of<ChalanModel>(context, listen: false);
    partyModel = Provider.of<PartyModel>(context, listen: false);
    subProductModel = Provider.of<SubProductModel>(context, listen: false);
    userModel = Provider.of<UserModel>(context, listen: false);
    messageModel = Provider.of<MessageModel>(context, listen: false);
    colorModel = Provider.of<ColorModel>(context, listen: false);

    getUserSession();
  }

  Future<void> getUserSession() async {
    uid = await userModel.getUserId();
    login_type = await userModel.getUserType();
    financialYear =await  Share().currentFinancialYear();
    print("uid====${uid}==login_type==${login_type}");

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: Text("Add New Reprocess Chalan",
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
                    financialYearDropDownList(),
                    SizedBox(height: 15.0),
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
                                  getChalanNo(selectedYear, true);
                                },
                                child: Container(
                                  child: Icon(Icons.refresh),
                                ))),
                      ],
                    ),
                    IsShowLotNo ? SizedBox(height: 15.0) : Container(),
                    IsShowLotNo ? lotNoDropDownList() : Container(),
                    SizedBox(height: 15.0),
                    partyDropDownList(),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        enabled: false,
                        controller: productNameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            prefixIcon: Icon(Icons.label_important, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Product",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Product';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    subProductDropDownList(),
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
                                    product_name: productNameController.text,
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
                         keyboardType: TextInputType.number,
                        controller: quantityController,
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
                        controller: meterController,
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: Icon(Icons.device_hub, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Meter",
                            fillColor: Colors.white70),
                       /* validator: (value) {
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
                        controller: rateController,
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: Icon(Icons.multiline_chart, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Rate",
                            fillColor: Colors.white70),
                       /* validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter rate';
                          }
                          return null;
                        },*/
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      //color: Colors.red,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      splashColor: Colors.grey,
                      onPressed: () {

                        if(selectedYear=="Select Financial Year")
                          {
                            Share().show_Dialog(context, "Please Select Financial Year",
                                "Select Financial Year", false);
                            return ;
                          }

                        if(_formKey.currentState.validate())
                          {
                            _formKey.currentState.save();
                            addReProcessChalan();
                          }
                      },
                      child: Text("Add Reprocess Chalan"),
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

  Widget financialYearDropDownList() {
    return StreamBuilder(
      stream: chalanModel.getAllFinancialYear,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data[0].chalan_id != "-1") {
          (snapshot.data as List<ChalanModelParam>).insert(
              0,
              ChalanModelParam(
                  chalan_id: "-1",
                  chalan_financial_year: "Select Financial Year"));
        }
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
                    color: Theme.of(context).dividerColor,
                  ),
                  onChanged: (ChalanModelParam newValue) {
                    setState(() {
                      selectFinancialYearList = newValue;
                      print(newValue);
                      selectedYear = newValue.chalan_financial_year;
                      getChalanNo(selectedYear, false);
                      getLotNo(selectedYear);
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

  Widget lotNoDropDownList() {
    return StreamBuilder(
      stream: chalanModel.getAllLotNo,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          if (snapshot.hasData && snapshot.data[0].chalan_id != "-1") {
            (snapshot.data as List<ChalanModelParam>).insert(
                0, ChalanModelParam(chalan_id: "-1", lot_no: "Select Lot No"));
          }
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
                child: DropdownButton<ChalanModelParam>(
                  value: selectLotNoList != null
                      ? selectLotNoList
                      : snapshot.data[0],
                  hint: Text("Select Lot No"),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).dividerColor,
                  ),
                  onChanged: (ChalanModelParam newValue) {
                    setState(() {
                      // cou = newValue;
                      selectLotNoList = newValue;
                      selectedLotNo = newValue.lot_no;

                      selectedProduct = newValue.product_id;
                      productNameController.text = newValue.product_name;
                      getSubProduct(newValue.product_id);
                      getColor(selectedProduct);
                    });
                  },
                  items: snapshot.data
                      .map<DropdownMenuItem<ChalanModelParam>>((value) {
                    // print("kya aayya ${value.label.toString()}");
                    return DropdownMenuItem<ChalanModelParam>(
                      value: value,
                      child: Text(value.lot_no),
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

  Widget partyDropDownList() {
    return StreamBuilder(
      stream: partyModel.GetAllParty,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
         /* if (snapshot.data[0].admin_id != "-1") {
            (snapshot.data as List<PartyModelParam>).insert(
                0, PartyModelParam(admin_id: "-1", admin_og_name: "Select Party"));
          }*/

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

  Future<void> getLotNo(String id) async {
    print("dg");
    Map<String, dynamic> param = {
      "type": "chalan",
      "value": "lot_no",
      "id": id,
    };
    /*  setState(() {
      IsSubProductLoading1=true;
    });*/
    bool isload =
        await chalanModel.fetchList(context, param, scaffoldState, true, false);
    IsShowLotNo = isload;
    print("isload===${isload}");
    setState(() {});
  }

  Widget subProductDropDownList() {
    return StreamBuilder(
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
                      selectedSubProduct = newValue.sub_product_id;
                      selectedSubProductList = newValue;
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
          List<String> demo = ["Select Sub Product"];
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

    IsShowSubProduct = isload;
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

  Future<void> getChalanNo(String id, bool IsRefres) async {
    print("dg");
    Map<String, dynamic> param = {
      "type": "chalan",
      "value": "chalan_no",
      "id": id,
    };

    chalan_lot_no = await chalanModel.getChalanNo(
        context, param, scaffoldState, IsRefres, false);

    chalan_no = chalan_lot_no.chalan_no.toString();
    chalanNoController.text = chalan_lot_no.chalan_no.toString();
    if(chalan_lot_no.chalan_no==null)
      {
        chalanNoController.text ="Chalan No";
      }

    print("chalan_no===${chalan_no}");
    setState(() {});
  }

  Future<void> addReProcessChalan() async {
    if (selectedYear == "Select Financial Year") {
      //Share().error_message(scaffoldState, "Please Select Year !", false);
      Share().show_Dialog(context, "Please Select Financial Year",
          "Select Financial Year", false);
      return;
    } else if (chalanNoController.text == "") {
      Share().error_message(scaffoldState, "Please Enter Chalan No !", false);
      return;
    } else if (selectedLotNo == "Select Lot No") {
      Share().error_message(scaffoldState, "Please select Lot No !", false);
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
    else if (int.parse(quantityController.text) == "0") {
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
        map['fromreprocess'] = 'true';
        map['inputChalanNo'] = chalanNoController.text;
        map['inputLotNo'] = selectedLotNo;
        map['deliverychalanno'] = "0";
        map['loginUser'] = uid;
        map['selectparty'] = selectedParty;
        map['selectproduct'] = selectedProduct;
        map['selectsubproduct'] = selectedSubProduct;
        map['inputChalanQty'] = quantityController.text;
        map['inputChalanMeter'] = meterController.text;
        map['inputChalanRate'] = rateController.text;
        map['selectfinancialyear'] = financialYear.toString();
        map['api_name'] = "addChalanProcess";


        MessageModelParam IsData = await messageModel.add_post(
            context, map, scaffoldState, true, false);
        if (IsData.status) {
          setState(() {
            selectedLotNo = "Select Lot No";


            selectLotNoList=null;
            selectedPartyList=null;

            selectedParty = "-1";

            selectedProduct = "-1";

           // selectedYear = "Select Financial Year";

            productNameController.text="";

            selectedSubProductList.sub_product_id = "-1";
            selectedSubProductList.sub_product_name = "Select Sub Product";
            selectedSubProduct = "-1";

            quantityController.text = "";
            meterController.text="";
            rateController.text="";
            getChalanNo(selectedYear, false);
            //getChalanNo(false);
          });
        }
        Share()
            .show_Dialog(context, IsData.message, "Add Reprocess Chalan", IsData.status);
      } else {
        Get.offAll(LoginForm());
      }
    }
  }
}
