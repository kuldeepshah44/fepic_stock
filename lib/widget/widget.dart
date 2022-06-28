import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';


const appname="Team Fepic";
const appTag="Managment";
class Widgets with ChangeNotifier
{
  appBar(String title)
  {
    return AppBar(
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: logocolor,
      title: Text(title,style: TextStyle(color: Colors.white),),
    );
  }



}