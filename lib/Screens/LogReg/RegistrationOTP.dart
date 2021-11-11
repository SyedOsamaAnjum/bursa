import 'package:bursa_app/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationOTP extends StatefulWidget {

  static const id = 'RegistrationOTP';
  @override
  _RegistrationOTPState createState() => _RegistrationOTPState();
}

class _RegistrationOTPState extends State<RegistrationOTP> {

  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return Scaffold(
//      backgroundColor: black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: media.height * 0.35,
            ),
            Text('Verify',
            style: textStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: white
            ),),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Theme(
                      data: ThemeData(
                        primaryColor: amber
                      ),
                      child: TextFormField(
                        style: textStyle.copyWith(
                            fontSize: 16,
                            color: white
                        ),
//                    controller: controller1,
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
                                borderSide: BorderSide(
                                    color: white
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: white
                                )
                            )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 2,
                    child: Theme(
                      data: ThemeData(
                        primaryColor: amber
                      ),
                      child: TextFormField(
                        style: textStyle.copyWith(
                            fontSize: 16,
                            color: white
                        ),
                        focusNode: focus2,
//                    controller: controller2,
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
                              borderSide: BorderSide(
                                color: white
                              )
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: white
                              )
                            )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 2,
                    child: Theme(
                      data: ThemeData(
                        primaryColor: amber
                      ),
                      child: TextFormField(
                        style: textStyle.copyWith(
                            fontSize: 16,
                            color: white
                        ),
                        focusNode: focus3,
//                    controller: controller3,
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
                                borderSide: BorderSide(
                                    color: white
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: white
                                )
                            )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 2,
                    child: Theme(
                      data: ThemeData(
                        primaryColor: amber
                      ),
                      child: TextFormField(
                        style: textStyle.copyWith(
                            fontSize: 16,
                            color: white
                        ),
                        focusNode: focus4,
//                    controller: controller4,
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
                                borderSide: BorderSide(
                                    color: white
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: white
                                )
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 180,
              height: 40,
              decoration: BoxDecoration(
                  color: amber,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: FlatButton(
                  onPressed: (){
//                    Navigator.pushNamed(context, BottomNavigationScreen.id);
                  },
                  child: Text('Verify',
                    style: textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),)),
            ),
          ],
        ),
      ),
    );
  }
}
