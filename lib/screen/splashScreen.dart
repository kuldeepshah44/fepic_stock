import 'package:fepic_stock/model/party_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fepic_stock/model/sub_category_model.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  Animation<double>_animation;
  AnimationController _animationController;
//77790 49787


  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

  //  subcatlogs();
  // getParty();
    _animationController=AnimationController(duration: const Duration(seconds: 4),vsync: this)..repeat(reverse: true);
    _animation=CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: Image.asset("images/logo.png",width: MediaQuery.of(context).size.width / 2 +50,height: MediaQuery.of(context).size.width / 2 +50,fit: BoxFit.contain,),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
