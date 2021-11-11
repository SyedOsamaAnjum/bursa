import 'package:bursa_app/Screens/AdminPanel/ManageEvent.dart';
import 'package:bursa_app/Screens/AdminPanel/ManageNews.dart';
import 'package:bursa_app/Screens/AgentPanel/AgentDashboard.dart';
import 'package:bursa_app/Screens/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Constant.dart';

class AgentBottomNavigation extends StatefulWidget {

  static const id = 'AgentBottomNavigation';

  final userId;
  final agentId;
  final AcessToken;
  final email;
  final pic;
  final jDate;
  final userName;
  final password;

  AgentBottomNavigation({this.agentId,this.userId,this.AcessToken, this.email, this.pic, this.jDate, this.userName, this.password});

  @override
  _AgentBottomNavigationState createState() => _AgentBottomNavigationState();
}

class _AgentBottomNavigationState extends State<AgentBottomNavigation> {
  int _currentIndex = 0;

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

    print("1. ${widget.jDate}");
    print("2. ${widget.userName}");
    print("3. ${widget.email}");
    print(widget.pic);

    List<Widget> screens = [
      AgentDashboard(userId: widget.userId,AccessToken: widget.AcessToken,),
      // ManageEvent(),
      ManageNews(token: widget.AcessToken,currentId: widget.userId,),
      ProfileScreen(AccessToken: widget.AcessToken, jDate: widget.jDate, pic: widget.pic,username: widget.userName, email: widget.email)
    ];

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.sms),
              title: Text('Chat'),
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.newspaper),
              title: Text('Article'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
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

