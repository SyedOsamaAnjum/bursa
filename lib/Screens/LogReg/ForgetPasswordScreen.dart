import 'package:bursa_app/Screens/LogReg/ResetPasswordScreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../Constant.dart';

class ForgetPasswordScreen extends StatefulWidget {

  static const id = 'ForgetPasswordScreen';
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  TextEditingController emailText = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return Scaffold(
//      backgroundColor: black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: media.height * 0.3,
            ),
            Text('Forget Password',
              style: textStyle.copyWith(
                  fontSize: 20,
                  color: white
              ),),
            SizedBox(
              height: 30,
            ),
            Theme(
              data: ThemeData(
                  primaryColor: amber
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: emailText,
                  style: textStyle.copyWith(
                      fontSize: 16,
                      color: white
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: white
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: white
                        )
                    ),
                    prefixIcon: Icon(Icons.email,
                      color: amber,),
                    hintText: 'Email Address',
                    hintStyle: textStyle.copyWith(
                        fontSize: 16,
                        color: amber
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 180,
              height: 40,
              decoration: BoxDecoration(
                  color: amber,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Builder(
                builder: (BuildContext context) {
                return FlatButton(
                    onPressed: (){


                      Map data = {
                        "email": emailText.text,
                      };

                      Map<String,String> header ={
                        'Content-type':'application/json',
                        'Accept':'application/json',
                        // 'Authorization':'$Token'
                      };
                      var sb = convert.jsonEncode(data);

                      String u = "$url" + "/users/GenerateOTP";

                      http.post(u,body: sb,headers: header).then((value) {

                        print(value.statusCode);

                        if(value.statusCode >= 200 && value.statusCode < 300){

                          emailText.clear();
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Email has been sent to your account')));
                        }


                      });
                    },
                    child: Text('Send Email',
                      style: textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),));
              },),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
