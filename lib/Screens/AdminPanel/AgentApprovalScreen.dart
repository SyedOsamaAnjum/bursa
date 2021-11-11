import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:bursa_app/Constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Constant.dart';

class AgentApprovalScreen extends StatefulWidget {

  static const id = 'AgentApprovalScreen';

  final token;

  AgentApprovalScreen({this.token});
  @override
  _AgentApprovalScreenState createState() => _AgentApprovalScreenState();
}

class _AgentApprovalScreenState extends State<AgentApprovalScreen> {

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
       print(agentList);
        // print(userList);
      });

      return [];
    });

  }
  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: black,
          centerTitle: true,
          title: Text('Manage Agent\'s',
            style: textStyle.copyWith(
              fontSize: 18,
              color: amber,
            ),),
        ),
        body: ListView.builder(
          itemCount: agentList == null ? 0 : agentList.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
              width: media.width,
              margin: EdgeInsets.symmetric(
                  vertical: 5
              ),
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: grey.withOpacity(0.2)
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(agentList[index]["username"],
                          style: textStyle.copyWith(
                              color: white
                          ),),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Email: ${agentList[index]["email"]}",
                            style: textStyle.copyWith(
                                color: white,
                                fontSize: 12
                            )
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Join Date ${agentList[index]["joiningDate"]}",
                            style: textStyle.copyWith(
                                color: white,
                              fontSize: 12
                            )
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                height: 30,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: amber,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Center(
                                  child: Text('Accept',
                                    style: textStyle.copyWith(
                                        fontSize: 10,
                                        color: black
                                    ),),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                height: 30,
                                width: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: amber
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Center(
                                  child: Text('Decline',
                                    style: textStyle.copyWith(
                                        fontSize: 10,
                                        color: amber
                                    ),),
                                ),
                              ),
                            ),
                          ],
                        )
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


class PendingTile extends StatelessWidget {
  final media;

  PendingTile({this.media});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: media.width,
      margin: EdgeInsets.symmetric(
        vertical: 5
      ),
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: grey.withOpacity(0.2)
            ),
          ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text('Agent1',
                style: textStyle.copyWith(
                  color: white
                ),),
                // Text('1234444')
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                          color: amber,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: FlatButton(
                          onPressed: (){
                            // showDialog(context: context,
                            //     builder: (context){
                            //       return AlertDialogBox();
                            //     });
                          },
                          child: Text('Accept',
                            style: textStyle.copyWith(
                                fontSize: 15,
                                color: black
                            ),)),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: amber
                          ),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: FlatButton(onPressed: (){
                        // showDialog(context: context,
                        //     builder: (context){
                        //       return DeclineDialogBox();
                        //     });
                      },
                          child: Text('Decline',
                            style: textStyle.copyWith(
                                fontSize: 15,
                                color: amber
                            ),)),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}