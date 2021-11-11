
import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/LogReg/LoginScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Constant.dart';
import 'ChatScreen.dart';


class AgentDashboard extends StatefulWidget {

  static const id = 'AgentDashboard';

  final userId;
  final agentId;
  final AccessToken;

  AgentDashboard({this.userId,this.agentId,this.AccessToken});

  @override
  _AgentDashboardState createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard> {

  @override
  void initState() {
    setState(() {
      getData();
      print(widget.AccessToken);
    });
    super.initState();
  }
  //static String url = 'https://bursa.8mindsolutions.com/api';
  static JsonDecoder _decoder = JsonDecoder();
  //String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();
  List<dynamic> userList;

  Future<List<String>> getData() {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.AccessToken}'
    };

    String u = "$url"+"/users/";
    return http.get(u,headers: header).then((response){
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {

        List<dynamic> user= _decoder.convert(response.body);
//        print(user);

        print(widget.userId);
        userList = user.where((element) => element['agentId'] == widget.userId).toList();
       print(userList);
        // print(userList);
      });

      return [];
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('DashBoard',
          style: textStyle.copyWith(
            fontSize: 18,
            color: amber,
          ),),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new,
              color: amber,),
            onPressed: () async{

              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: userList == null ? 0 : userList.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            margin: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10
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
              trailing: RaisedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ChatScreen(currentUser: widget.userId,agentId: userList[index]["id"],);
                  }));
                },
                color: amber,
                child: Text('Chat',
                  style: textStyle.copyWith(
                      fontSize: 15,
                      color: black
                  ),),
              ),
              leading: Text(userList[index]["username"],
                style: textStyle.copyWith(
                    fontSize: 18,
                    color: amber
                ),),
            ),
          );
        },
      ),
    );
  }
}

class ClientTile extends StatefulWidget {
  @override
  _ClientTileState createState() => _ClientTileState();
}

class _ClientTileState extends State<ClientTile> {
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
        leading: Text('Client Name',
          style: textStyle.copyWith(
            fontSize: 18,
            color: amber,
          ),
        ),
        trailing: RaisedButton(
          color: amber,
          onPressed: (){
            Navigator.pushNamed(context, ChatScreen.id);
          },
          child: Text('Chat',
            style: textStyle.copyWith(
              fontSize: 15,
              color: black,
            ),),
        ),
      ),
    );
  }
}
