
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:fepic_stock/model/UserModel.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:provider/provider.dart';

class BootomBar extends StatefulWidget {
  final ontap;
  var activeIndex;
  final appModel;

  BootomBar({Key key, this.ontap, this.activeIndex, this.appModel})
      : super(key: key);

  @override
  _BootomBarState createState() => _BootomBarState();
}

class _BootomBarState extends State<BootomBar> {
  // int _selectedIndex = 0;
  UserModel _userModel;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  _userModel = Provider.of<UserModel>(context,listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   boxShadow: [
      //     BoxShadow(
      //       blurRadius: 20,
      //       color: Colors.black.withOpacity(.1),
      //     )
      //   ],
      // ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Theme.of(context).primaryColor,
            hoverColor: Theme.of(context).primaryColor,
            gap: 8,
            // activeColor:widget.appModel.appColors[widget.appModel.AppMode]["primaryColor"],
            activeColor: Colors.white,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Theme.of(context).primaryColor,
            color: Theme.of(context).primaryColor,
            tabBackgroundGradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [
                0.1,
                0.9,
              ],
              colors: [
                Theme.of(context).primaryColorLight,
                Theme.of(context).primaryColor,
              ],
            ),
            tabs: [
              GButton(
                icon: CupertinoIcons.home,
                text: 'Home',
              ),
              // GButton(
              //   icon: Icons.search,
              //   text: 'Search',
              // ),
              GButton(
                icon: Icons.category,
                text: 'Categories',
              ),
              GButton(
                icon: Icons.shopping_cart,
                text: 'Cart',
              ),

              GButton(
                icon: Icons.person_outline,
                text: 'Profile',
              ),
            ],
            selectedIndex: widget.activeIndex,
            onTabChange: (index) {
              widget.activeIndex = index;
              widget.ontap(
                widget.activeIndex,
              );
              setState(() {});
             /* if(_userModel.user != null){
                widget.activeIndex = index;
                widget.ontap(
                  widget.activeIndex,
                );
                setState(() {});
              }else{
                Get.offAll(SignInPage());
              }
*/
            },
            //onTabChange: (index) {
            //   setState(() {
            //     _selectedIndex = index;
            //   });
            // },
          ),
        ),
      ),
    );
  }
}
