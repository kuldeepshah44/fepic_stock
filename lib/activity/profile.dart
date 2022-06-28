import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  UserModel userModel;
  var uid;
  String login_type,user_name,address,mobile,gst;

  @override
  void initState() {
    super.initState();
    getUserSession();

  }

  Future<void> getUserSession() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    uid = prefs.getString("userid");
    user_name = prefs.getString("full_name");
    address = prefs.getString("address");
    mobile = prefs.getString("mobile");
    gst = prefs.getString("gst");
    login_type = prefs.getString("user_type");
    setState(() {

    });

    print("uid====${uid}==login_type==${user_name}");

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: Text("Profile",
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
       child: ListView(
         shrinkWrap: true,
          children: <Widget>[
          SizedBox(
          height: 10,
        ),
            CircleAvatar(
              radius: 30,
              child: Text(
                  "${user_name[0].toUpperCase()}",style: TextStyle(fontSize: 20),),
              /* backgroundImage: AssetImage(
                                                      "images/logo.png"),*/
            ),
            SizedBox(
              height: 10,
            ),
        Text(
          user_name.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 22,
              fontFamily: "Raleway",
              fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 3,),
        Text(
          mobile,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontFamily: "Raleway",
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5,),
        Text(
         address,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.teal,
              fontSize: 11,
              fontFamily: "Raleway",
              fontWeight: FontWeight.bold),
        ),
        ]
       )
      ),
    );
  }
}
