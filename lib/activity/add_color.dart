import 'package:fepic_stock/model/color_model.dart';
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

class AddColor extends StatefulWidget {
  String product_id;
  String product_name;
  bool IsEditColor;
  ColorModelParam colorDetail;

  AddColor({Key key, this.product_id, this.product_name,this.IsEditColor=false,this.colorDetail})
      : super(key: key);

  @override
  _AddColorState createState() => _AddColorState();
}

class _AddColorState extends State<AddColor> {
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

    if(widget.IsEditColor)
    {
      subproductController.text=widget.colorDetail.color_name;
      selectedProduct=widget.colorDetail.product_id;
      print("selectedProduct=====${selectedProduct}");
    }



  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scafoldkey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: Text(widget.IsEditColor ? "Update Color":"Add Color",
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
                            labelText: "Enter Color Name",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter color name';
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
                      child: Text(widget.IsEditColor ? "Update":"Added Color"),
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

          if (widget.IsEditColor && !isSelectionChanged) {

            selectProductList =
                (snapshot.data as List<ProductModelParam>).firstWhere(
                        (element) {
                      return element.product_id == widget.colorDetail.product_id &&
                          element.product_name == widget.colorDetail.product_name;
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
          .error_message(scafoldkey, "Please enter color name !", false);
      return;
    } else if (selectedProduct == "-1") {
      Share().error_message(scafoldkey, "Please select product list !", false);
      return;
    } else {
      Map<String, dynamic> map = Map();
      map['inputColorName'] = subproductController.text;
      map['inputProductId'] = selectedProduct;
      map['editingUniqueId'] = widget.IsEditColor ? widget.colorDetail.id:"";
      map['api_name'] =widget.IsEditColor ? "editColorProcess": "addColorProcess";
      MessageModelParam IsData =
      await messageModel.add_post(context, map, scafoldkey, true, false);
      String msg="";
      if (IsData.status) {
        setState(() {
          subproductController.text = "";
          if(!widget.IsEditColor) {
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
          .show_Dialog(context, IsData.message,widget.IsEditColor ?"Update Color": "Add Color", IsData.status);
    }
  }
}
