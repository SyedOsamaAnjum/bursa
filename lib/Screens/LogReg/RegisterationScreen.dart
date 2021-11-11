import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/LogReg/LoginScreen.dart';
import 'package:bursa_app/Services/Services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:timer_button/timer_button.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'RegistrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();


  static String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjAiLCJuYmYiOjE2MDE2MjYzNTEsImV4cCI6MTYwMjIzMTE1MSwiaWF0IjoxNjAxNjI2MzUxfQ.aZAf3X0fBbdAf3-Jk-VrQ7HtH9hW_2obf9YGCE4kw_M";
  static convert.JsonDecoder _decoder = new convert.JsonDecoder();

  static Dio dio = Dio();

  Map data;
  int userType;
  int valv = 0;

  Services services = Services();

  var individual = ['Admin','Agent', 'User',];

  String _currentSelectedValue;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
//      backgroundColor: black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: media.height * 0.15,
            ),
            Text(
              'SIGN UP',
              style: textStyle.copyWith(fontSize: 20, color: white),
            ),
            SizedBox(
              height: 30,
            ),
            Theme(
              data: ThemeData(primaryColor: amber),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: textStyle.copyWith(fontSize: 16, color: white),
                  controller: userName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: white)),
                    prefixIcon: Icon(
                      Icons.perm_identity,
                      color: amber,
                    ),
                    hintText: 'User Name',
                    hintStyle: textStyle.copyWith(fontSize: 16, color: amber),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Theme(
              data: ThemeData(primaryColor: amber),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelStyle: textStyle,
//                          contentPadding: EdgeInsets.all(10),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: amber)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: white)),
                        prefixIcon: Icon(
                          Icons.person,
                          color: amber,
                        ),
                      ),
                      isEmpty: _currentSelectedValue == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          iconEnabledColor: amber,
                          hint: Text(
                            'Select Category',
                            style:
                                textStyle.copyWith(fontSize: 16, color: amber),
                          ),
                          style: textStyle.copyWith(fontSize: 16, color: amber),
                          value: _currentSelectedValue,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _currentSelectedValue = newValue;
                              state.didChange(newValue);
                            });
                          },
                          items: individual.map((var value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Theme(
              data: ThemeData(primaryColor: amber),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: textStyle.copyWith(fontSize: 16, color: white),
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: white)),
                    prefixIcon: Icon(
                      Icons.email,
                      color: amber,
                    ),
                    hintText: 'Email Address',
                    hintStyle: textStyle.copyWith(fontSize: 16, color: amber),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Theme(
              data: ThemeData(primaryColor: amber),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  obscureText: true,
                  style: textStyle.copyWith(fontSize: 16, color: white),
                  controller: password,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: white)),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: amber,
                    ),
                    hintText: 'Password',
                    hintStyle: textStyle.copyWith(fontSize: 16, color: amber),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: amber,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: RadioListTile(
                  activeColor: black,
                    value: 1,
                    groupValue: 1,
                    onChanged: (value){

                    },
                title: Text('Free Member Ship')
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: 180,
              height: 40,
              decoration: BoxDecoration(
                  color: amber, borderRadius: BorderRadius.circular(30)),
              child: Builder(
                builder:(context){
                 return FlatButton(
                      onPressed: () async {
                        String otpUrl = "$url" + "/users/GenerateOTP?email=${email.text}";
                        print("Url: $otpUrl");

                        http.post(otpUrl).then((value) {
                          print(value.statusCode);
                          print(value.body);

                          if(value.statusCode >= 200 && value.statusCode < 300){

                            showDialog(context: context, builder: (context){
                              return Dialog(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 350,
                                  color: black,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              icon: Icon(Icons.close,
                                                color: grey,
                                                size: 30,),
                                              onPressed: (){
                                                setState(() {
                                                  Navigator.pop(context);
                                                });
                                              }),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text('Verify OTP',
                                        style: textStyle.copyWith(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18,
                                        ),),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('Please Enter Your Otp',
                                        textAlign: TextAlign.center,
                                        style: textStyle.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: TextFormField(
                                                controller: controller1,
                                                maxLengthEnforced: true,
                                                autofocus: true,
                                                maxLength: 1,
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                onFieldSubmitted: (v){
                                                  FocusScope.of(context).requestFocus(focus2);
                                                },
                                                decoration: InputDecoration(
                                                    helperStyle: TextStyle(
                                                        color: Colors.transparent
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                    )
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: TextFormField(
                                                focusNode: focus2,
                                                controller: controller2,
                                                maxLengthEnforced: true,
                                                maxLength: 1,
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                onFieldSubmitted: (v){
                                                  FocusScope.of(context).requestFocus(focus3);
                                                },
                                                decoration: InputDecoration(
                                                    helperStyle: TextStyle(
                                                        color: Colors.transparent
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                    )
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: TextFormField(
                                                focusNode: focus3,
                                                controller: controller3,
                                                maxLengthEnforced: true,
                                                maxLength: 1,
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                onFieldSubmitted: (v){
                                                  FocusScope.of(context).requestFocus(focus4);
                                                },
                                                decoration: InputDecoration(
                                                    helperStyle: TextStyle(
                                                        color: Colors.transparent
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                    )
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: TextField(
                                                focusNode: focus4,
                                                controller: controller4,
                                                maxLengthEnforced: true,
                                                maxLength: 1,
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                    helperStyle: TextStyle(
                                                        color: Colors.transparent
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            TimerButton(
                                              color: amber,
                                              label: 'Resend Otp',
                                              onPressed: (){

                                                String otpUrl = "$url" + "/users/GenerateOTP?email=${email.text}";

                                                http.post(otpUrl).then((value) {
                                                  print(value.statusCode);
                                                });
                                              },
                                              timeOutInSeconds: 120,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: 130,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: amber
                                                )
                                            ),
                                            child: FlatButton(onPressed: (){

                                              String otp = controller1.text+controller2.text+controller3.text+controller4.text;

                                              print(otp);
                                              String u = "$url"+"/users/VerifyOTP?email=${email.text}&otp=$otp";
                                              print(u);

                                              http.post(u).then((value) {
                                                print(value.statusCode);

                                                if(value.statusCode>= 200 && value.statusCode<300){

                                                  if(_currentSelectedValue == 'User'){
                                                    print("user");
                                                    setState(() {
                                                      userType = 2;
                                                    });
                                                  }
                                                  else if(_currentSelectedValue == 'Agent'){
                                                    print("agent");
                                                    setState(() {
                                                      userType = 1;
                                                    });
                                                  }else if(_currentSelectedValue == 'Admin'){
                                                    print("admin");
                                                    setState(() {
                                                      userType = 0;
                                                    });
                                                  }
                                                  dio.options.headers['content-Type'] = 'application/json';
                                                  dio.options.headers['authorizaton'] = "token $token";

                                                  data = {
                                                    "Username": userName.text,
                                                    "Email": email.text,
                                                    "Password": password.text,
                                                    "UserType": userType,
                                                  };

                                                  var sb = convert.jsonEncode(data);

                                                  String u = "$url" + "/users/";

                                                  dio.post(u, data: data).then((value) {
                                                    var statusCode = value.statusCode;
//                      Map otp = _decoder.convert(value.data);

                                                    print(statusCode);
                                                    if(value.statusCode >=200 && value.statusCode <300){

                                                      Navigator.popAndPushNamed(context, LoginScreen.id);
                                                    }
                                                  });
                                                  Scaffold.of(context).showSnackBar(
                                                      SnackBar(content: Text('User Registered')
                                                      )
                                                  );
                                                }
                                              });
                                            },
                                                child: Text('Verify Now',
                                                  style: textStyle.copyWith(
                                                      fontSize: 18,
                                                      color: white
                                                  ),)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }

                            );
                          } else{
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('User Already Registered')
                                )
                            );
                          }
                        });





                      },
                      child: Text(
                        'SIGN UP',
                        style: textStyle.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ));
                }
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: textStyle.copyWith(fontSize: 16, color: white),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  child: Text(
                    'SIGN IN',
                    style: textStyle.copyWith(fontSize: 18, color: amber),
                  ),
                ),
              ],
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
