import 'dart:convert';

import 'package:bursa_app/Screens/AgentPanel/ChatScreen.dart';
import 'package:bursa_app/Screens/AnnouncementGlobal.dart';
import 'package:bursa_app/Screens/AnnouncementMalaysia.dart';
import 'package:bursa_app/Screens/Announcements.dart';
import 'package:bursa_app/Screens/Entitlement.dart';
import 'package:bursa_app/Screens/LogReg/LoginScreen.dart';
import 'package:bursa_app/Screens/ResearchScreen.dart';
import 'package:bursa_app/Screens/Screener.dart';
import 'package:bursa_app/Screens/StockDetailScreen.dart';
import 'package:bursa_app/Services/URLlauncher.dart';
import 'package:bursa_app/model/StockSeries.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../Constant.dart';
import '../AAArticle.dart';
import '../AATeamEvent.dart';
import '../CaseStudyList.dart';
import '../LearnScreen.dart';
import '../NewsFeedScreen.dart';
import '../Profile.dart';
import 'BottomNavigationScreen.dart';
import 'MarketPlace.dart';
import 'MyEvents.dart';

class WatchList extends StatefulWidget {

  static const id = 'WatchList';
  final userId;
  final agentId;
  final AccessToken;
  final email;
  final pic;
  final jDate;
  final userName;
  final password;

  WatchList({this.userId,this.agentId,this.AccessToken,this.email,this.pic, this.jDate, this.userName, this.password});
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {

  Color color = black;


  static JsonDecoder _decoder = JsonDecoder();
  String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();

  Map data;
  final List<StockSeries> datax = [];

  List<dynamic> watchlist;
  Future<List<dynamic>> loadShares() {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.AccessToken}'
    };

