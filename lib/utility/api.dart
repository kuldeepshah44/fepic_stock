import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import 'colors.dart';

//String baseurl = "https://d7suits.com/flutter_api/";
//String baseurlf = "https://d7suits.com/flutter_api/";

 String baseurl = "http://fepic.in/flutter_api/";
 String folder = baseurl+"flutter_api/";
 String url = baseurl+"flutter_api/";



String getCommon =baseurl+"get_common.php";
String send_post_data1 =baseurl+"send_post_data.php";

String send_post_data="http://fepic.in/fepic_software/index.php/api/";

//http://fepic.in/fepic_software/index.php/api/addChalanProcess

//String getProduct = "get_common.php";
//String getSubProduct = "get_common.php";

class Api {

  Future<Map<String, dynamic>> getBaseUrl(String Apiname, params) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Map<String, String> headers = {
            "content-type": "application/x-www-form-urlencoded; charset=utf-8"
          };

          final http.Response response = await http.post(
            Uri.parse(Apiname),
            body: convert.jsonEncode(params),
            headers: headers,
          );
          var json = jsonDecode(response.body);

          if (response.statusCode == 200) {
            if (json["status"]) {
              return json["data"];
            } else {
              Fluttertoast.showToast(
                  msg: "Note: ${json["message"].toString()}",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black45,
                  textColor: Colors.white,
                  fontSize: 16.0);
              return null;
            }
          } else if (response.statusCode == 200) {
            return null;
          } else {
            throw Exception("Can not call api :  $Apiname");
          }
        } catch (err) {
          rethrow;
        }
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Check Your Internet.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<Map<String, dynamic>> apiPostFormData(String apiName, params, ctx,IsLoading) async {

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
      }
    } on SocketException catch (_) {
      debugPrint('Check Your Internet Connection');
      IsLoading=false;
      showtopToast(
          "Internet", "Check Your Internet Connection", Colors.red, ctx);
    }

    if(IsLoading)
      {
        loading(ctx);
      }

    try {
      debugPrint("${baseurl}${apiName}");
      debugPrint("params==${params}");

      Map<String, String> headers = {
        "content-type": "application/x-www-form-urlencoded"
      };

      final http.Response response = await http.post(
        Uri.parse(baseurl + apiName),
        body: params,
        headers: null,
      );

      var json = jsonDecode(response.body);
      debugPrint(json.toString());
      if (response.statusCode == 200) {
        return json;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception("Can not call api :  $apiName");
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<String> getPostData1(
      String apiName,Map params, bool message, bool isLoading,BuildContext ctx,GlobalKey<ScaffoldState> _scaffoldKey,
      {bool isfullresponce: false}) async {

    if (isLoading) {
      print("LOADING CONTEXT ${ctx}");
      loading(ctx);
    }
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Map<String, String> header = {
            "content-type": "application/x-www-form-urlencoded"
          };

          final http.Response response = await http.post(
            Uri.parse(baseurl + apiName),
            body: params,
            headers: header,
          );

          //debugPrint(response.body);

          if (response.statusCode == 200) {
            //if (jsonDecode(response.body) is Map) {
            var json = jsonDecode(response.body);
            debugPrint("api==${baseurl + apiName}");
            debugPrint("params==${convert.jsonEncode(params.toString())}");
            log(json.toString());


            if (isLoading) {
              //Navigator.pop(ctx);
              Get.back();
            }
            if (isfullresponce) {
              // print("full");
              return response.body.toString();
            } else {
              // print("full not");
              return response.body.toString();
            }

            /*} else {
              if (isLoading) {
                //  Navigator.pop(ctx);
                Get.back();
              }
              debugPrint(response.body);
              return null;
            }*/
          } else if (response.statusCode == 404) {
            if (isLoading) {
              //  Navigator.pop(ctx);
              // Get.back();
            }
            debugPrint(response.body);
            return null;
          } else {
            debugPrint(response.body);
            throw Exception(
                "API ISSUE :  ${baseurl + apiName + params.toString()}");
          }
        } catch (err) {
          debugPrint(err.toString());
          rethrow;
        }
      }
    } on Exception catch (_) {
      if (isLoading) {
        // Navigator.pop(ctx);
        //Get.back();
      }
      showInSnackBar(
          "Check Your Internet Connection", Get.context, _scaffoldKey);
      return null;

      //tostMessage("Check Your Internet Connection");
    }
  }

  Future<String> getPostData(
      String apiName,Map params, bool message, bool isLoading,BuildContext ctx,GlobalKey<ScaffoldState> _scaffoldKey,
      {bool isfullresponce: false}) async {

    String ci_api_name="";
    // print("api_name===${apiName}");
    // print("param===${params}");

    if(params['api_name'] != null)
      {
        ci_api_name=params['api_name'];
        apiName=apiName+ci_api_name;
      }
     print("api_name===${apiName}${params}");

    if (isLoading) {
      print("LOADING CONTEXT ${ctx}");
      loading(ctx);
    }
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Map<String, String> header = {
            "content-type": "application/x-www-form-urlencoded"
          };

          final http.Response response = await http.post(
            Uri.parse(apiName),
            body: params,
            headers: header,
          );

          debugPrint(response.body);

          if (response.statusCode == 200) {
            //if (jsonDecode(response.body) is Map) {
            var json = jsonDecode(response.body);
            debugPrint("api==${apiName}");
            debugPrint("params==${convert.jsonEncode(params.toString())}");
            log(json.toString());


            if (isLoading) {
              //Navigator.pop(ctx);
              Get.back();
            }
            if (isfullresponce) {
              // print("full");
              return response.body.toString();
            } else {
              // print("full not");
              return response.body.toString();
            }

            /*} else {
              if (isLoading) {
                //  Navigator.pop(ctx);
                Get.back();
              }
              debugPrint(response.body);
              return null;
            }*/
          } else if (response.statusCode == 404) {
            if (isLoading) {
              //  Navigator.pop(ctx);
              // Get.back();
            }
            debugPrint(response.body);
            return null;
          } else {
            debugPrint(response.body);
            throw Exception(
                "API ISSUE :  ${apiName + params.toString()}");
          }
        } catch (err) {
          debugPrint(err.toString());
          rethrow;
        }
      }
    } on Exception catch (_) {
      if (isLoading) {
        // Navigator.pop(ctx);
        Get.back();
      }
      showInSnackBar(
          "Check Your Internet Connection", Get.context, _scaffoldKey);
      return null;

      //tostMessage("Check Your Internet Connection");
    }
  }


  void showInSnackBar(String value, BuildContext tostcontext,GlobalKey<ScaffoldState> _scaffoldKey) {
    // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    FocusScope.of(Get.context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      //margin: EdgeInsets.only(bottom: 100),
      behavior: SnackBarBehavior.floating,
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: kPrimaryLightColor,
      duration: Duration(seconds: 3),
    ));
  }
  void internet(context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        // Navigator.pop(context);
      }
    } on SocketException catch (_) {
      debugPrint('Check Your Internet Connection');

      //   internetshowAlertDialog(context, "Check Your Internet Connection");
      //   internetMessage("Check Your Internet Connection");
      showtopToast(
          "Internet", "Check Your Internet Connection", Colors.red, context);
    }
  }

  void showtopToast(boldText, message, col, BuildContext co) {
    Widget toast = Container(
        width: double.infinity,
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        color: Colors.black,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(25.0),
        //   color: Colors.green,
        // ),
        child: Text(
          message,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ));

    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }



  loading(BuildContext context) {
    Get.dialog(Container(
      margin: EdgeInsets.only(
          bottom: Platform.isAndroid
              ? (MediaQuery.of(Get.context).size.height / 2) - 50
              : (MediaQuery.of(Get.context).size.height / 2) - 100,
          top: (MediaQuery.of(Get.context).size.height / 2) - 50,
          left: (MediaQuery.of(Get.context).size.width / 2) - 50,
          right: (MediaQuery.of(Get.context).size.width / 2) - 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
      ),
      child: SpinKitPouringHourglass(
        //color: Colors.black,
        color: logocolor,
        size: 50.0,
      ),
    ));
  }

  void showBottomToast(boldText, message, BuildContext co) {
    Widget toast = Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      color: Theme.of(co).secondaryHeaderColor,

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check,
            color: Colors.green,    ),

          SizedBox(
            width: 8.0,
          ),

          RichText(
            text: TextSpan(
              text: '${boldText}',
              style:
              TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: ' ${message}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              ],
            ),
          )
        ],
      ),
    );
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  Map<String, String> headers = {
    "content-type": "application/x-www-form-urlencoded; charset=utf-8"
  };
  Map<String, dynamic> cookies = {};
  List<Cookie> cookieList = [];
  String lan = 'en';
  Future<dynamic> post(String endPoint, Map data) async {
    data['lang'] = lan;
    headers['content-type'] =
    'application/x-www-form-urlencoded; charset=utf-8';
    final response = await http.post(
      Uri.parse(url + endPoint),
      headers: headers,
      body: data,
    );
    _updateCookie(response);
    return response;
  }
  void _updateCookie(http.Response response) async {
    String allSetCookie = response.headers['set-cookie'];
    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');
      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');
        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }
      headers['cookie'] = generateCookieHeader();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cookies', json.encode(cookies));
  }

  void _setCookie(String rawCookie) {
    if (rawCookie.length > 0) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];
        if (key == 'path' || key == 'expires') return;
        cookies[key] = value;
      }
    }
  }

  String generateCookieHeader() {
    String cookie = "";
    for (var key in cookies.keys) {
      if (cookie.length > 0) cookie += ";";
      cookie += key + "=" + cookies[key];
    }
    return cookie;
  }

}