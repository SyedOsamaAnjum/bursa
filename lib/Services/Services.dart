import 'dart:convert' as convert;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Services{

  static String url ="https://bursa.azurewebsites.net/api";
  static String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjAiLCJuYmYiOjE2MDE2MjYzNTEsImV4cCI6MTYwMjIzMTE1MSwiaWF0IjoxNjAxNjI2MzUxfQ.aZAf3X0fBbdAf3-Jk-VrQ7HtH9hW_2obf9YGCE4kw_M";
  static convert.JsonDecoder _decoder = new convert.JsonDecoder();

  static Dio dio = Dio();

  Map data ;

  Future<String> getDio(){

}

Future<String> postDio(){}

   Future<String> postReq({String password,String userName, String email, int userType,String token}){

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['authorizaton'] = "token $token";
print("yahan thk thek h");
    data = {
      "Username": userName,
      "Email":email,
      "Password":password,
      "UserType":"2",
    };

    var sb = convert.jsonEncode(data);

    String u = "$url"+"/users/";

    dio.post(u,data: data).then((value){
      print("Checking");
      print(value);
     var statusCode =  value.statusCode;
     print(statusCode);
     
    Map<String,dynamic> otp = _decoder.convert(value.data);
    print(otp.toString());
          return statusCode;
    });
  }
}

