import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/message_model.dart';
import 'package:fepic_stock/model/party_model.dart';
import 'package:fepic_stock/model/user_type.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddNewParty extends StatefulWidget {
  bool IsEditParty;
  UserDetails userDetails;

  AddNewParty({Key key, this.IsEditParty = false, this.userDetails = null})
      : super(key: key);

  // AddNewParty({Key key}) : super(key: key);

  @override
  _AddNewPartyState createState() => _AddNewPartyState();
}

class _AddNewPartyState extends State<AddNewParty> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  UserTypeModel userTypeModel;
  String selectedUserType = "-1";
  UserTypeModelParam selectUserTypeModelParam;
  MessageModel messageModel;
  PartyModel partyModel;
  UserModel userModel;
  TextEditingController partyNameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController gstinController = new TextEditingController();
  TextEditingController loginuserController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController cpasswordController = new TextEditingController();
  bool isSelectionChanged = false;
var uid;
var login_type;
var username;
  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
    userTypeModel = Provider.of<UserTypeModel>(context, listen: false);
    messageModel = Provider.of<MessageModel>(context, listen: false);
    partyModel = Provider.of<PartyModel>(context, listen: false);

    if (widget.userDetails != null) {
      partyNameController.text = widget.userDetails.admin_og_name;
      addressController.text = widget.userDetails.admin_address;
      mobileController.text = widget.userDetails.admin_mobno;
      gstinController.text = widget.userDetails.admin_gstin;
      loginuserController.text = widget.userDetails.admin_name;
      passwordController.text = widget.userDetails.admin_password;
      cpasswordController.text = widget.userDetails.admin_password;
      print("widget.userDetails.type_name===${widget.userDetails.type_name}");

      selectedUserType = widget.userDetails.admin_type;
      // selectUserTypeModelParam = UserTypeModelParam(type_name: widget.userDetails.type_name,admin_type_id: widget.userDetails.admin_type);
      // selectUserTypeModelParam.admin_type_id=widget.userDetails.admin_type;

    }
  }

  Future<void> getUserSession() async {
    uid = await userModel.getUserId();
    login_type = await userModel.getUserType();
    username = await userModel.getPartyName();

    print("uid====${uid}==login_type==${login_type}");

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: Text(widget.IsEditParty ? "Update Party" : "Add Party",
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
                        controller: partyNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            prefixIcon: Icon(Icons.person, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Party Name",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please party name';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        controller: addressController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            prefixIcon: Icon(Icons.add_location, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Full Address",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter full address';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            prefixIcon: Icon(Icons.phone_iphone, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Mobile Number",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter mobile number !';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        controller: gstinController,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: Icon(Icons.fiber_pin, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "GSTIN",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter GSTIN';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    partyDropDownList(),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        controller: loginuserController,
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: Icon(Icons.verified_user, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Login Name",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter login name';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        controller: passwordController,
                        // keyboardType: TextInputType.number,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: Icon(Icons.security, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Password",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextFormField(
                        controller: cpasswordController,
                        // keyboardType: TextInputType.number,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: Icon(Icons.security, size: 20),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: "Confirm Password",
                            fillColor: Colors.white70),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter confirm password';
                          }
                          return null;
                        },
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
                          addParty();
                        }
                      },
                      child: Text(widget.IsEditParty ? "Update" : "Add Party"),
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
      stream: userTypeModel.getAllUserType,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data[0].admin_type_id != "-1") {
            (snapshot.data as List<UserTypeModelParam>).insert(
                0,
                UserTypeModelParam(
                    admin_type_id: "-1", type_name: "Select User Type"));
          }
          if (widget.IsEditParty && !isSelectionChanged) {

            selectUserTypeModelParam =
                (snapshot.data as List<UserTypeModelParam>).firstWhere(
                    (element) {
              return element.admin_type_id == widget.userDetails.admin_type &&
                  element.type_name == widget.userDetails.type_name;
            }, orElse: () {
                  //selectUserTypeModelParam=snapshot.data[0];
                });
          }
          //  print("WHAT IS LENGTH ${(snapshot.data as List<UserTypeModelParam>).length}");
          //  print("WHAT IS SELECTED  ${selectUserTypeModelParam.toJson().toString()} ");

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
                child: DropdownButton<UserTypeModelParam>(
                  value: selectUserTypeModelParam != null
                      ? selectUserTypeModelParam
                      : snapshot.data[0],
                  hint: Text("Select User Type"),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).dividerColor,
                  ),
                  onChanged: (UserTypeModelParam newValue) {
                    setState(() {
                      // cou = newValue;
                      selectUserTypeModelParam = newValue;
                      isSelectionChanged = true;
                      selectedUserType = newValue.admin_type_id;
                    });
                  },
                  items: snapshot.data
                      .map<DropdownMenuItem<UserTypeModelParam>>((value) {
                    print("kya aayya ${value.type_name.toString()}");
                    return DropdownMenuItem<UserTypeModelParam>(
                      value: value,
                      child: Text(value.type_name),
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

  Future<void> addParty() async {
    if (partyNameController.text == "") {
      Share().error_message(scaffoldState, "Please Enter Party Name !", false);
      return;
    } else if (addressController.text == "") {
      Share().error_message(scaffoldState, "Please Enter Address !", false);
      return;
    } else if (mobileController.text == "") {
      Share()
          .error_message(scaffoldState, "Please Enter Mobile Number !", false);
      return;
    } else if (mobileController.text.length < 10) {
      Share().error_message(scaffoldState, "Invalid Mobile Number !", false);
      return;
    } else if (gstinController.text == "") {
      Share().error_message(scaffoldState, "Please Enter GSTIN No !", false);
      return;
    } else if (loginuserController.text == "") {
      Share().error_message(scaffoldState, "Please Enter User Name !", false);
      return;
    } else if (passwordController.text == "") {
      Share().error_message(scaffoldState, "Please Enter Password !", false);
      return;
    } else if (cpasswordController.text == "") {
      Share().error_message(
          scaffoldState, "Please Enter Confirm Password !", false);
      return;
    } else if (selectedUserType == "-1") {
      Share().error_message(scaffoldState, "Please Select User Type !", false);
      return;
    } else if (passwordController.text != cpasswordController.text) {
      Share()
          .error_message(scaffoldState, "Miss match confirm password !", false);
      return;
    } else {
      Map<String, dynamic> map = new Map();
      if (widget.IsEditParty) {
        map['editingUniqueId'] = widget.userDetails.admin_id;
      }
      map['inputPartyLoginName'] = loginuserController.text;
      map['inputPartyLoginPwd'] = passwordController.text;
      map['inputPartyName'] = partyNameController.text;
      map['inputPartyAddress'] = addressController.text;
      map['inputPartyMob'] = mobileController.text;
      map['inputPartyGst'] = gstinController.text;
      map['selectUserType'] = selectedUserType;
      map['api_name'] =
          widget.IsEditParty ? "editUserProcess" : "addUserProcess";

      MessageModelParam IsData =
          await messageModel.add_post(context, map, scaffoldState, true, false);
      if (IsData.status) {
        setState(() {
          partyNameController.text = "";
          passwordController.text = "";
          cpasswordController.text = "";
          partyNameController.text = "";
          addressController.text = "";
          mobileController.text = "";
          gstinController.text = "";
          loginuserController.text = "";

          if (widget.IsEditParty) {
            Get.back();
          } else {
            selectedUserType = "-1";
            selectUserTypeModelParam.admin_type_id = "-1";
            selectUserTypeModelParam.type_name = "Select User Type";
          }
        });
      }
      Share().show_Dialog(context, IsData.message, "Add Party", IsData.status);
    }
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
}
