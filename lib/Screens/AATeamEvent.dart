import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Constant.dart';
import 'EventDetailScreen.dart';

class AATeamEvent extends StatefulWidget {

  static const id = 'AATeamEvent';

  final token;
  final email;


  AATeamEvent({this.token, this.email});

  @override
  _AATeamEventState createState() => _AATeamEventState();
}

class _AATeamEventState extends State<AATeamEvent> {

  @override
  void initState() {
    setState(() {

      getEvents();
    });
    super.initState();
  }

  static JsonDecoder _decoder = JsonDecoder();
  // String Token = token;
  static Dio dio = Dio();
  List<dynamic> userList;
  List<dynamic> eventsList;


  Future<List<String>> getEvents() {
    print(widget.token);

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.token}'
    };

    String u = "$url"+"/event";
    return http.get(u,headers: header).then((response){
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {

        eventsList= _decoder.convert(response.body);

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
        itemCount: eventsList == null ? 0 : eventsList.length,
        itemBuilder: (BuildContext context, int index){
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
                    eventId: eventsList[index]['id'],
                    imageURL: eventsList[index]['imageURL'],
                    videoURL: eventsList[index]['videoURL'],
                    name: eventsList[index]['name'],
                    content: eventsList[index]['description'],
                    author: eventsList[index]['price'].toString(),
                    startDate: eventsList[index]['startDate'],
                    endDate: eventsList[index]['endDate'],
                    token: widget.token,
                    email: widget.email,
                  );
                }));
              },
              trailing: Text(
                "Price: ${eventsList[index]['price'].toString()}",
              style: textStyle.copyWith(
                color: amber
              ),),
              title: Text(eventsList[index]['name'],
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
                  Text("Start Date : ${eventsList[index]['startDate']}",
                    style: textStyle.copyWith(
                        fontSize: 12,
                        color: amber
                    ),),
                  Text("End Date : ${eventsList[index]['endDate']}",
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

class TeamEventTile extends StatefulWidget {
  @override
  _TeamEventTileState createState() => _TeamEventTileState();
}

class _TeamEventTileState extends State<TeamEventTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,
      vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: grey.withOpacity(0.2))
        ]
      ),
      child: ListTile(
        title: Text('AA Team Event',
            style: textStyle.copyWith(
              fontSize: 18,
              color: amber,
            )),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('dsdsadsadsadsadsdsdsdsdsdsdsdwqqeqweqewdsadasdsadcvcvcxxxsdcdscsdcdscdsadawdsadsaascsadsacxcxcacas',
              style: textStyle.copyWith(
                  fontSize: 10,
                  color: grey
              ),),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Member Type: Gold',
                  style: textStyle.copyWith(
                      fontSize: 12,
                      color: grey
                  ),),
                Text('Date: 12/2/20202',
                  style: textStyle.copyWith(
                      fontSize: 12,
                      color: grey
                  ),),
              ],
            ),
          ],
        ),
        trailing: Text('Price: \$44',
        style: textStyle.copyWith(
          fontSize: 15,
          color: amber
        ),),
      ),
    );
  }
}


// ListTile(
// isThreeLine: true,
// leading: Text('Event Name',
// style: textStyle.copyWith(
// fontSize: 18,
// color: amber,
// ),),
// trailing: Text('Price \$400',
// style: textStyle.copyWith(
// fontSize: 13,
// color: amber
// )),
// subtitle: Column(
// children: [
// Text('dsdsadsadsadsadsadawdsadsaascsadsacxcxcacas',
// style: textStyle.copyWith(
// fontSize: 10,
// color: grey
// ),),
// SizedBox(
// height: 10,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text('Member Type: Gold',
// style: textStyle.copyWith(
// fontSize: 12,
// color: grey
// ),),
// Text('Date: 12/2/20202',
// style: textStyle.copyWith(
// fontSize: 12,
// color: grey
// ),),
// ],
// ),
//
// ],
// ),
// )

