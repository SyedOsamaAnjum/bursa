import 'dart:async';
import 'dart:convert';

import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/AgentPanel/ChatScreen.dart';
import 'package:bursa_app/Screens/CaseStudyList.dart';
import 'package:bursa_app/Screens/CaseStudyScreen.dart';
import 'package:bursa_app/Screens/LogReg/LoginScreen.dart';
import 'package:bursa_app/Services/URLlauncher.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';
import '../AAArticle.dart';
import '../AATeamEvent.dart';
import '../AnnouncementGlobal.dart';
import '../AnnouncementMalaysia.dart';
import '../Entitlement.dart';
import '../LearnScreen.dart';
import '../NewsDetailScreen.dart';
import '../NewsFeedScreen.dart';
import '../Profile.dart';
import '../ResearchScreen.dart';
import '../Screener.dart';
import 'BottomNavigationScreen.dart';
import 'MyEvents.dart';
import 'WatchList.dart';

class Alerts extends StatefulWidget {

  final userId;
  final agentId;
  final AccessToken;
  final email;
  final pic;
  final jDate;
  final userName;
  final password;

  Alerts({this.userId,this.agentId,this.AccessToken,this.email,this.pic, this.jDate, this.userName, this.password});
  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {

  bool op1 = false;
  bool op2 = false;
  bool op3 = false;
  bool op4 = false;
  bool op5 = false;
  bool op6 = false;

  List alerts;



  Future<List<String>> getData() {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      // 'Authorization':'${widget.token}'
    };

    String u = "$url"+"/chat/GetNotification";
    return http.get(u,headers: header).then((response) async{
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {
        alerts= jsonDecode(response.body);



      });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("notification", alerts.length);
        prefs.commit();


      return [];
    });

  }

  String x;
  Future<void> getT() {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.AccessToken}'
    };

    String u = "$url"+"/CaseStudy/TandC/2";
    http.get(u,headers: header).then((response) async{
      int StatusCode = response.statusCode;
      print(StatusCode);

      Map data = jsonDecode(response.body);
      List dataX = data.values.toList();
      setState(() {
        x= dataX[1];
      });

    });
  }

  HubConnection connection;

  Future<void> createSignalRConnection() async {

    // print("userId ${widget.currentUser}");
    print("agent Id ${widget.agentId}");
    connection =
        HubConnectionBuilder().withUrl("$imgUrl/chatHub?userId=${widget.userId}").build();
    await connection.start().then((value) {
      print("started");
    });
//    connection.invoke("BroadCastMessage");
    connection.on("broadcastNotification", ([message, senderId]){

      showNotification();
    }
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Flutter devs', 'Flutter Local Notification Demo', platform,
        payload: 'Welcome to the Local Notification demo ');
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    getData();
    getT();

    var initializationSettingsAndroid =
    AndroidInitializationSettings('flutter_devs');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
      super.initState();
  }

  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(
        payload: payload,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {



    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: black,
        title: Text('Alerts',
        style: textStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: white
        ),),
      ),
        drawer: Container(
          width: media.width * 0.6,
          height: media.height,
          color: black,
          child: ListView(
            children: [
              Center(
                  child: Container(
                    height: 180,
                    width: 150,
                    child: Image.asset('assets/images/AALOGO.png',
                      fit: BoxFit.cover,),
                  )
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: grey,
                  size: 20,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ProfileScreen(AccessToken: widget.AccessToken,username: widget.userName, email: widget.email,pic: widget.pic, jDate: widget.jDate, password: widget.password,);
                  }));
                },
                title: Text(
                  'Profile',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                leading: Icon(
                  Icons.remove_red_eye,
                  color: grey,
                  size: 20,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return WatchList(userId: widget.userId,agentId: widget.agentId,AccessToken: widget.AccessToken,);
                  }));
                },
                title: Text(
                  'WatchList',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, Entitlement.id);
                },
                leading: Icon(Icons.announcement, color: grey, size: 20),
                title: Text(
                  'Entitlement',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, ResearchScreen.id);
                },
                leading: Icon(Icons.find_in_page, color: grey, size: 20),
                title: Text(
                  'Research',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                leading: Icon(Icons.settings_overscan, color: grey, size: 20),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return Screener(AccessToken: widget.AccessToken,);
                  }));
                },
                title: Text(
                  'Screener',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                leading: Icon(Icons.receipt, color: grey, size: 20),
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context){
                    return AAArticle(AccessToken: widget.AccessToken,);
                  }));
                },
                title: Text(
                  'AA Article',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                leading: Icon(Icons.videocam, color: grey, size: 20),
                onTap: () {
                  Navigator.pushNamed(context, LearnScreen.id);
                },
                title: Text(
                  'Learn',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                leading: Icon(Icons.announcement, color: grey, size: 20),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return AATeamEvent(token: widget.AccessToken, email: widget.email);
                  }));
                },
                title: Text(
                  'AA Team Event',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                onTap: () {
                  if(widget.agentId != null){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ChatScreen(currentUser: widget.userId,agentId: widget.agentId,AccessToken: widget.AccessToken,);
                    }));
                  }else{
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('No Agent Assigned')));
                  }
                },
                leading: Icon(
                  EvaIcons.messageCircle,
                  color: grey,
                ),
                title: Text(
                  'Chat With Agent',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                leading: Icon(Icons.contacts, color: grey, size: 20),
                onTap: (){

                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return MyEvents(email: widget.email, token: widget.AccessToken,);
                  }));
                },
                title: Text(
                  'My Events',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: media.width,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Text('Terms And Condition'),
                              titleTextStyle: textStyle.copyWith(
                                  fontSize: 18,
                                  color: black
                              ),
                              content: Text(x),
                              contentTextStyle: textStyle.copyWith(
                                  fontSize: 15,
                                  color: grey
                              ),
                              actions: <Widget>[
                                RaisedButton(
                                  color: amber,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  onPressed: (){

                                    print(widget.AccessToken);
                                    Navigator.push(context, MaterialPageRoute(builder: (_){
                                      return AACaseStudy(accessToken: widget.AccessToken,);
                                    }));
                                  },
                                  child: Text('Accept'),
                                ),
                                RaisedButton(
                                  color: amber,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: Text('Close'),)
                              ],
                            );
                          }
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.hammer,
                          color: white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'AA Case Study',
                          style: textStyle.copyWith(fontSize: 15, color: white),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: media.width,
                height: 40,
                decoration: BoxDecoration(
                    color: Color(0xee2F76DA),
                    borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                    onPressed: () {
                      launchURL(url: "https://www.facebook.com/AATeam.My");
                    },
                    child: Row(
                      children: [
                        Icon(
                          EvaIcons.facebook,
                          color: white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Facebook',
                          style: textStyle.copyWith(fontSize: 15, color: white),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: media.width,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: white),
                child: FlatButton(
                    onPressed: () {
                      launchURL(url: "https://www.instagram.com/aateammy/");
                    },
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.instagram,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Instagram',
                          style: textStyle.copyWith(
                              fontSize: 15, color: Colors.red),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: media.width,
                height: 40,
                decoration: BoxDecoration(
                    color: Color(0xee76B9ED),
                    borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                    onPressed: () {
                      launchURL(url: "https://www.tiktok.com/@aateam96");
                    },
                    child: Row(
                      children: [
                        Container(
                            height: 24,
                            width: 24,
                            child: Image.asset('assets/images/tiktok.png')),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Tiktok',
                          style: textStyle.copyWith(fontSize: 15, color: white),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                onTap: (){
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                },
                leading: Icon(
                  Icons.power_settings_new,
                  color: amber,
                ),
                title: Text(
                  'LOGOUT',
                  style: textStyle.copyWith(color: amber, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      body: ListView.builder(
        itemCount: alerts.length,
        itemBuilder: (BuildContext context, int index) {
          String dateTime = alerts[index]['dateTime'];

          String date = dateTime.substring(0,10);
          String time = dateTime.substring(11,16);
          return Container
            (
            margin: EdgeInsets.symmetric(
                vertical: 5
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.4)
                  )
                ]
            ),
            child: ListTile(
              onTap: (){

              },
              isThreeLine: true,
              leading:alerts[index]['imageURL']== null?  Container(
                width: 100,
                height: MediaQuery.of(context).size.height,
                child: Text('No Image'),
              ): Container(
                width: 100,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: alerts[index]['isEvent'] == true?NetworkImage("$imgUrl/resources/events/${alerts[index]['imageURL']}"):NetworkImage("$imgUrl/resources/images/${alerts[index]['imageURL']}"),
                        fit: BoxFit.cover
                    )
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(alerts[index]['isEvent'] == true? 'New Event Added': 'New Article Posted',
                    style: textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: amber,
                        fontSize: 16
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${alerts[index]['isEvent'] == true?'Event Name: ': 'Article Name: '} ${alerts[index]['messageText']}',
                    style: textStyle.copyWith(
                        fontSize: 12,
                        color: white
                    ),),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text('Date : $date',
                        style: textStyle.copyWith(
                            fontSize: 12,
                            color: white
                        ),),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Time : $time',
                        style: textStyle.copyWith(
                            fontSize: 12,
                            color: white
                        ),),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
          )
    );
  }
}




class NewsFeedTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 5
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.4)
            )
          ]
      ),
      child: ListTile(
        onTap: (){
          Navigator.pushNamed(context, NewsDetailScreen.id);
        },
        isThreeLine: true,
        leading: Container(
          width: 100,
          height: MediaQuery.of(context).size.height,
          color: Colors.red,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stock Alert',
              style: textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: amber,
                fontSize: 18
              ),
            ),
          ],
        ),
        subtitle: Text('Descdsdsdsdsdcxccfvkvkvk;df;dkf;dc;kc;ldkc;dkc;kdcokdpkcpdkckscpsc',
          style: textStyle.copyWith(
              fontSize: 12,
              color: white
          ),),
      ),
    );
  }
}

class NewScreen extends StatelessWidget {
  String payload;

  NewScreen({
    @required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}