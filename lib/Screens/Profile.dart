import 'dart:convert';
import 'dart:io';
import 'package:timer_button/timer_button.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../Constant.dart';

class ProfileScreen extends StatefulWidget {

  static const id = 'ProfileScreen';

  final AccessToken;
  final pic;
  final email;
  final jDate;
  final username;
  final password;

  ProfileScreen({this.AccessToken,this.pic,this.email, this.jDate, this.username, this.password});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  File _img;
  String _imgPath = '';
  static Dio dio = Dio();

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();

  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();

  Future getImage1() async {

    var Img = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imgPath = Img.path;
      _img = Img;
    });
  }

  String password;

  @override
  void initState() {
    // TODO: implement initState

    print(widget.password);
    print(widget.username);
    print(widget.jDate);
    print(widget.email);
    print(widget.pic);
    setState(() {
      oldPassword.text = '*******';
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: black,
        title: Text('Profile',
          style: textStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: white
          ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: grey,
                  ),
                  child: _img == null? widget.pic == null? Icon(Icons.add_photo_alternate,
                    color: amber,): Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage('https://bursa.8mindsolutions.com/resources/images/${widget.pic}'),
                            fit: BoxFit.cover)
                    ),
                  ):
                  Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: FileImage(_img),
                          fit: BoxFit.cover)
                  ),
                )
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                  onPressed: (){
                    getImage1();
              },
                color: amber,
              child: Text('Upload Profile Picture',
              style: textStyle.copyWith(
                fontSize: 14,
                color: black
              ),),
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
                    readOnly: true,
                    style: textStyle.copyWith(fontSize: 16, color: white),
                    // controller: ,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: white)),
                      prefixIcon: Icon(
                        Icons.person,
                        color: amber,
                      ),
                      hintText: '${widget.username}',
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
                    readOnly: true,
                    style: textStyle.copyWith(fontSize: 16, color: white),
                    // controller: ,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: white)),
                      prefixIcon: Icon(
                        Icons.alternate_email,
                        color: amber,
                      ),
                      hintText: '${widget.email}',
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
                    readOnly: true,
                    style: textStyle.copyWith(fontSize: 16, color: white),
                    // controller: ,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: white)),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: amber,
                      ),
                      hintText: '${widget.jDate}',
                      hintStyle: textStyle.copyWith(fontSize: 16, color: amber),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Builder(
                builder: (context){
                  return RaisedButton(
                    onPressed: ()async{

                      var headers = {
                        'Authorization': 'Bearer ${widget.AccessToken}'
                      };
                      var request = http.MultipartRequest('POST', Uri.parse('$url/users/UploadProfilePic'));
                      request.files.add(await http.MultipartFile.fromPath('file', '${_img.path}'));
                      request.headers.addAll(headers);

                      http.StreamedResponse response = await request.send();

                      print(response.statusCode);
                      if (response.statusCode == 200) {

                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Profile Updated')));
                      }
                      else {
                        print(response.reasonPhrase);
                      }

                    },
                    child: Text('Update',
                      style: textStyle.copyWith(
                          fontSize: 15,
                          color: black
                      ),),
                    color: amber,
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Theme(
                data: ThemeData(primaryColor: amber),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    obscureText: false,
                    readOnly: true,
                    style: textStyle.copyWith(fontSize: 16, color: white),
                    controller: oldPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: white)),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: amber,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye_outlined,
                        color: amber,),
                        onPressed: () {
                          if(oldPassword.text == widget.password){
                            setState(() {
                              oldPassword.text = '*******';
                            });
                          }
                          else{
                            setState(() {
                              oldPassword.text = widget.password;
                            });
                          }
                        },

                      ),
                      hintText: 'Old Password',
                      hintStyle: textStyle.copyWith(fontSize: 16, color: amber),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),Theme(
                data: ThemeData(primaryColor: amber),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    obscureText: true,
                    style: textStyle.copyWith(fontSize: 16, color: white),
                    controller: newPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: white)),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: amber,
                      ),
                      hintText: 'New Password',
                      hintStyle: textStyle.copyWith(fontSize: 16, color: amber),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Builder(
                builder: (context){
                  return RaisedButton(onPressed: (){

                    String otpUrl = "$url" + "/users/GeneratePasswordOTP?email=${widget.email}";
                    print(otpUrl);

                    http.post(otpUrl).then((value) {
                      print(value.statusCode);

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

                                            String otpUrl = "$url" + "/users/GeneratePasswordOTP?email=${widget.email}";

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
                                          String u = "$url"+"/users/VerifyPasswordOTP?email=${widget.email}&otp=$otp";
                                          print(u);

                                          http.post(u).then((value) {
                                            print("Verify : ${value.statusCode}");

                                            if(value.statusCode>= 200 && value.statusCode<300){

                                              Map<String,String> header ={
                                                'Content-type':'application/json',
                                                'Accept':'application/json',
                                                //  'Authorization':'${widget.token}'
                                              };

                                              Map data = {
                                                "email": widget.email,
                                                "OldPassword": widget.password,
                                                "NewPassword": newPassword.text
                                              };

                                              String sb = jsonEncode(data);

                                              String lur = "$url"+"/users/ResetPassword";

                                              http.post(lur, headers: header, body: sb).then((value) {

                                                print(value.statusCode);

                                                if(value.statusCode >=200 && value.statusCode <300){

                                                  oldPassword.clear();
                                                  newPassword.clear();
                                                  Navigator.pop(context);

                                                }
                                              });
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
                    child: Text('Change Password',
                      style: textStyle.copyWith(
                          fontSize: 15,
                          color: black
                      ),),
                    color: amber,
                  );
                },
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
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
