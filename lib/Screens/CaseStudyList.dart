import 'dart:convert';

import 'package:bursa_app/Screens/CaseStudyScreen.dart';
import 'package:bursa_app/Screens/PostDetailScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../Constant.dart';
import 'NewsDetailScreen.dart';
import 'package:http/http.dart' as http;

class AACaseStudy extends StatefulWidget {

  static const id = 'AACaseStudy';

  final accessToken;

  AACaseStudy({this.accessToken});
  @override
  _AACaseStudyState createState() => _AACaseStudyState();
}

class _AACaseStudyState extends State<AACaseStudy> {

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

    print(widget.accessToken);

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.accessToken}'
    };

    String u = "$url"+"/CaseStudy/GetCaseStudies";
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
        title: Text('Case Study',
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
                  return CaseStudyScreen(name: postNews[index]["title"],content: postNews[index]["link"], imageUrl: postNews[index]["image"],);
                }));
              },
              // isThreeLine: true,
              leading: postNews[index]['image']== null?  Container(
                width: 100,
                height: MediaQuery.of(context).size.height,
                child: Text('No Image'),
              ): Container(
                width: 100,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage("https://bursa.8mindsolutions.com/resources/CaseStudy/${postNews[index]['image']}"),
                        fit: BoxFit.cover
                    )
                ),
              ),
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

