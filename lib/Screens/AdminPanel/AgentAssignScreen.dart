import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:bursa_app/Constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Constant.dart';

class AgentAssignScreen extends StatefulWidget {

  static const id = 'AgentAssignScreen';
  final userId;
  final token;

  AgentAssignScreen({this.userId,this.token});
  @override
  _AgentAssignScreenState createState() => _AgentAssignScreenState();
}

class _AgentAssignScreenState extends State<AgentAssignScreen> {

  @override
  void initState() {
    setState(() {
      getData();
    });
    super.initState();
  }
 // static String url = 'https://bursa.8mindsolutions.com/api';
  static JsonDecoder _decoder = JsonDecoder();
  //String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();
  List<dynamic> agentList;

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

        List<dynamic> agent= _decoder.convert(response.body);
//        print(user);

        agentList = agent.where((element) => element['userType'] == 1).toList();
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
        title: Text('Agent List',
          style: textStyle.copyWith(
            fontSize: 18,
            color: amber,
          ),),
      ),
      body: ListView.builder(
        itemCount: agentList == null ? 0 : agentList.length,
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
              trailing: Builder(
                builder: (context){
                  return RaisedButton(
                    onPressed: (){
                      Map<String,String> header ={
                        'Content-type':'application/json',
                        'Accept':'application/json',
                        'Authorization':'${widget.token}'
                      };

                      String agentId = "${agentList[index]["id"]}";
                      String userId = widget.userId.toString();
                      print(agentId);
                      String u = "$url"+"/users/assignagent/$userId/$agentId";
                      http.post(u,headers: header).then((value) => {
                        if(value.statusCode == 200){
                          Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Agent assigned to the user.')))
                        }
                      });


                    },
                    color: amber,
                    child: Text('Select',
                      style: textStyle.copyWith(
                          fontSize: 15,
                          color: black
                      ),),
                  );
                },
              ),
              leading: Text(agentList[index]["username"],
                style: textStyle.copyWith(
                    fontSize: 18,
                    color: amber
                ),),
            ),
          );
        },
      )
    );
  }
}


class AgentTile extends StatefulWidget {
  @override
  _AgentTileState createState() => _AgentTileState();
}

class _AgentTileState extends State<AgentTile> {
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

        },
        trailing: RaisedButton(
          onPressed: (){

          },
          color: amber,
          child: Text('Assign',
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
