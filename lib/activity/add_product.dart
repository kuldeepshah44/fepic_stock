import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/product_model.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddNewProduct extends StatefulWidget {

  bool IsEditProduct;
  ProductModelParam productDetail;
  AddNewProduct({Key key,this.IsEditProduct=false,this.productDetail=null}):super(key:key);

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController productNameController = new TextEditingController();
  TextEditingController hsnController = new TextEditingController();
  TextEditingController designController = new TextEditingController();

  MessageModel messageModel;
  ProductModel productModel;
  @override
  void initState() {
    super.initState();
    messageModel=Provider.of<MessageModel>(context,listen: false);
    productModel=Provider.of<ProductModel>(context,listen: false);

    if(widget.IsEditProduct)
      {
        productNameController.text=widget.productDetail.product_name;
        hsnController.text=widget.productDetail.product_HSN;
        designController.text=widget.productDetail.product_design_no;
      }

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: Text(widget.IsEditProduct ? "Update Product" :"Add New Product",
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
                    Container(
                      child: TextFormField(
                        controller: productNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            prefixIcon: Icon(Icons.label_important, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Product Name",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Product name';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        controller: hsnController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            prefixIcon: Icon(Icons.add_location, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Product HSN Code",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter HSN code';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        controller: designController,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            prefixIcon:
                                Icon(Icons.format_list_numbered, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Design No",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter design no !';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
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
                          addProduct();
                        }
                      },
                      child: Text(widget.IsEditProduct ? "Update" :"Add Product"),
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

  Future<void> addProduct() async {

    if(productNameController.text=="")
      {
        Share().error_message(scaffoldState, "Please enter product name !", false);
      return;
      }
    else if(hsnController.text=="")
    {
      Share().error_message(scaffoldState, "Please enter HSN code !", false);
      return;
    }
    else if(designController.text=="")
    {
      Share().error_message(scaffoldState, "Please enter design no !", false);
      return;
    }
    else{
      Map<String,dynamic> map=Map();

      if(widget.IsEditProduct) {
        map['editingUniqueId'] = widget.productDetail.product_id;
      }
      map['inputProductName']=productNameController.text;
      map['inputproducthsn']=hsnController.text;
      map['inputDesignNo']=designController.text;
      map['api_name']=widget.IsEditProduct?"editProductProcess" :"addProductProcess";
      MessageModelParam IsData = await messageModel.add_post(
          context, map, scaffoldState, true, false);
      if(IsData.status)
        {
          setState(() {
            productNameController.text="";
            hsnController.text="";
            designController.text="";
            if(widget.IsEditProduct)
              {
                Get.back();
              }
            //getProduct();
          });
        }
      Share().show_Dialog(context, IsData.message, "Add Product", IsData.status);
    }
  }


}
