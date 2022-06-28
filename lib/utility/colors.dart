import 'package:flutter/material.dart';

const mPrimaryColor = Colors.white;
const mPrimaryColorBrightness = Brightness.light; // use Brightness.dark, Brightness.light depend on primary Color
const mBrightness = Brightness.light;

const mInputThemeColor = Colors.black;

const mPrimarySwatch = Colors.grey;

const mAccentColor = Colors.black; // Accent Color
const mAccentColorBrightness = Brightness.dark;

const mPrimaryTextColor = Colors.black87; // Color for Header Icon, Text & Bottom Navbar Icon, Text

const mButtonColor = Colors.black; // Color for Button

const mTextDisplayColor = Colors.black87;

const mTextBodyColor = Colors.black87;
const white = Colors.white;
const btncolor = Colors.black87;
const black = Colors.black;
const logocolor = Colors.lightBlue;
const hhhh = Colors.lightBlue;
const green = Colors.green;
const remark = Colors.brown;
//const logocolor1 =Color(0xFFFF1111);
const logocolor1 = Color(0xFFffffff);
const logocolor2 =Color(0xFFC13000);
const background = Color(0xFFCECECE);

const mErrorColor = Color(0xFFC5032B);

const mSurfaceColor = Colors.white;
const mBackgroundColor = Colors.white;
const mCardColor = Colors.white;

const kPrimaryColor = Color(0xff821D67);
const kScafolfColor = Color(0xFFFFE9EB);
const kSecondaryColor = Color(0xFFE4C1A1);

const kTextColor = Color(0xFF757575);
const kwhiteColor = Colors.white;
const PrimaryGradientColor = [kPrimaryColor, kwhiteColor];

const kShrinePink50 = Color(0xFFFEEAE6);
const kShrinePink100 = Color(0xFFFEDBD0);
const kShrinePink300 = Color(0xFFFBB8AC);
const kShrinePink400 = Color(0xFFEAA4A4);

const kShrineBrown900 = Color(0xFF442B2D);
const kShrineBrown600 = Color(0xFF7D4F52);

const kShrineErrorRed = Color(0xFFC5032B);
const kPrimaryLightColor = Color(0xFFC7A98F);

const kShrineSurfaceWhite = Color(0xFFFFFBFA);
const kShrineBackgroundWhite = Colors.white;
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}