import 'dart:convert';

import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/LogReg/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'AdminPanel/AdminNavigationBar.dart';
import 'AgentPanel/AgentBottomNavigationBar.dart';
import 'BottomNavigation/BottomNavigationScreen.dart';

class SplashScreen extends StatefulWidget {

  static const id = 'SplashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{


  AnimationController animationController;
  Animation animation;

  String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQxIiwibmJmIjoxNjAxNjM5OTM0LCJleHAiOjE2MDIyNDQ3MzQsImlhdCI6MTYwMTYzOTkzNH0.7-unzW0aM2UlvaKSu7yjS6da-iQ3XeLUswZPB321EoU';
  String newToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2)
    );
    animationController.forward();
    animationController.addListener(() async{
      double v = animationController.value;
      setState(() {
        print(v);
      });
      if(animationController.value == 1){

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String email = prefs.getString("email");
        String pass = prefs.getString("pass");
        print(email);
        print(pass);

        if(email != null && pass!=null){


          Map data = {
            "Email": email,
            "Password": pass,
          };

          Map<String,String> header ={
            'Content-type':'application/json',
            'Accept':'application/json',
            'Authorization':'$Token'
          };
          var sb = jsonEncode(data);

          String u = "$url" + "/users/authenticate";

          http.post(u,body: sb,headers: header).then((value) {
            var statusCode = value.statusCode;
            print("415$statusCode");


            if(statusCode == 200){
              Map data = jsonDecode(value.body);
              setState(() {
                newToken = data['token'];
              });
              Map<String,String> newHeader ={
                'Content-type':'application/json',
                'Accept':'application/json',
                'Authorization':'$newToken'
              };

              String ul = "$url"+"/users/getuserdetails";
              http.get(ul,headers: newHeader).then((value){

                if(value.statusCode == 200){



                  Map userData = jsonDecode(value.body);
                  int userType = userData['userType'];
                  int userId = userData['id'];
                  int agentId = userData['agentId'];
                  String email = userData['email'];
                  String pic = userData['profilePictureFile'];
                                    if(userType == 2){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return BottomNavigationScreen(userId: userId, agentId: agentId,AcessToken: newToken,email: email,pic: pic,);
                    }));
                  }else if( userType == 1){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return AgentBottomNavigation(userId: userId, agentId: agentId,AcessToken: newToken,);
                    }));
                  }else if( userType == 0){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return AdminNavigationBar(adminId: userId,accessToken: newToken,);
                    }));
                  }
                }else{
                  Navigator.pushNamed(context, LoginScreen.id);
                }
              });

            }else{
              Navigator.pushNamed(context, LoginScreen.id);
            }
          });
        }else{
          Navigator.pushNamed(context, LoginScreen.id);
      }}
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
//            color: black
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                  height: 180,
                  width: 150,
                  child: Image.asset('assets/images/AALOGO.png',
                  fit: BoxFit.cover,),
              )
              )
          ],
        ),
      ),
    );
  }
}
