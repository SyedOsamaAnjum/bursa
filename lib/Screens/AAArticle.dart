import 'dart:convert';

import 'package:bursa_app/Screens/PostDetailScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../Constant.dart';
import 'NewsDetailScreen.dart';
import 'package:http/http.dart' as http;

class AAArticle extends StatefulWidget {

  static const id = 'AAArticle';
  final AccessToken;

  AAArticle({this.AccessToken});
  @override
  _AAArticleState createState() => _AAArticleState();
}

class _AAArticleState extends State<AAArticle> {


  @override
  void initState() {
    setState(() {
      getData();
    });
    super.initState();
  }
  //static String url = 'https://bursa.8mindsolutions.com/api';
  static JsonDecoder _decoder = JsonDecoder();
  //String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();
  List<dynamic> postNews;

  Future<List<String>> getData() {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.AccessToken}'
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

          Map data =  postNews[index]['user'];
          List userName = data.values.toList();
          print(userName);
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
                    return PostDetailScreen(name: postNews[index]["name"],content: postNews[index]["text"], imageURL: postNews[index]["fileName"],videoURL: postNews[index]['videoUrl'],);
                  }));
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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(postNews[index]["text"],
                    overflow: TextOverflow.fade,
                    style: textStyle.copyWith(
                        fontSize: 12,
                        color: white
                    ),),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Posted By: ${userName[1]}",
                    overflow: TextOverflow.fade,
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

class NewsFeedTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 5
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.4)
            )
          ]
      ),
      child: ListTile(
        onTap: (){
          Navigator.pushNamed(context, NewsDetailScreen.id);
        },
        isThreeLine: true,
        leading: Container(
          width: 100,
          height: MediaQuery.of(context).size.height,
          color: Colors.red,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AA Article',
              style: textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: amber,
                  fontSize: 18
              ),
            ),
          ],
        ),
        subtitle: Text('Descdsdsdsdsdcxccfvkvkvk;df;dkf;dc;kc;ldkc;dkc;kdcokdpkcpdkckscpsc',
          style: textStyle.copyWith(
              fontSize: 12,
              color: white
          ),),
      ),
    );
  }
}