import 'package:fepic_stock/activity/alter_chalan_activity_list.dart';
import 'package:fepic_stock/activity/demo.dart';
import 'package:fepic_stock/activity/login.dart';
import 'package:fepic_stock/activity/master/chalan_master.dart';
import 'package:fepic_stock/activity/master/chalan_master_activity.dart';
import 'package:fepic_stock/activity/master/color_list.dart';
import 'package:fepic_stock/activity/master/lot_master.dart';
import 'package:fepic_stock/activity/master/notification_activity.dart';
import 'package:fepic_stock/activity/master/order_master.dart';
import 'package:fepic_stock/activity/master/party_master.dart';
import 'package:fepic_stock/activity/master/product_master.dart';
import 'package:fepic_stock/activity/master/stock_master.dart';
import 'package:fepic_stock/activity/master/sup_product_master.dart';
import 'package:fepic_stock/activity/master/type_master.dart';
import 'package:fepic_stock/activity/master/user_master.dart';
import 'package:fepic_stock/activity/profile.dart';
import 'package:fepic_stock/model/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:fepic_stock/utility/theme.dart';
import 'package:fepic_stock/widget/widget.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  final scfoldKey;
  final ontap;
  String uid;
  String login_type;
  String username;
  String current_year;

   DrawerScreen({Key key, this.scfoldKey, this.ontap,this.uid,this.login_type,this.username,this.current_year}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

UserModel userModel;



  @override
  void initState() {
    super.initState();

   userModel=Provider.of<UserModel>(context,listen: false);
    // TODO: implement initState

print("login type====${widget.login_type}");

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Stack(
      children: [
        SafeArea(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                /*  child: Column(
                    children: [
                      Text(
                        appname,
                        style: TextStyle(
                            fontFamily: 'Libre',
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.safeBlockHorizontal * 9.4,
                            color: logocolor,
                            letterSpacing: 0.2),
                      ),
                      Text(
                        appTag,
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 3.8,
                          color: Color(0xff757575),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                          wordSpacing: 1,
                          fontFamily: 'Allura',
                        ),
                      ),
                    ],
                  )*/
                child:  Container(
                    height: 45,
                    child: Image.asset("images/title.png",fit:BoxFit.contain,)),
              ),
          SizedBox(height: 15,),
              widget.current_year !=""?   Container(
                child: Text("Financial Year : ${widget.current_year}",style: TextStyle(color: kShrineBrown900,fontWeight: FontWeight.bold,fontSize: 13,),),
              ):Container(),
              SizedBox(height: 10,),
              widget.username !=""?   Container(
                child: Text("User : ${widget.username}",style: TextStyle(color: kShrineBrown900,fontWeight: FontWeight.bold,fontSize: 16,),),
              ):Container(),

              Divider(
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(
                          "Shop For",
                          style: heading2(context),
                        ),
                      ),*/
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.home,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "Home",
                          style: heading2(context),
                        ),
                        onTap: () {
                          widget.ontap(0);
                        },
                      ),

                      widget.login_type=="1" ? ExpansionTile(

                        leading: Icon(Icons.category),
                        title: Text("All Master"),
                        children:<Widget>[
                          ListTile(
                            leading: Icon(Icons.merge_type),
                            title: Text(
                             "Type Master",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            onTap: (){
                              Get.to(TypeMasterActivity());
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.supervised_user_circle),
                            title: Text(
                              "User Master",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            onTap: ()
                            {
                              Get.to(UserMasterActivity());
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.label_important),
                            title: Text(
                              "Product Master",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            onTap: (){
                              Get.to(ProductMasterActivity());
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.subdirectory_arrow_right),
                            title: Text(
                              "Sub Product Master",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            onTap: (){
                              Get.to(SubProductMasterActivity());
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.account_circle),
                            title: Text(
                              "Party Master",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            onTap: (){
                              Get.to(PartyMasterActivity());
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.color_lens),
                            title: Text(
                              "Color Master",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            onTap: (){
                              Get.to(ColorMasterActivity());
                            },
                          ),
                        ]
                      ):Container(),


                      widget.login_type=="1" ? ListTile(
                        leading: Icon(
                          CupertinoIcons.loop_thick,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "Lot Master",
                          style: heading2(context),
                        ),
                        onTap: () {
                          Get.to(LotMasterActivity());
                        },
                      ):Container(),

                      ListTile(
                        leading: Icon(
                          Icons.note,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "Chalan Master",
                          style: heading2(context),
                        ),
                        onTap: () {
                         Get.to(ChalanMasterNewActivity());
                        },
                      ),

                      ListTile(
                        leading: Icon(
                          Icons.repeat,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "Alter List",
                          style: heading2(context),
                        ),
                        onTap: () {
                          Get.to(AlterChalanList());
                        },
                      ),

                      ListTile(
                        leading: Icon(
                          Icons.notifications,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "Notification",
                          style: heading2(context),
                        ),
                        onTap: () {
                         Get.to(NotificationMasterActivity());
                        },
                      ),


                      widget.login_type=="1" ? ListTile(
                        leading: Icon(
                          Icons.store_mall_directory,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "Stock Master",
                          style: heading2(context),
                        ),
                        onTap: () {
                         Get.to(StockMasterActivity());
                        },
                      ):Container(),

                      widget.login_type=="1" ? ListTile(
                        leading: Icon(
                          Icons.device_hub,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "Order Master",
                          style: heading2(context),
                        ),
                        onTap: () {
                          Get.to(OrderMasterActivity());
                        },
                      ):Container(),

                      Divider(
                        color: kPrimaryLightColor,
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(
                          "Account",
                          style: heading2(context),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "Profile",
                          style: heading2(context),
                        ),
                        onTap: () {


                          Get.to(Profile());
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "Logout",
                          style: heading2(context),
                        ),
                        onTap: () {
                          userModel.logOut();
                         // Get.offAll(LoginForm());
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              LoginForm()), (Route<dynamic> route) => false);
                          //Navigator.pushAndRemoveUntil(context, LoginForm(), (route) => false)
                          // Get.to(TermCondition());
                        },
                      ),
                     /* Divider(
                        color: kPrimaryLightColor,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(
                          "Help & Support",
                          style: heading2(context),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.security,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "Terms & Conditions ",
                          style: heading2(context),
                        ),
                        onTap: () {
                         // Get.to(TermCondition());
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.security,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "Privacy & Policy ",
                          style: heading2(context),
                        ),
                        onTap: () {
                         // Get.to(PrivacyPolicy());
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.flag,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "About Us ",
                          style: heading2(context),
                        ),
                        onTap: () {
                          //Get.to(AboutUsScreen());
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.help,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "Contact Us ",
                          style: heading2(context),
                        ),
                        onTap: () {
                        //  Get.to(ContactUSScreen());
                        },
                      ),*/

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ) // Populate the Drawer in the next step.
        );
  }
}
// class _DrawerScreenState extends State<DrawerScreen> {
//   AppModel appModel;
//   UserModel userModel;
//   @override
//   void initState() {
//     appModel = Provider.of<AppModel>(context, listen: false);
//     userModel = Provider.of<UserModel>(context, listen: false);
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//         child: Stack(
//       children: [
//         SafeArea(
//           child: Column(
//             // mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                   padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
//                   child: Column(
//                     children: [
//                       Text(
//                         appName,
//                         style: TextStyle(
//                             fontFamily: 'Libre',
//                             fontWeight: FontWeight.w400,
//                             fontSize: SizeConfig.safeBlockHorizontal * 9.4,
//                             color: kPrimaryColor,
//                             letterSpacing: 0.2),
//                       ),
//                       Text(
//                         appTag,
//                         style: TextStyle(
//                             fontSize: SizeConfig.safeBlockHorizontal * 3.3,
//                             color: Color(0xff757575),
//                             fontWeight: FontWeight.w500,
//                             letterSpacing: 0.2,
//                             wordSpacing: 0.4),
//                       ),
//                     ],
//                   )),
//               userModel.user != null
//                   ? Padding(
//                       padding:
//                           const EdgeInsets.only(bottom: 8, left: 8, right: 8),
//                       child: Text(
//                         "${userModel.user.mobile}",
//                         style: heading2(context),
//                       ),
//                     )
//                   : Container(),
//               Divider(
//                 color: Theme.of(context).primaryColor,
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       ListTile(
//                         leading: Icon(
//                           CupertinoIcons.home,
//                           color: Theme.of(context).primaryColor,
//                           size: 25,
//                         ),
//                         // trailing: Icon(Icons.arrow_forward_ios),
//                         title: Text(
//                           "Home",
//                           style: heading2(context),
//                         ),
//                         onTap: () {
//                           widget.ontap(0);
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.account_balance_wallet,
//                           color: Theme.of(context).primaryColor,
//                           size: 25,
//                         ),
//                         // trailing: Icon(Icons.arrow_forward_ios),
//                         title: Text(
//                           "Wallet",
//                           style: heading2(context),
//                         ),
//                         onTap: () {
//                           widget.ontap(1);
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.shopping_cart_outlined,
//                           color: Theme.of(context).primaryColor,
//                           size: 25,
//                         ),
//                         // trailing: Icon(Icons.arrow_forward_ios),
//                         title: Text(
//                           "Cart",
//                           style: heading2(context),
//                         ),
//                         onTap: () {
//                           widget.ontap(2);
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.person_outline,
//                           color: Theme.of(context).primaryColor,
//                           size: 25,
//                         ),
//                         // trailing: Icon(Icons.arrow_forward_ios),
//                         title: Text(
//                           "Profile",
//                           style: heading2(context),
//                         ),
//                         onTap: () {
//                           widget.ontap(3);
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           LineAwesomeIcons.building_1,
//                           color: Theme.of(context).primaryColor,
//                           size: 25,
//                         ),
//                         // trailing: Icon(Icons.arrow_forward_ios),
//                         title: Text(
//                           bankDetails,
//                           style: heading2(context),
//                         ),
//                         onTap: () {
//                           setting().skys(BankDetails());
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.local_police,
//                           color: Theme.of(context).primaryColor,
//                           size: 25,
//                         ),
//                         // trailing: Icon(Icons.arrow_forward_ios),
//                         title: Text(
//                           "Terms & Conditions ",
//                           style: heading2(context),
//                         ),
//                         onTap: () {},
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.policy,
//                           color: Theme.of(context).primaryColor,
//                           size: 25,
//                         ),
//                         // trailing: Icon(Icons.arrow_forward_ios),
//                         title: Text(
//                           "Privacy & Policy ",
//                           style: heading2(context),
//                         ),
//                         onTap: () {},
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.assistant_photo_rounded,
//                           color: Theme.of(context).primaryColor,
//                           size: 25,
//                         ),
//                         // trailing: Icon(Icons.arrow_forward_ios),
//                         title: Text(
//                           "About Us ",
//                           style: heading2(context),
//                         ),
//                         onTap: () {},
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           Icons.contact_support,
//                           color: Theme.of(context).primaryColor,
//                           size: 25,
//                         ),
//                         // trailing: Icon(Icons.arrow_forward_ios),
//                         title: Text(
//                           "Contact Us ",
//                           style: heading2(context),
//                         ),
//                         onTap: () {},
//                       ),
//                       ListTile(
//                         leading: Icon(
//                           CupertinoIcons.arrowshape_turn_up_right,
//                           color: Theme.of(context).primaryColor,
//                           size: 25,
//                         ),
//                         // trailing: Icon(Icons.arrow_forward_ios),
//                         title: Text(
//                           "Share",
//                           style: heading2(context),
//                         ),
//                         onTap: () {},
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: getAppLinearGradient(appMode: appModel.AppMode),
//                 ),
//                 child: ListTile(
//                   leading: Icon(
//                     userModel.user != null ? Icons.logout : Icons.login,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                   title: Text(
//                     userModel.user != null ? "Logout" : "Login",
//                     style: heading1(context, color: Colors.white),
//                   ),
//                   onTap: () {
//                     if (userModel.user != null) {
//                       userModel
//                         ..removeData().then((value) {
//                           Get.offAll(SignInPage());
//                         });
//                     } else {
//                       userModel.removeData().then((value) {
//                         Get.offAll(SignInPage());
//                       });
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ) // Populate the Drawer in the next step.
//         );
//   }
// }

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
