import 'dart:convert';

import 'package:bursa_app/Screens/VideoPlayerScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../Constant.dart';
import 'NewsDetailScreen.dart';
import 'package:http/http.dart' as http;

import '../Constant.dart';

class LearnScreen extends StatefulWidget {

  static const id = 'LearnScreen';
  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  void initState() {
    setState(() {
      getData();
    });
    super.initState();
  }

  static JsonDecoder _decoder = JsonDecoder();
  String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();
  List<dynamic> postNews;

  Future<List<String>> getData() {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'$Token'
    };

    String u = "$url"+"/videotutorials/";
    return http.get(u,headers: header).then((response){
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {
        postNews= _decoder.convert(response.body);
        print(postNews);
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
        title: Text('Learn',
          style: textStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: white
          ),),
      ),
      body: ListView.builder(
        itemCount: postNews == null ? 0 : postNews.length,
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
                  return VideoPlayerScreen(name: postNews[index]["title"],video: postNews[index]["fileName"],);
                },));
              },
              // isThreeLine: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(postNews[index]["title"],
                    style: textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: amber,
                        fontSize: 18
                    ),
                  ),
                ],
              ),
              subtitle: Text(postNews[index]["description"],
                overflow: TextOverflow.fade,
                style: textStyle.copyWith(
                    fontSize: 12,
                    color: white
                ),),
              // trailing: IconButton(
              //     icon: Icon(Icons.delete_outline,
              //       color: amber,),
              //     onPressed: (){
              //
              //       Map<String,String> header ={
              //         'Content-type':'application/json',
              //         'Accept':'application/json',
              //         // 'Authorization':'$Token'
              //       };
              //
              //       int id = postNews[index]["id"];
              //       print(id);
              //       String u = "$url"+"/articles/"+"$id";
              //       http.delete(url,headers: header).then((value) => {
              //         print(value.statusCode)
              //       });
              //     }),
            ),
          );
        },
      ),
    );
  }
}

class VideoContainer extends StatefulWidget {
  @override
  _VideoContainerState createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {

  @override
  void initState() {
    setState(() {
      getData();
    });
    super.initState();
  }
  static String url = 'https://bursa.8mindsolutions.com/api';
  static JsonDecoder _decoder = JsonDecoder();
  String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();
  List<dynamic> postNews;

  Future<List<String>> getData() {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'$Token'
    };

    String u = "$url"+"/articles/";
    return http.get(u,headers: header).then((response){
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {
        postNews= _decoder.convert(response.body);
        print(postNews);
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
        title: Text('AA Article',
          style: textStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: white
          ),),
      ),
      body: ListView.builder(
        itemCount: postNews == null ? 0 : postNews.length,
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
                // Navigator.pushNamed(context, NewsDetailScreen.id);
              },
              // isThreeLine: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(postNews[index]["name"],
                    style: textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: amber,
                        fontSize: 18
                    ),
                  ),
                ],
              ),
              subtitle: Text(postNews[index]["text"],
                overflow: TextOverflow.fade,
                style: textStyle.copyWith(
                    fontSize: 12,
                    color: white
                ),),
              trailing: IconButton(
                  icon: Icon(Icons.delete_outline,
                    color: amber,),
                  onPressed: (){

                    Map<String,String> header ={
                      'Content-type':'application/json',
                      'Accept':'application/json',
                      // 'Authorization':'$Token'
                    };

                    int id = postNews[index]["id"];
                    print(id);
                    String u = "$url"+"/articles/"+"$id";
                    http.delete(url,headers: header).then((value) => {
                      print(value.statusCode)
                    });
                  }),
            ),
          );
        },
      ),
    );
  }
}
