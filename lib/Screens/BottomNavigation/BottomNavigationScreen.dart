import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/AgentPanel/ChatScreen.dart';
import 'package:bursa_app/Screens/BottomNavigation/Portfolio.dart';
import 'package:bursa_app/Screens/BottomNavigation/SearchScreen.dart';
import 'package:bursa_app/Screens/BottomNavigation/StockList.dart';
import 'package:bursa_app/Screens/BottomNavigation/WatchList.dart';
import 'package:bursa_app/Screens/BottomNavigation/MarketPlace.dart';
import 'package:bursa_app/Screens/BottomNavigation/Alerts.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Announcements.dart';


class BottomNavigationScreen extends StatefulWidget {

  static const id = 'BottomNavigationScreen';

  final userId;
  final agentId;
  final AcessToken;
  final email;
  final pic;
  final jDate;
  final userName;
  final password;

  BottomNavigationScreen({this.userId,this.agentId,this.AcessToken,this.pic,this.email, this.jDate, this.userName, this.password});
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {


  int _currentIndex = 0;

  bool show = false;
  List alerts;
  int alert;

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
        print(alerts);


      });
      return [];
    });

  }

  Future<int> getLength() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alert = prefs.getInt("notification");
    });
    return alert;
  }

  int alertLength;

  @override
  void initState() {
    // TODO: implement initState


    getLength();
    getData().then((value){

      print(alerts.length);
      setState(() {
        if(alerts.length > alert){
          setState(() {
            show = true;
            alertLength = alerts.length - alert;
          });
        }else{
          setState(() {
            show = false;
          });
        }
      });
    });


    super.initState();
  }

  Future<bool> onWillPop()async{
    return await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Do You To Exit The App?',
              style: TextStyle(
                fontSize: 18,
                color: amber
              ),),
            actions: <Widget>[
              RaisedButton(
                color: amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                onPressed: (){
                  SystemNavigator.pop();
                },
                child: Text('Yes'),
              ),
              RaisedButton(
                color: amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                onPressed: (){
                Navigator.pop(context);
              },
                child: Text('No'),)
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    // int x = widget.index;
    // setState(() {
    //   _currentIndex = x;
    // });


    List<Widget> screens = [
      StockList(userId: widget.userId,agentId: widget.agentId,AccessToken: widget.AcessToken,email: widget.email,pic: widget.pic, jDate: widget.jDate, userName: widget.userName, password: widget.password,),
      Announcement(userId: widget.userId,agentId: widget.agentId,AccessToken: widget.AcessToken,email: widget.email,pic: widget.pic, jDate: widget.jDate, userName: widget.userName,password: widget.password,),
      SearchScreen(userId: widget.userId,agentId: widget.agentId,AccessToken: widget.AcessToken,email: widget.email,pic: widget.pic, jDate: widget.jDate, userName: widget.userName,password: widget.password,),
      WatchList(userId: widget.userId,agentId: widget.agentId,AccessToken: widget.AcessToken,email: widget.email,pic: widget.pic, jDate: widget.jDate, userName: widget.userName,password: widget.password,),
      Alerts(userId: widget.userId,agentId: widget.agentId,AccessToken: widget.AcessToken,email: widget.email,pic: widget.pic, jDate: widget.jDate, userName: widget.userName,password: widget.password,),
    ];

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.equalizer,
            size: 20,),
                label: 'Market',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(icon: Icon(Icons.volume_up,
            size: 20,),
                label: 'Announcement',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(icon: Icon(EvaIcons.search,
              size: 20,),
                label: 'Search',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(icon: Icon(Icons.remove_red_eye,
            size: 20,),
                label: 'Watchlist',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(icon: Badge(
              showBadge: show,
              badgeContent: Text('$alertLength',),
              toAnimate: true,
              animationDuration: Duration(milliseconds: 300),
              shape: BadgeShape.circle,
              animationType: BadgeAnimationType.slide,
              badgeColor: amber,
              child: Icon(Icons.notifications_active,
                size: 20,),
            ),
                label: 'Alerts',
                backgroundColor: Colors.white),
          ],
          backgroundColor: black,
          currentIndex: _currentIndex,
          selectedItemColor: amber,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            color: amber,
            fontSize: 13
          ),
          unselectedLabelStyle: TextStyle(
            color: grey,
            fontSize: 9
          ),
          onTap: (val){
            setState(() {
              print(val);
              _currentIndex = val;
            });
          },
        ),
      ),
    );
  }
}
