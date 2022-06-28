import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/product_model.dart';
import 'package:fepic_stock/model/sub_product_model.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddNewSubProduct extends StatefulWidget {
  String product_id;
  String product_name;
  bool IsEditSubPRoduct;
  SubProductModelParam subProductDetail;

  AddNewSubProduct({Key key, this.product_id, this.product_name,this.IsEditSubPRoduct=false,this.subProductDetail})
      : super(key: key);

  @override
  _AddNewSubProductState createState() => _AddNewSubProductState();
}

class _AddNewSubProductState extends State<AddNewSubProduct> {
  GlobalKey<ScaffoldState> scafoldkey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  MessageModel messageModel;
  ProductModel productModel;
  ProductModelParam selectProductList;
  String selectedProduct = "-1";
  String selectedProduct_name = "Select Product";
  bool isSelectionChanged = false;
  TextEditingController subproductController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    messageModel = Provider.of<MessageModel>(context, listen: false);
    productModel = Provider.of<ProductModel>(context, listen: false);

    if(widget.IsEditSubPRoduct)
      {
        subproductController.text=widget.subProductDetail.sub_product_name;
        selectedProduct=widget.subProductDetail.product_id;
      }

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scafoldkey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: Text(widget.IsEditSubPRoduct ? "Update Sub Product":"Add Sub Product",
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
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        controller: subproductController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            prefixIcon: Icon(Icons.device_hub, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Enter Sub Product",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter sub product';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    productDropDownList(),
                    SizedBox(height: 15.0),
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
                          add_subProduct();
                        }
                      },
                      child: Text(widget.IsEditSubPRoduct ? "Update":"Added Sub Product"),
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

  Widget productDropDownList() {
    return StreamBuilder(
      stream: productModel.getAllProduct,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          /*if (snapshot.hasData && snapshot.data[0].product_id != "-1") {
            (snapshot.data as List<ProductModelParam>).insert(
                0,
                ProductModelParam(
                    product_id: "-1", product_name: "Select Product"));
          }*/

         if (widget.IsEditSubPRoduct && !isSelectionChanged) {

            selectProductList =
                (snapshot.data as List<ProductModelParam>).firstWhere(
                        (element) {
                      return element.product_id == widget.subProductDetail.product_id &&
                          element.product_name == widget.subProductDetail.product_name;
                    }, orElse: () {
                  //selectUserTypeModelParam=snapshot.data[0];
                });
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
                      selectProductList = newValue;
                      print(newValue);
                      selectedProduct = newValue.product_id;
                      selectedProduct_name = newValue.product_name;
                      isSelectionChanged=true;
                      print("product id==${newValue.product_id}");
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

  Future<void> add_subProduct() async {
    if (subproductController.text == "") {
      Share()
          .error_message(scafoldkey, "Please enter sub product name !", false);
      return;
    } else if (selectedProduct == "-1") {
      Share().error_message(scafoldkey, "Please select product list !", false);
      return;
    } else {
      Map<String, dynamic> map = Map();
      map['inputSubProductName'] = subproductController.text;
      map['selectproduct'] = selectedProduct;
      map['editingUniqueId'] = widget.IsEditSubPRoduct ? widget.subProductDetail.sub_product_id:"";
      map['api_name'] = widget.IsEditSubPRoduct ? "editSubProductProcess":"addSubProductProcess";
      MessageModelParam IsData =
          await messageModel.add_post(context, map, scafoldkey, true, false);
      if (IsData.status) {
        setState(() {
          subproductController.text = "";
          if(!widget.IsEditSubPRoduct) {
            selectedProduct = "-1";
            selectedProduct_name = "Select Product";
          }
          else
            {
              Get.back();
            }
        });
      }
      Share()
          .show_Dialog(context, IsData.message,widget.IsEditSubPRoduct?"Update Sup Product": "Add Sub Product", IsData.status);
    }
  }
}