    String u = "$url"+"/watchlist";
    return http
        .get(u,headers: header)
        .then((response) {
      print(response.statusCode);
      List<dynamic> watch = jsonDecode(response.body);
      
      
      watchlist = watch.where((element) => element['userId'] == widget.userId).toList();
//      Map article = articles[0];
//      Map source = article["source"];
//      print(source['name']);
//      print(article['title']);
      setState(() {
//        isLoading = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  ScrollController _scrollController = ScrollController();

  String x;
  Future<void> getT() {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.AccessToken}'
    };

    String u = "$url"+"/CaseStudy/TandC/2";
    http.get(u,headers: header).then((response) async{
      int StatusCode = response.statusCode;
      print(StatusCode);

      Map data = jsonDecode(response.body);
      List dataX = data.values.toList();
      setState(() {
        x= dataX[1];
      });

    });

  }


  @override
  void initState() {
    // TODO: implement initState
    getT();
    loadShares();
    super.initState();
  }
  List<dynamic> list;
  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: black,
        title: Text(
          'WatchList',
          style: textStyle.copyWith(
              fontSize: 18, fontWeight: FontWeight.bold, color: white),
        ),
      ),
      drawer: Container(
        width: media.width * 0.6,
        height: media.height,
        color: black,
        child: ListView(
          children: [
            Center(
                child: Container(
                  height: 180,
                  width: 150,
                  child: Image.asset('assets/images/AALOGO.png',
                    fit: BoxFit.cover,),
                )
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: grey,
                size: 20,
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ProfileScreen(AccessToken: widget.AccessToken,username: widget.userName, email: widget.email,pic: widget.pic, jDate: widget.jDate, password: widget.password,);
                }));
              },
              title: Text(
                'Profile',
                style: textStyle.copyWith(color: grey, fontSize: 15),
              ),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(
                Icons.remove_red_eye,
                color: grey,
                size: 20,
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return WatchList(userId: widget.userId,agentId: widget.agentId,AccessToken: widget.AccessToken,);
                }));
              },
              title: Text(
                'WatchList',
                style: textStyle.copyWith(color: grey, fontSize: 15),
              ),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, Entitlement.id);
              },
              leading: Icon(Icons.announcement, color: grey, size: 20),
              title: Text(
                'Entitlement',
                style: textStyle.copyWith(color: grey, fontSize: 15),
              ),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ResearchScreen.id);
              },
              leading: Icon(Icons.find_in_page, color: grey, size: 20),
              title: Text(
                'Research',
                style: textStyle.copyWith(color: grey, fontSize: 15),
              ),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(Icons.settings_overscan, color: grey, size: 20),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Screener(AccessToken: widget.AccessToken,);
                }));
              },
              title: Text(
                'Screener',
                style: textStyle.copyWith(color: grey, fontSize: 15),
              ),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(Icons.receipt, color: grey, size: 20),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context){
                  return AAArticle(AccessToken: widget.AccessToken,);
                }));
              },
              title: Text(
                'AA Article',
                style: textStyle.copyWith(color: grey, fontSize: 15),
              ),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(Icons.videocam, color: grey, size: 20),
              onTap: () {
                Navigator.pushNamed(context, LearnScreen.id);
              },
              title: Text(
                'Learn',
                style: textStyle.copyWith(color: grey, fontSize: 15),
              ),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(Icons.announcement, color: grey, size: 20),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AATeamEvent(token: widget.AccessToken, email: widget.email);
                }));
              },
              title: Text(
                'AA Team Event',
                style: textStyle.copyWith(color: grey, fontSize: 15),
              ),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              onTap: () {
                if(widget.agentId != null){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ChatScreen(currentUser: widget.userId,agentId: widget.agentId,AccessToken: widget.AccessToken,);
                  }));
                }else{
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('No Agent Assigned')));
                }
              },
              leading: Icon(
                EvaIcons.messageCircle,
                color: grey,
              ),
              title: Text(
                'Chat With Agent',
                style: textStyle.copyWith(color: grey, fontSize: 15),
              ),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(Icons.contacts, color: grey, size: 20),
              onTap: (){

                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return MyEvents(email: widget.email, token: widget.AccessToken,);
                }));
              },
              title: Text(
                'My Events',
                style: textStyle.copyWith(color: grey, fontSize: 15),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: media.width,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(10)),
              child: FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text('Terms And Condition'),
                            titleTextStyle: textStyle.copyWith(
                                fontSize: 18,
                                color: black
                            ),
                            content: Text(x),
                            contentTextStyle: textStyle.copyWith(
                                fontSize: 15,
                                color: grey
                            ),
                            actions: <Widget>[
                              RaisedButton(
                                color: amber,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                onPressed: (){

                                  print(widget.AccessToken);
                                  Navigator.push(context, MaterialPageRoute(builder: (_){
                                    return AACaseStudy(accessToken: widget.AccessToken,);
                                  }));
                                },
                                child: Text('Accept'),
                              ),
                              RaisedButton(
                                color: amber,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Text('Close'),)
                            ],
                          );
                        }
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.hammer,
                        color: white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'AA Case Study',
                        style: textStyle.copyWith(fontSize: 15, color: white),
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: media.width,
              height: 40,
              decoration: BoxDecoration(
                  color: Color(0xee2F76DA),
                  borderRadius: BorderRadius.circular(10)),
              child: FlatButton(
                  onPressed: () {
                    launchURL(url: "https://www.facebook.com/AATeam.My");
                  },
                  child: Row(
                    children: [
                      Icon(
                        EvaIcons.facebook,
                        color: white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Facebook',
                        style: textStyle.copyWith(fontSize: 15, color: white),
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: media.width,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: white),
              child: FlatButton(
                  onPressed: () {
                    launchURL(url: "https://www.instagram.com/aateammy/");
                  },
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.instagram,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Instagram',
                        style: textStyle.copyWith(
                            fontSize: 15, color: Colors.red),
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: media.width,
              height: 40,
              decoration: BoxDecoration(
                  color: Color(0xee76B9ED),
                  borderRadius: BorderRadius.circular(10)),
              child: FlatButton(
                  onPressed: () {
                    launchURL(url: "https://www.tiktok.com/@aateam96");
                  },
                  child: Row(
                    children: [
                      Container(
                          height: 24,
                          width: 24,
                          child: Image.asset('assets/images/tiktok.png')),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Tiktok',
                        style: textStyle.copyWith(fontSize: 15, color: white),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              onTap: (){
                Navigator.popAndPushNamed(context, LoginScreen.id);
              },
              leading: Icon(
                Icons.power_settings_new,
                color: amber,
              ),
              title: Text(
                'LOGOUT',
                style: textStyle.copyWith(color: amber, fontSize: 15),
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
      body: NotificationListener(
        // ignore: missing_return
        onNotification: (t){
          if (t is ScrollEndNotification) {
            if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){

            }
          }

        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: watchlist.length == 0? 0: watchlist.length,
          itemBuilder: (ctx, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
              child: ListTile(
                onTap: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return MarketPlace(symbol: watchlist[index]['stockExchangeIdentifier'], name: watchlist[index]['stockName'],AccessToken: widget.AccessToken,);
                  }));
//                   Map<String,String> header ={
//                     'Content-type':'application/json',
//                     'Accept':'application/json',
//                     'Authorization':'${Token}'
//                   };
//
//                   // var nowForParse = new DateTime.now();
//                   // var backDate =DateTime.now().subtract(Duration(days: 10));
//                   // String currentDate = DateFormat('yyyy-MM-dd').format(nowForParse);
//                   // String previousDate = DateFormat('yyyy-MM-dd').format(backDate);
//
//                   String ur = "$url"+'/stocks/GetStocksHistory/'+sharesResponse[index]['symbol'];
//                   http.get(ur,)
//                       .then((response) async{
//                     print(response.statusCode);
//                     list = jsonDecode(response.body);
//                     print("XYYYY$list");
//
//                     Provider.of<StockData>(context, listen: false).data.clear();
//                     for(int i = 0; i< list.length; i++){
//                       var price = double.parse(list[i]['price']);
//                       String change = (list[i]['dateTime']).toString();
//
//                       var cg = double.parse(change.substring(11,13));
//                       print("sdsdsdssd$cg");
//
//
//                       print(price);
//                       print(change);
//                       Provider.of<StockData>(context, listen: false).data.add(
//                           StockSeries(open: price,time: cg)
//                       );
//                     }
//                     Navigator.push(context, MaterialPageRoute(builder: (context){
//                       return MarketPlace(name: sharesResponse[index]['name'],symbol: sharesResponse[index]['symbol'],);
//                     }));
//                     // print("dsdsdds${list[index]['price']}");
//                     // print(list);
//                     setState(() {
//
//                       // for(int i = 0; i== list.length; i++){
//                       //   var price = double.parse(list[i]['price']);
//                       //   var change = double.parse(list[i]['change']);
//                       //
//                       //
//                       //   print(price);
//                       //   print(change);
//                       //   Provider.of<StockData>(context, listen: false).data.add(
//                       //       StockSeries(open: price,close: change)
//                       //   );
//                       //   // datax.add(
//                       //   //     StockSeries(open: price,close: change)
//                       //   // );
//                       // }
//                       Map stock = list[index];
//                       print("Provider${Provider.of<StockData>(context,listen: false).data}");
//
//
//
//
//
//
//                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>MarketPlace(stock_id: article["stock_id"], name : article["short_name"],list: datax,AccessToken: widget.AccessToken,)));
// //        isLoading = false;
//                     });
//                   }).catchError((e) {
//                     print(e);
//                   });


                },
                title: Text(watchlist[index]["stockName"],
                  style: textStyle.copyWith(
                      fontWeight: FontWeight.bold, color: amber, fontSize: 18),
                ),
                subtitle: Text(watchlist[index]["stockExchangeIdentifier"],
                  style: textStyle.copyWith(fontSize: 12, color: white),
                ),
              ),
            );
            // return NewsFeedTile(name:article["name"], shortName: article["short_name"],stock_id: article["stock_id"],);
          },
        ),
      ),
    );
  }
}