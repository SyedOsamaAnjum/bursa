import 'dart:convert';

import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/AdminPanel/AdminNavigationBar.dart';
import 'package:bursa_app/Screens/AgentPanel/AgentBottomNavigationBar.dart';
import 'package:bursa_app/Screens/AgentPanel/AgentDashboard.dart';
import 'package:bursa_app/Screens/BottomNavigation/BottomNavigationScreen.dart';
import 'package:bursa_app/Screens/LogReg/ForgetPasswordScreen.dart';
import 'package:bursa_app/Screens/LogReg/RegisterationScreen.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();




  String newToken;


  static convert.JsonDecoder _decoder = new convert.JsonDecoder();

  static Dio dio = Dio();

  var accessTokenForGoogle;


  Future<bool> saveUserIds({String email, String pass}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("pass", pass);
    return prefs.commit();
  }
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      // you can add extras if you require
    ],
  );

  void login() async {


    _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
      GoogleSignInAuthentication auth = await acc.authentication;
      print(acc.id);
      print(acc.email);
      print(acc.displayName);
      print(acc.photoUrl);

      acc.authentication.then((GoogleSignInAuthentication auth) async {
        print(auth.idToken);
        print(auth.accessToken);
      });
    });
  }



  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();

  void facebook() async {

    final facebookLoginResult = await facebookLogin.logIn(['email']);
    print(facebookLoginResult.status);

    print(facebookLoginResult.accessToken);
    print(facebookLoginResult.accessToken.token);
    print(facebookLoginResult.accessToken.expires);
    print(facebookLoginResult.accessToken.permissions);
    print(facebookLoginResult.accessToken.userId);
    print(facebookLoginResult.accessToken.isValid());

    print(facebookLoginResult.errorMessage);
    print(facebookLoginResult.status);

    final token = facebookLoginResult.accessToken.token;

    /// for profile details also use the below code
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
    final profile = json.decode(graphResponse.body);
    print(profile);
    /*
    from profile you will get the below params
    {
     "name": "Iiro Krankka",
     "first_name": "Iiro",
     "last_name": "Krankka",
     "email": "iiro.krankka\u0040gmail.com",
     "id": "<user id here>"
    }
   */
  }


  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: media.height * 0.3,
            ),
            Text(
              'LOG IN',
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
                  controller: emailText,
                  style: textStyle.copyWith(fontSize: 16, color: white),
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
                  controller: passwordText,
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
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ForgetPasswordScreen.id);
                    },
                    child: Text(
                      'Forgot Password ?',
                      style: textStyle.copyWith(fontSize: 14, color: white),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                  color: amber, borderRadius: BorderRadius.circular(30)),
              child: Builder(
                builder: (context){
                  return FlatButton(
                    onPressed: () {

                      Map data = {
                        "Email": emailText.text,
                        "Password": passwordText.text,
                      };

                      Map<String,String> header ={
                        'Content-type':'application/json',
                        'Accept':'application/json',
                        // 'Authorization':'$Token'
                      };
                      var sb = convert.jsonEncode(data);

                      String u = "$url"+"/users/authenticate";

                      http.post(u,body: sb,headers: header).then((value) {
                        var statusCode = value.statusCode;
                        print(ResponseBody);
                        print(value.body);
                       print(statusCode);


                        if(statusCode == 200){
                          Map data = _decoder.convert(value.body);
                          setState(() {
                            newToken = data['token'];
                          });
                          Map<String,String> newHeader ={
                            'Content-type':'application/json',
                            'Accept':'application/json',
                            'Authorization':'$newToken'
                          };

                          String ul = "$url"+"/users/getuserdetails";
                          http.get(ul,headers: newHeader).then((value){

                           if(value.statusCode == 200){
                             Scaffold.of(context).showSnackBar(
                                 SnackBar(content: Text('Login Successful')));

                             saveUserIds(email: emailText.text, pass: passwordText.text);
                             Map userData = _decoder.convert(value.body);
                             print("User$userData");
                             int userType = userData['userType'];
                             int userId = userData['id'];
                             int agentId = userData['agentId'];
                             String email = userData['email'];
                             String pic = userData['profilePictureFile'];
                             String jDate = userData['joiningDate'];
                             String userName = userData['username'];
                             String password = userData['password'];
                             print(userId);
                             print(userName);
                             print(jDate);
                             print(agentId);
                             print(email);
                             print(pic);
                             print(newToken);
                             if(userType == 2){
                               Navigator.push(context, MaterialPageRoute(builder: (context){
                                 return BottomNavigationScreen(userId: userId, userName: userName, agentId: agentId,AcessToken: newToken,email: email,pic: pic, jDate: jDate, password: password,);
                               }));
                             }else if( userType == 1){
                               Navigator.push(context, MaterialPageRoute(builder: (context){
                                 return AgentBottomNavigation(userId: userId, agentId: agentId,AcessToken: newToken,userName: userName,email: email,pic: pic, jDate: jDate, password: password,);
                               }));
                             }else if( userType == 0){
                               Navigator.push(context, MaterialPageRoute(builder: (context){
                                 return AdminNavigationBar(adminId: userId,accessToken: newToken,);
                               }));
                             }
                           }else{
                             Scaffold.of(context).showSnackBar(
                                 SnackBar(content: Text('Login Failed')));
                           }
                          });

                        }else{
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Login Failed')));
                        }

//                    print(statusCode);
//                    print(value.data.toString());
                      });
                    },
                    child: Text(
                      'LOG IN',
                      style: textStyle.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(builder: (_){
                  return GestureDetector(
                    onTap: () {
                      _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
                        GoogleSignInAuthentication auth = await acc.authentication;
                        print(acc.id);
                        print(acc.email);
                        print(acc.displayName);
                        print(acc.photoUrl);

                        acc.authentication.then((GoogleSignInAuthentication auth) async {

                          var headers = {
                            'Content-Type': 'application/json'
                          };

                          Map data = {
                            "AccessToken": "${auth.accessToken}"
                          };

                          String sb = jsonEncode(data);
                          http.post('$url/users/authenticateGoogle', headers: headers, body: sb).then((value) {

                            Map data = jsonDecode(value.body);
                            List x = data.values.toList();

                            Map<String,String> newHeader ={
                              'Content-type':'application/json',
                              'Accept':'application/json',
                              'Authorization':'${x[1]}'
                            };

                            String ul = "$url"+"/users/getuserdetails";
                            http.get(ul,headers: newHeader).then((value){

                              if(value.statusCode == 200){

                                saveUserIds(email: emailText.text, pass: passwordText.text);
                                Map userData = _decoder.convert(value.body);
                                print("User$userData");
                                int userType = userData['userType'];
                                int userId = userData['id'];
                                int agentId = userData['agentId'];
                                String email = userData['email'];
                                String pic = userData['profilePictureFile'];
                                String jDate = userData['joiningDate'];
                                String userName = userData['username'];
                                print(userId);
                                print(userName);
                                print(jDate);
                                print(agentId);
                                print(email);
                                print(pic);
                                print(newToken);
                                if(userType == 2){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return BottomNavigationScreen(userId: userId, userName: userName, agentId: agentId,AcessToken: x[1],email: email,pic: pic, jDate: jDate,);
                                  }));
                                }else if( userType == 1){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return AgentBottomNavigation(userId: userId, agentId: agentId,AcessToken: x[1],userName: userName,email: email,pic: pic, jDate: jDate,);
                                  }));
                                }else if( userType == 0){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return AdminNavigationBar(adminId: userId,accessToken: x[1],);
                                  }));
                                }
                              }
                            });



                          });
                        });


                        // Navigator.pushNamed(context, BottomNavigationScreen.id);
                      });},
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: white,
                      ),
                      child: Icon(
                        EvaIcons.google,
                        color: Colors.red,
                      ),
                    ),
                  );
                }),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async{

                    await facebookLogin.logIn(['email']).then((value) async{

                      print("${value.accessToken.token.characters}");
                      // final graphResponse = await http.get(
                      //     'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${value.accessToken.token}');
                      // final profile = json.decode(graphResponse.body);
                      // print(profile);

                      var headers = {
                        'Content-Type': 'application/json'
                      };

                      Map data = {
                        "AccessToken": "${value.accessToken.token}"
                      };

                      String sb = jsonEncode(data);
                      http.post(Uri.parse('$url'+'/users/authenticateFacebook'), headers: headers, body: sb).then((value) {

                        print(value.body);
                        Map data = jsonDecode(value.body);
                        List x = data.values.toList();

                        Map<String,String> newHeader ={
                          'Content-type':'application/json',
                          'Accept':'application/json',
                          'Authorization':'${x[1]}'
                        };

                        String ul = "$url"+"/users/getuserdetails";
                        http.get(ul,headers: newHeader).then((value){

                          if(value.statusCode == 200){

                            saveUserIds(email: emailText.text, pass: passwordText.text);
                            Map userData = _decoder.convert(value.body);
                            print("User$userData");
                            int userType = userData['userType'];
                            int userId = userData['id'];
                            int agentId = userData['agentId'];
                            String email = userData['email'];
                            String pic = userData['profilePictureFile'];
                            String jDate = userData['joiningDate'];
                            String userName = userData['username'];


                            if(userType == 2){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return BottomNavigationScreen(userId: userId, userName: userName, agentId: agentId,AcessToken: x[1],email: email,pic: pic, jDate: jDate,);
                              }));
                            }else if( userType == 1){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return AgentBottomNavigation(userId: userId, agentId: agentId,AcessToken: x[1],userName: userName,email: email,pic: pic, jDate: jDate,);
                              }));
                            }else if( userType == 0){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return AdminNavigationBar(adminId: userId,accessToken: x[1],);
                              }));
                            }
                          }
                        });
                      });

                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xee2F76DA),
                    ),
                    child: Icon(
                      EvaIcons.facebook,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: textStyle.copyWith(fontSize: 16, color: white),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  child: Text(
                    'SIGN UP',
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



class CustomWebView extends StatefulWidget {
  final String selectedUrl;

  CustomWebView({this.selectedUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("#access_token")) {
        succeed(url);
      }

      if (url.contains(
          "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
        denied();
      }
    });
  }

  denied() {
    Navigator.pop(context);
  }

  succeed(String url) {
    var params = url.split("access_token=");

    var endparam = params[1].split("&");

    Navigator.pop(context, endparam[0]);
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: widget.selectedUrl,
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(66, 103, 178, 1),
          title: new Text("Facebook login"),
        ));
  }
}