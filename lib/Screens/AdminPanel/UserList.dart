
import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:bursa_app/Constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Constant.dart';
import 'AgentAssignScreen.dart';

class UserList extends StatefulWidget {

  static const id = 'UserList';

  final token;

  UserList({this.token});
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  @override
  void initState() {
    setState(() {
      getData();
    });
    super.initState();
  }
//  static String url = 'https://bursa.8mindsolutions.com/api';
  static JsonDecoder _decoder = JsonDecoder();
//  String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();
  List<dynamic> userList;

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
//        print(userList);
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
        centerTitle: true,
        title: Text('Manage User\'s',
          style: textStyle.copyWith(
            fontSize: 18,
            color: amber,
          ),),
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
                    return AgentAssignScreen(userId: userList[index]["id"],token: widget.token,);
                  }));
                },
                color: amber,
                child: Text("Assign Agent",
                  style: textStyle.copyWith(
                      fontSize: 15,
                      color: black
                  ),),
              ),
              title: Text(userList[index]["username"],
                style: textStyle.copyWith(
                    fontSize: 18,
                    color: amber
                ),),
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
      )
    );
  }
}

class UserTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
        onTap: (){
          Navigator.pushNamed(context, AgentAssignScreen.id);
        },
        trailing: RaisedButton(
          onPressed: (){

          },
          color: amber,
          child: Text('Assign Agent',
          style: textStyle.copyWith(
            fontSize: 15,
            color: black
          ),),
        ),
        leading: Text('User Name',
          style: textStyle.copyWith(
              fontSize: 18,
              color: amber
          ),),

      ),
    );
  }
}