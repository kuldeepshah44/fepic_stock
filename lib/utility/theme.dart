import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';


ThemeData theme(BuildContext context) {
  ThemeData theme = ThemeData(
    // brightness: Brightness.dark,
    textTheme: TextTheme(
      title: TextStyle(color: kPrimaryColor),
    ),
    scaffoldBackgroundColor: kScafolfColor,
    primaryColor: kPrimaryColor,
    primaryColorLight: kPrimaryLightColor,

    accentColor: kSecondaryColor,
    indicatorColor: Colors.black26,
    secondaryHeaderColor: Colors.white,
    cardTheme: CardTheme(
        // color: Colors.blueGrey,
        ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: Colors.black45,
      unselectedIconTheme: IconThemeData(color: Colors.black45),
      unselectedLabelStyle: TextStyle(color: Colors.black45),
      showUnselectedLabels: true,
    ),
    appBarTheme: AppBarTheme(
      color: kPrimaryColor,
      textTheme: TextTheme(
          title: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    iconTheme: IconThemeData(color: kPrimaryColor),

    tabBarTheme: TabBarTheme(
        labelColor: Colors.black, unselectedLabelColor: kPrimaryColor),
  );
  Get.changeTheme(theme);
  // appModel.currentTheme = theme;
  return theme;
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    // floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 10),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}



AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: kPrimaryColor,
    elevation: 0,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      headline6: TextStyle(color: Colors.white, fontSize: 18),
      // headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    ),
  );
}

LinearGradient getAppLinearGradient(
    {Alignment begin = Alignment.centerLeft,
    Alignment end = Alignment.centerRight,
    String appMode}) {
  return LinearGradient(
    begin: begin,
    end: end,
    colors: PrimaryGradientColor,
  );
}

TextStyle appBarHeaderTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyText1.copyWith(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );
}

TextStyle logoTextStyle(BuildContext context, {String screenType = "Splash"}) {
  return GoogleFonts.poppins(
      fontSize: screenType == "Splash" ? 50 : 30,
      fontWeight: FontWeight.bold,
      color: screenType == "Splash"
          ? Colors.white
          : Theme.of(context).primaryColor);
}

TextStyle heading1(BuildContext context, {Color color}) {
  return GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: color ?? Theme.of(context).primaryColor);
}

TextStyle heading2(BuildContext context, {Color color}) {
  return GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500);
  // return GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w500,color: color??Theme.of(context).primaryColor);
}

TextStyle heading3(BuildContext context, {Color color}) {
  return GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color ?? Theme.of(context).primaryColor);
}

Widget getAssetImage(String assetName, {double width, double height}) {
  return Image.asset(
    'assets/images/$assetName',
    width: width,
    height: height,
  );
}

Widget buildHeader(BuildContext context, GlobalKey<ScaffoldState> scafoldkey) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            scafoldkey.currentState.openDrawer();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: getAssetImage("profile.jpeg", height: 40, width: 40),
          ),
        ),
        Text(
          "Krivaa",
          style: GoogleFonts.kaushanScript(
              fontSize: 30, color: Theme.of(context).primaryColor),
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            ))
      ],
    ),
  );
}

Widget loaderWidget(context) {
  return Center(
    child: SpinKitDoubleBounce(
      //color: Colors.black,
      color: Theme.of(context).indicatorColor,
      size: 50.0,
    ),
  );
}
