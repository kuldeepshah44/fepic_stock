import 'dart:async';


import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/model/notification_model.dart';
import 'package:fepic_stock/model/year_model.dart';
import 'package:fepic_stock/screen/homeScreen.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:fepic_stock/utility/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';



bool isLoggedIn = false;

class LoginForm extends StatefulWidget {

  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameControler = new TextEditingController();
  TextEditingController passwordControler = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  TextEditingController mobileController = new TextEditingController();
  TextEditingController otpController = new TextEditingController();
  FocusNode myFocusNode;

  GlobalKey<ScaffoldState> scaffoldState=new GlobalKey<ScaffoldState>();

UserModel userModel;
YearModel yearModel;
NotificationModel notificationModel;

  @override
  void initState() {
    super.initState();
    userModel=new UserModel();
    userModel = Provider.of<UserModel>(context, listen: false);
    yearModel = Provider.of<YearModel>(context, listen: false);
    notificationModel = Provider.of<NotificationModel>(context, listen: false);
    myFocusNode = FocusNode();

    getYear();


  }
  Future<void> getYear() async {
    print("fetchListFinancialYearProcess");
    Map<String,dynamic> param=new Map();
    param['api_name']="fetchListFinancialYearProcess";
    bool isload = await yearModel.fetchYear(context, param, scaffoldState, false, false);

  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        key: scaffoldState,
        appBar: AppBar(
          elevation: 1.0,
          iconTheme: IconThemeData(color: black),
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
          title: Text("Login",style: TextStyle(
              fontFamily: 'Libre',
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.safeBlockHorizontal * 5.2,
              color: black,
              letterSpacing: 0.2),),
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: new Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 40.0),
                Center(
                    child: Container(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width/2-50,
                    child: Image.asset(
                      "images/logo.png",

                      fit: BoxFit.contain,
                    ),
                  ),
                )),
                SizedBox(height: 20.0),
                Container(
                  child: TextFormField(
                    controller: usernameControler,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        prefixIcon: Icon(Icons.person, size: 20),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        labelText: "User Name",

                        fillColor: Colors.white70),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter user name';
                      }
                      return null;
                    },
                    onSaved: (value) {},
                  ),
                ),
                SizedBox(height: 12.0),
                Container(
                  child: TextFormField(
                    controller: passwordControler,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
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



                SizedBox(height: 22.0),
                GestureDetector(
                  onTap: (){
                    var login = new Map<String, dynamic>();
                    if (_formKey.currentState.validate()) {
                      login["username"] = usernameControler.text;
                      login["password"] = passwordControler.text;
                      login["type"] = "login";
                      onLogin(login);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [btncolor, logocolor1],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),



              ],
            ),
          ),
        ));
  }


 void onLogin(Map<String, dynamic> login) async {

   bool IsData = await userModel.login(
       context, login, scaffoldState, true, false);
   if(!IsData)
   {
     Share().error_message(scaffoldState, "Invalid Username or Password", IsData);
   }
   else
     {
       Get.offAll(HomeScreen());
     }
   print("alter===${IsData}");
   setState(() {});
 }

}
