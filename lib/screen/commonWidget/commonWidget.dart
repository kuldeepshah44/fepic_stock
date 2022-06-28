import 'package:flutter/cupertino.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:fepic_stock/utility/share.dart';

class CommonWidget with ChangeNotifier{

  header(String title)
  {
    return Container(
    child: Text(title,style: TextStyle(fontFamily: 'Libre',fontWeight: FontWeight.w400,fontSize: SizeConfig.safeBlockHorizontal*5.0,color: HexColor("#000000")),),
    );
  }

}