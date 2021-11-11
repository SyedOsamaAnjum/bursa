import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/AdminPanel/AdminDashboard.dart';
import 'package:bursa_app/Screens/AdminPanel/AgentApprovalScreen.dart';
import 'package:bursa_app/Screens/AdminPanel/CaseStudy.dart';
import 'package:bursa_app/Screens/AdminPanel/ManageEvent.dart';
import 'package:bursa_app/Screens/AdminPanel/ManageNews.dart';
import 'package:bursa_app/Screens/AdminPanel/UploadVideo.dart';
import 'package:bursa_app/eventicon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'BannerTab.dart';

class AdminNavigationBar extends StatefulWidget {

  static const id = 'AdminNavigationBar';

  final adminId;
  final accessToken;

  AdminNavigationBar({this.adminId,this.accessToken});

  @override
  _AdminNavigationBarState createState() => _AdminNavigationBarState();
}

class _AdminNavigationBarState extends State<AdminNavigationBar> {

  int _currentIndex = 0;

  Future<bool> onWillPop()async{
    return await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Do You To Exit The App?',
              style: TextStyle(
                fontSize: 18,
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


    List<Widget> screens = [
      AdminDashboard(token: widget.accessToken,),
      AgentApprovalScreen(token: widget.accessToken,),
      ManageEvent(token: widget.accessToken, currentUser: widget.adminId,),
      ManageNews(token: widget.accessToken,currentId: widget.adminId ),
      BannerTab(token: widget.accessToken, currentId: widget.adminId,),
      CaseStudy(token: widget.accessToken, currentId: widget.adminId,),
      UploadVideo(token: widget.accessToken,),
    ];

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Agent'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event),
                title: Text('Event'),
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.newspaper),
                title: Text('Posts'),
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.newspaper),
                title: Text('Banner'),
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.newspaper),
                title: Text('Case Study'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.videocam),
                title: Text('Upload Video'),
              ),
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
              _currentIndex = val;
            });
          },
        ),
      ),
    );
  }
}
