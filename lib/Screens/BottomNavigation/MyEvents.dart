import 'dart:convert';

import '../../Constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../EventDetailScreen.dart';


class MyEvents extends StatefulWidget {

  static const id = 'MyEvents';

  final token;
  final email;

  MyEvents({this.token, this.email});

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  @override
  void initState() {
    setState(() {

      getEvents();
    });
    super.initState();
  }

  List<dynamic> userList;
  List<dynamic> eventsList;


  Future<List<String>> getEvents() {
    print(widget.token);

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.token}'
    };

    String u = "$url"+"/event/GetUserEvents";
    return http.get(u,headers: header).then((response){
      int statusCode = response.statusCode;
      print(statusCode);
      setState(() {

        userList= jsonDecode(response.body);

      });

      return [];
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: black,
        title: Text('AA Team Event',
          style: textStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: white
          ),),
      ),
      body: ListView.builder(
        itemCount: userList == null ? 0 : userList.length,
        itemBuilder: (BuildContext context, int index){

          Map data = userList[index]['event'];
          eventsList = data.values.toList();

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


                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return EventDetailScreen(
                    eventId: eventsList[0],
                    imageURL: eventsList[6],
                    videoURL: eventsList[7],
                    name: eventsList[1],
                    content: eventsList[5],
                    author: eventsList[4].toString(),
                    startDate: eventsList[2],
                    endDate: eventsList[3],
                    token: widget.token,
                    email: widget.email,
                  );
                }));
              },
              trailing: Text(
                "Price: ${eventsList[4].toString()}",
                style: textStyle.copyWith(
                    color: amber
                ),),
              title: Text(eventsList[1],
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
                  Text("Start Date : ${eventsList[2]}",
                    style: textStyle.copyWith(
                        fontSize: 12,
                        color: amber
                    ),),
                  Text("End Date : ${eventsList[3]}",
                    style: textStyle.copyWith(
                        fontSize: 12,
                        color: amber
                    ),),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
