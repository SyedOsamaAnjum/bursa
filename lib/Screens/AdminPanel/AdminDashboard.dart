import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/LogReg/LoginScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:majascan/majascan.dart';
import 'package:permission/permission.dart';
import 'package:bursa_app/Screens/AdminPanel/EventUpdate.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
import 'AgentAssignScreen.dart';
import 'UpdateEvent.dart';
import 'UserList.dart';

class AdminDashboard extends StatefulWidget {

  final token;

  AdminDashboard({this.token});
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  PermissionName permissionName;

  @override
  void initState(){

    setState(() {
      getData();
      getEvents();
    });
    super.initState();
  }

  static JsonDecoder _decoder = JsonDecoder();
  // String Token = token;
  static Dio dio = Dio();
  List<dynamic> userList;
  List<dynamic> eventsList;


  Future<List<String>> getEvents() {

    print(widget.token);

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.token}'
    };

    String u = "$url"+"/event";
    return http.get(u,headers: header).then((response){
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {

       eventsList= _decoder.convert(response.body);

      });

      print("EVENT LIST $eventsList");

      return [];
    });

  }



  Future<List<String>> getData() {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.token}'
    };

    String u = "$url"+"/users/";
    return http.get(u,headers: header).then((response){
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {

        List<dynamic> user= _decoder.convert(response.body);
//        print(user);

        userList = user.where((element) => element['userType'] == 2).toList();
       print(userList);

      });

      return [];
    });

  }



  // ignore: missing_return
  Future onScan(String data) {
    print(data);

  }

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: black,
          centerTitle: true,
          title: Text('DashBoard',
          style: textStyle.copyWith(
            fontSize: 18,
            color: amber,
          ),),
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.qrcode,
              color: amber,),
            onPressed: () async{

              String g =  await MajaScan.startScan(
                  title: "Scan",
                  barColor: Colors.red,
                  titleColor: Colors.green,
                  qRCornerColor: Colors.blue,
                  qRScannerColor: Colors.deepPurple,
                  flashlightEnable: true,
                  scanAreaScale: 0.7 /// value 0.0 to 1.0
              );



            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.power_settings_new,
                color: amber,),
              onPressed: () async{

                Navigator.popAndPushNamed(context, LoginScreen.id);
              },
            ),
          ],
          bottom: TabBar(
              isScrollable: true,
              labelColor: amber,
              indicatorColor: Colors.transparent,
              labelStyle: TextStyle(
                  fontSize: 12,
                  color: amber
              ),
              unselectedLabelColor: grey,
              unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                  color: grey
              ),
              tabs: [
                Container(
                  height: 20,
                  child: Text('All Users'),
                ),
                Container(
                  height: 20,
                  child: Text('All Events'),
                ),
              ]),
        ),
        body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('Upcoming Event:',
                      //   style: textStyle.copyWith(
                      //       fontSize: 18,
                      //       color: amber
                      //   ),),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Card(
                      //   child: Container(
                      //     width: media.width,
                      //     height: media.height * 0.3,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: white
                      //     ),
                      //     child: Column(
                      //       children: [
                      //         Container(
                      //           height: 30,
                      //           child: ListTile(
                      //             title: Text('Event Name:',
                      //               style: textStyle.copyWith(
                      //                   fontSize: 14,
                      //                   color: grey
                      //               ),),
                      //             trailing: Text('New Year Event',
                      //               style: textStyle.copyWith(
                      //                   fontSize: 18,
                      //                   color: amber
                      //               ),),
                      //           ),
                      //         ),
                      //         Container(
                      //           height: 30,
                      //           child: ListTile(
                      //             title: Text('Event Date:',
                      //               style: textStyle.copyWith(
                      //                   fontSize: 14,
                      //                   color: grey
                      //               ),),
                      //             trailing: Text('09-11-2020',
                      //               style: textStyle.copyWith(
                      //                   fontSize: 18,
                      //                   color: amber
                      //               ),),
                      //           ),
                      //         ),
                      //         Container(
                      //           height: 30,
                      //           child: ListTile(
                      //             title: Text('Start Time:',
                      //               style: textStyle.copyWith(
                      //                   fontSize: 14,
                      //                   color: grey
                      //               ),),
                      //             trailing: Text('07:45 PM',
                      //               style: textStyle.copyWith(
                      //                   fontSize: 18,
                      //                   color: amber
                      //               ),),
                      //           ),
                      //         ),
                      //         Container(
                      //           height: 30,
                      //           child: ListTile(
                      //             title: Text('Number Of Guest:',
                      //               style: textStyle.copyWith(
                      //                   fontSize: 14,
                      //                   color: grey
                      //               ),),
                      //             trailing: Text('90',
                      //               style: textStyle.copyWith(
                      //                   fontSize: 18,
                      //                   color: amber
                      //               ),),
                      //           ),
                      //         ),
                      //         Container(
                      //           height: 30,
                      //           child: ListTile(
                      //             title: Text('Ticket Price:',
                      //               style: textStyle.copyWith(
                      //                   fontSize: 14,
                      //                   color: grey
                      //               ),),
                      //             trailing: Text('\$40',
                      //               style: textStyle.copyWith(
                      //                   fontSize: 18,
                      //                   color: amber
                      //               ),),
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           height: 10,
                      //         ),
                      //         RaisedButton(
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(5)
                      //           ),
                      //           onPressed: (){
                      //
                      //           },
                      //           child: Text('Guest List',
                      //             style: textStyle.copyWith(
                      //                 fontSize: 18,
                      //                 color: black
                      //             ),
                      //           ),
                      //           color: amber,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('User\'s List:',
                            style: textStyle.copyWith(
                                fontSize: 18,
                                color: amber
                            ),),
                          RaisedButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return UserList(token: widget.token,);
                            }));
                          },
                            color: amber,
                            child: Text('Manage User\'s',
                              style: textStyle.copyWith(
                                  fontSize: 18,
                                  color: black
                              ),),)
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: media.width,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: userList == null ? 0 : userList.length,
                          itemBuilder: (BuildContext context, int index){
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: grey.withOpacity(0.2)
                                    )
                                  ]
                              ),
                              child: ListTile(
                                onTap: (){
                                  // Navigator.pushNamed(context, NewsDetailScreen.id);
                                },
                                // isThreeLine: true,
                                title: Text(userList[index]["username"],
                                  style: textStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: amber,
                                      fontSize: 18
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Email : ${userList[index]["email"]}",
                                      style: textStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: amber,
                                          fontSize: 12
                                      ),
                                    ),
                                    Text("Join Date: ${userList[index]["joiningDate"]}",
                                      style: textStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: amber,
                                          fontSize: 12
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                itemCount: eventsList == null ? 0 : eventsList.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 5
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: grey.withOpacity(0.2)
                          )
                        ]
                    ),
                    child: ListTile(
                      trailing: Container(
                        width: 70,
                        child: GestureDetector(
                          child: Icon(Icons.edit_outlined,
                            color: amber,),
                          onTap: (){

                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return EventUpdate(
                                    eventName: eventsList[index]['name'],
                                    startDate: eventsList[index]['startDate'],
                                    endTime: eventsList[index]['endDate'],
                                    price: eventsList[index]['price'],
                                    img: eventsList[index]['imageURL'],
                                    video: eventsList[index]['videoURL'],
                                    description: eventsList[index]['description'],
                                    eventId: eventsList[index]['id'],
                                    token: widget.token,
                                  );
                                })).then((value) => getEvents());
                          },
                        ),
                      ),
                      title: Text(eventsList[index]['name'],
                        style: textStyle.copyWith(
                            fontSize: 18,
                            color: amber
                        ),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text("Start Date : ${eventsList[index]['startDate']}",
                            style: textStyle.copyWith(
                                fontSize: 12,
                                color: amber
                            ),),
                          Text("End Date : ${eventsList[index]['endDate']}",
                            style: textStyle.copyWith(
                                fontSize: 12,
                                color: amber
                            ),),
                        ],
                      ),
                    ),
                  );
                },
              )
            ]),
      ),
    );
  }
}

class UserTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 5
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: grey.withOpacity(0.2)
            )
          ]
      ),
      child: ListTile(
        trailing: IconButton(
            icon: Icon(Icons.delete_outline,
              color: amber,),
            onPressed: null),
        leading: Text('User Name',
          style: textStyle.copyWith(
              fontSize: 18,
              color: amber
          ),),
      ),
    );
  }
}
