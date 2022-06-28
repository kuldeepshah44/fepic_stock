import 'package:fepic_stock/model/notification_model.dart';
import 'package:fepic_stock/utility/colors.dart';
import 'package:fepic_stock/utility/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationLayout extends StatelessWidget {
  final NotificationModelParam notificationModelParam;
  final int index;
  final void Function(Map<String,dynamic> data) onAcceptClick;
  final void Function(Map<String,dynamic> data) onDetailClick;
 // final void Function(NotificationModelParam category) onProductClick;

  const NotificationLayout({
    Key key,
    this.notificationModelParam,
    this.index,
    this.onAcceptClick,
    this.onDetailClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {},
      child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(
                left: 5, right: 5, top: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    white,white
                  ],
                  begin:
                  const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
              //  shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(30.0))
              borderRadius: BorderRadius.all(
                  Radius.circular(20.0)),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Text("Date : ",
                                style: TextStyle(
                                    fontFamily: 'Libre',
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: SizeConfig
                                        .safeBlockHorizontal *
                                        3.5,
                                    color: black,
                                    letterSpacing:
                                    0.2)),
                            Text(
                                notificationModelParam
                                    .notification_Added_on,
                                style: TextStyle(
                                    fontFamily: 'Libre',
                                    // fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig
                                        .safeBlockHorizontal *
                                        3.0,
                                    color: black,
                                    letterSpacing:
                                    0.2)),
                          ],
                        ))
                  ],
                ),
                Row(
                  children: [
                    Text("From : ",
                        style: TextStyle(
                            fontFamily: 'Libre',
                            //  fontWeight: FontWeight.bold,
                            fontSize: SizeConfig
                                .safeBlockHorizontal *
                                3.5,
                            color: black,
                            letterSpacing: 0.2)),
                    Text(
                        notificationModelParam
                            .admin_og_name,
                        style: TextStyle(
                            fontFamily: 'Libre',
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig
                                .safeBlockHorizontal *
                                3.5,
                            color: black,
                            letterSpacing: 0.2)),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("Notification : ",
                          style: TextStyle(
                              fontFamily: 'Libre',
                              // fontWeight: FontWeight.bold,
                              fontSize: SizeConfig
                                  .safeBlockHorizontal *
                                  3.5,
                              color: black,
                              letterSpacing: 0.2)),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                          notificationModelParam
                              .notification_description,
                          style: TextStyle(
                              fontFamily: 'Libre',
                              fontWeight:
                              FontWeight.bold,
                              fontSize: SizeConfig
                                  .safeBlockHorizontal *
                                  3.5,
                              color: black,
                              letterSpacing: 0.2)),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                      color: hhhh,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20.0)),
                      onPressed: () {

                       // getNotificationDetail(notificationModelParam.notification_id,index);
                        Map<String,dynamic> map=new Map();
                        map['notification_id']=notificationModelParam.notification_id;
                        map['index']=index;
                        onDetailClick(map);
                      },
                      child: Text(
                        "Detail",
                        style:
                        TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10,),
                    notificationModelParam.notification_type=="SendChalan" ? RaisedButton(
                      color: green,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20.0)),
                      onPressed: () {
                       // notificationAccept(notificationModelParam.notification_id);

                      },
                      child: Text(
                        "Accept",
                        style:
                        TextStyle(color: Colors.white),
                      ),
                    ):Container(),
                    SizedBox(width: 10,),
                    notificationModelParam.notification_type=="SendChalan" ? RaisedButton(
                      color: mErrorColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20.0)),
                      onPressed: () {

                       // notificationReject(notificationModelParam.notification_id);
                      },
                      child: Text(
                        "Reject",
                        style:
                        TextStyle(color: Colors.white),
                      ),
                    ):Container()
                  ],
                )
              ],
            ),
          )),
    );
  }
}
