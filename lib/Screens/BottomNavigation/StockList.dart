import 'dart:async';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:bursa_app/Screens/AgentPanel/ChatScreen.dart';
import 'package:bursa_app/Screens/BottomNavigation/EtfCharts.dart';
import 'package:bursa_app/Screens/BottomNavigation/FutureChart.dart';
import 'package:bursa_app/Screens/BottomNavigation/LeapChart.dart';
import 'package:bursa_app/Screens/BottomNavigation/MarketPlace.dart';
import 'package:bursa_app/Screens/BottomNavigation/ReitChart.dart';
import 'package:bursa_app/Screens/BottomNavigation/WarrantChart.dart';
import 'package:bursa_app/Screens/BottomNavigation/WatchList.dart';
import 'package:bursa_app/Screens/LogReg/LoginScreen.dart';
import 'package:bursa_app/Screens/NewsDetailScreen.dart';
import 'package:bursa_app/Services/URLlauncher.dart';
import 'package:bursa_app/model/StockData.dart';
import 'package:bursa_app/model/StockSeries.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../Constant.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import '../AAArticle.dart';
import '../AATeamEvent.dart';
import '../CaseStudyList.dart';
import '../Entitlement.dart';
import '../LearnScreen.dart';
import '../NewsFeedScreen.dart';
import '../Profile.dart';
import '../ResearchScreen.dart';
import '../Screener.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'MyEvents.dart';

class StockList extends StatefulWidget {
  static String id = 'StockList Screen';

  final userId;
  final agentId;
  final AccessToken;
  final email;
  final pic;
  final jDate;
  final userName;
  final password;

  StockList({this.userId,this.agentId,this.AccessToken,this.email,this.pic, this.jDate, this.userName, this.password});

  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {

  Color color = black;

  int one = 1;
  int two = 1;
  int three = 1;
  int four = 1;
  int five = 1;
  int six = 1;


  static JsonDecoder _decoder = JsonDecoder();
  String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();

  Map data;
  final List<StockSeries> datax = [];

  List<dynamic> sharesResponse;
  List futureResponse;
  List warrants;
  List reit;
  List leap;
  List etf;

  ScrollController shareController = ScrollController();
  ScrollController furureController = ScrollController();
  ScrollController warrantsController = ScrollController();
  ScrollController reitController = ScrollController();
  ScrollController leapController = ScrollController();
  ScrollController etfController = ScrollController();



  Future<void> loadShares({int i}) {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${Token}'
    };


    String u = "https://www.bursamarketplace.com/index.php?tpl=stock_ajax&type=listing&pagenum=$one&sfield=name&stype=asc&midcap=0";
    return http
        .get(u,headers: header)
        .then((response) {

          print(response.statusCode);

          setState(() {
          Map data = jsonDecode(response.body);
      List x = data.values.toList();

      print("Stock: $data");
      sharesResponse = x[0];


//        isLoading = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> loadFuture({int i}) {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${Token}'
    };


    String u = "https://www.bursamarketplace.com/index.php?tpl=futures_ajax&type=listing&pagenum=$two&sfield=expiredate&maincode=FKLI&stype=asc";
    return http
        .get(u,headers: header)
        .then((response) {
      print(response.statusCode);

      Map data = jsonDecode(response.body);
      List x = data.values.toList();
      futureResponse = x[0];

      print("Future$data");
      setState(() {
//        isLoading = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> loadWarrants({int i}) {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${Token}'
    };


    String u = "https://www.bursamarketplace.com/index.php?tpl=warrants_ajax&type=listing&pagenum=$three&sfield=expirdate&stype=desc";
    return http
        .get(u,headers: header)
        .then((response) {
      print(response.statusCode);

      setState(() {
      Map data = jsonDecode(response.body);
      List x = data.values.toList();
      warrants = x[0];

      print("Warrants: $data");

//        isLoading = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> loadReit({int i}) {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${Token}'
    };

    String u = "https://www.bursamarketplace.com/index.php?tpl=reit_ajax&type=listing&pagenum=$four&sfield=name&stype=asc";
    return http
        .get(u,headers: header)
        .then((response) {
      print(response.statusCode);

      Map data = jsonDecode(response.body);
      List x = data.values.toList();
      setState(() {
        reit = x[0];
      });

      print("Reit: $data");

    }).catchError((e) {
      print(e);
    });
  }

  Future<void> loadLeap({int i}) {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${Token}'
    };


    String u = "https://www.bursamarketplace.com/index.php?tpl=themktleap_ajax&type=leapListing&sfield=volume&stype=desc";
    return http
        .get(u,headers: header)
        .then((response) {
      print(response.statusCode);

      setState(() {
        Map data = jsonDecode(response.body);
        List x = data.values.toList();
        leap = x[0];
      });

      print("Leap: $data");
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> loadETF({int i}) {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${Token}'
    };

    String u = "https://www.bursamarketplace.com/index.php?tpl=etf_ajax&type=listing&pagenum=1&sfield=name&stype=asc";
    return http
        .get(u,headers: header)
        .then((response) {
      print(response.statusCode);
      setState(() {
        Map data = jsonDecode(response.body);
        List x = data.values.toList();

        etf = x[0];
      });
      print("ETF:$data");

    }).catchError((e) {
      print(e);
    });
  }



  Column _getSplineAreaChart() {
    return Column(
      children: [
        SfCartesianChart(
          title: ChartTitle(text: 'Stock Updates'),
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
              interval: 1,
              majorGridLines: MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.hide),
          primaryYAxis: NumericAxis(
              labelFormat: '{value}',
              axisLine: AxisLine(width: 0),
              majorTickLines: MajorTickLines(size: 0)),
          series: _getSplieAreaSeries(),
          tooltipBehavior: TooltipBehavior(enable: true),
        ),
      ],
    );
  }

  /// Returns the list of chart series
  /// which need to render on the spline area chart.
  List<ChartSeries<StockSeries, double>> _getSplieAreaSeries() {
    final List<StockSeries> chartData = Provider.of<StockData>(context).data;
    return <ChartSeries<StockSeries, double>>[
      SplineAreaSeries<StockSeries, double>(
        dataSource: chartData,
        color: Colors.amberAccent.withOpacity(0.5),
        borderColor: amber,
        borderWidth: 2,
        name: 'TPGC.KL',
        xValueMapper: (StockSeries sales, _) => sales.time,
        yValueMapper: (StockSeries sales, _) => sales.open,
      ),
    ];
  }

  Timer time;

  @override
  void initState() {
    // TODO: implement initState
    loadbanner();
    loadShares(i: 1);
    loadWarrants(i: 1);
    loadFuture(i: 1);
    loadETF(i: 1);
    loadReit(i: 1);
    loadLeap(i: 1);
    getT();


    super.initState();

  }

  ScrollController _scrollController = ScrollController();



  @override
  void dispose() {
    // TODO: implement dispose
    time?.cancel();
    // scrollController.position.

    super.dispose();
  }

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



  List<dynamic> list;
  bool vis = false;

  var images;
  List banner;

  loadbanner(){

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.AccessToken}'
    };
    String u = "$url"+"/articles/GetBanners";
    return http.get(u,headers: header).then((response){

      print("Status ${response.statusCode}");
      setState(() {

        List data = _decoder.convert(response.body);

        banner = data.where((element) => element['link'] != null).toList();
        print("Banner: $banner");
      });
      return [];
    });
  }
  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: black,
          title: Text(
            'Market Place',
            style: textStyle.copyWith(
                fontSize: 18, fontWeight: FontWeight.bold, color: white),
          ),
          bottom: TabBar(
            isScrollable: true,
              labelColor: amber,
              indicatorColor: Colors.transparent,
              labelStyle: TextStyle(
                  fontSize: 12,
                  color: amber
              ),
              unselectedLabelColor: grey,
              unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                  color: grey
              ),
              tabs: [
                Container(
                  height: 20,
                  child: Text('Stocks'),
                ),
                Container(
                  height: 20,
                  child: Text('Futures'),
                ),
                Container(
                  height: 20,
                  child: Text('Warrants'),
                ),
                Container(
                  height: 20,
                  child: Text('REIT'),
                ),
                Container(
                  height: 20,
                  child: Text('ETF'),
                ),
                Container(
                  height: 20,
                  child: Text('Leap'),
                ),
                Container(
                  height: 20,
                  child: Text('Trading Ideas & Indices'),
                ),
              ]),
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
        body: Stack(
          children: [
            TabBarView(
                children: [
                  NotificationListener(
                    // ignore: missing_return
                    onNotification: (t){
                      if (t is ScrollEndNotification) {
                        if(shareController.position.pixels == shareController.position.maxScrollExtent){

                          setState(() {
                            one = one + 1;
                          });

                          //shareController.animateTo(0.0, duration: Duration(milliseconds: 200),curve: Curves.easeIn);
                          loadShares();

                        }else if(shareController.position.pixels == shareController.position.minScrollExtent){
                          setState(() {
                            if(one !=1){

                              one = one - 1;
                            }

                          });
                          loadShares();
                        }
                      }

                    },
                    child: ListView.builder(
                      controller: shareController,
                      itemCount: sharesResponse.length,
                      
                      itemBuilder: (ctx, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
                          child: 
                          sharesResponse.length==null ? Center(child: CircularProgressIndicator(),):
                          ListTile(
                            onTap: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return MarketPlace(symbol: sharesResponse[index]['stockcode'], name: sharesResponse[index]['name'],AccessToken: widget.AccessToken,);
                              }));
                            },
                            title: Text(
                              sharesResponse[index]["name"],
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.bold, color: amber, fontSize: 18),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "%Change: ${sharesResponse[index]["pctchng"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "last: ${sharesResponse[index]["last"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "Open: ${sharesResponse[index]["open"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "Volume: ${sharesResponse[index]["volume"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "NetChange: ${sharesResponse[index]["netchange"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                              ],
                            ),
                          ),
                        );
                        // return NewsFeedTile(name:article["name"], shortName: article["short_name"],stock_id: article["stock_id"],);
                      },
                    ),
                  ),
                  NotificationListener(
                    // ignore: missing_return
                    onNotification: (t){
                      if (t is ScrollEndNotification) {
                        if(furureController.position.pixels == furureController.position.maxScrollExtent){

                          setState(() {
                            two = two + 1;
                          });
                          loadFuture();
                        }else if (furureController.position.pixels == furureController.position.minScrollExtent){
                          setState(() {
                            if(two !=1){

                              two = two - 1;
                            }

                          });
                          loadFuture();
                        }
                      }

                    },
                    child: ListView.builder(
                      controller: furureController,
                      itemCount: futureResponse.length,
                      // ignore: missing_return
                      itemBuilder: (BuildContext context, int index) {
                        futureResponse.length != null? 
                         Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
                          child: ListTile(
                            onTap: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return FutureChart(symbol: futureResponse[index]['stockcode'], name: futureResponse[index]['stockcode'],AccessToken: widget.AccessToken,);
                              })).then((value) {
                                Provider.of<StockData>(context, listen: false).data.clear();
                                print("TexTing");

                              });



                            },
                            title: Text(
                              futureResponse[index]["stockcode"],
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.bold, color: amber, fontSize: 18),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "%Change: ${sharesResponse[index]["pctchng"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "last: ${sharesResponse[index]["last"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "Open: ${sharesResponse[index]["open"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "Volume: ${sharesResponse[index]["volume"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "NetChange: ${sharesResponse[index]["netchange"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                              ],
                            ),
                          ),
                        )
                        : Center(child: CircularProgressIndicator(),);
                      },),
                  ),
                  NotificationListener(
                    // ignore: missing_return
                    onNotification: (t){
                      if (t is ScrollEndNotification) {
                        if(warrantsController.position.pixels == warrantsController.position.maxScrollExtent){

                          setState(() {
                            three = three + 1;
                          });
                          loadWarrants();
                        }else if(warrantsController.position.pixels == warrantsController.position.minScrollExtent){
                          setState(() {
                            if(three !=1){

                              three = three - 1;
                            }

                          });
                          loadWarrants();
                        }
                      }

                    },
                    child: ListView.builder(
                      controller: warrantsController,
                      itemCount: warrants.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
                          child: ListTile(
                            onTap: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return WarrantChart(symbol: warrants[index]['stockcode'], name: warrants[index]['name'],AccessToken: widget.AccessToken,);
                              }));
                            },
                            title: Text(
                              warrants[index]["name"],
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.bold, color: amber, fontSize: 18),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "%Change: ${warrants[index]["pctchng"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "last: ${warrants[index]["last"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "Open: ${warrants[index]["open"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "Volume: ${warrants[index]["volume"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "NetChange: ${warrants[index]["netchange"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  NotificationListener(
                    // ignore: missing_return
                    onNotification: (t){
                      if (t is ScrollEndNotification) {
                        if(reitController.position.pixels == reitController.position.maxScrollExtent){

                          setState(() {
                            four = four + 1;
                          });
                          loadReit();
                        }else if(reitController.position.pixels == reitController.position.minScrollExtent){
                          setState(() {
                            if(four !=1){

                              four = four - 1;
                            }

                          });
                          loadReit();
                        }
                      }

                    },
                    child: ListView.builder(
                      controller: reitController,
                      itemCount: reit.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
                          child: ListTile(
                            onTap: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return ReitChart(symbol: reit[index]['stockcode'], name: reit[index]['name'],AccessToken: widget.AccessToken,);
                              }));
                            },
                            title: Text(
                              reit[index]["name"],
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.bold, color: amber, fontSize: 18),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "NetChange: ${reit[index]["netchange"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "%Change: ${reit[index]["percentchange"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Volume: ${reit[index]["volume"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "Open: ${reit[index]["open"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                              ],
                            ),
                          ),
                        );
                        // return NewsFeedTile(name:article["name"], shortName: article["short_name"],stock_id: article["stock_id"],);
                      },
                    ),
                  ),
                  NotificationListener(
                    // ignore: missing_return
                    onNotification: (t){
                      if (t is ScrollEndNotification) {
                        if(etfController.position.pixels == etfController.position.maxScrollExtent){

                          setState(() {
                            five = five + 1;
                          });
                          loadETF();
                        }else if (etfController.position.pixels == etfController.position.minScrollExtent){
                          setState(() {
                            if(five !=1){

                              five = five - 1;
                            }

                          });
                          loadETF();
                        }
                      }

                    },
                    child: ListView.builder(
                      controller: etfController,
                      itemCount: etf.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
                          child: ListTile(
                            onTap: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return EtfChart(symbol: etf[index]['stockcode'], name: etf[index]['name'],AccessToken: widget.AccessToken,);
                              }));
                            },
                            title: Text(
                              etf[index]["name"],
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.bold, color: amber, fontSize: 18),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "NetChange: ${etf[index]["netchange"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "%Change: ${etf[index]["percentchange"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Volume: ${etf[index]["volume"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "Open: ${etf[index]["open"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                              ],
                            ),
                          ),
                        );
                        // return NewsFeedTile(name:article["name"], shortName: article["short_name"],stock_id: article["stock_id"],);
                      },
                    ),
                  ),
                  NotificationListener(
                    // ignore: missing_return
                    onNotification: (t){
                      if (t is ScrollEndNotification) {
                        if(leapController.position.pixels == leapController.position.maxScrollExtent){

                          setState(() {
                            six = six + 1;
                          });
                          loadLeap();
                        }else if(leapController.position.pixels == leapController.position.minScrollExtent){
                          setState(() {
                            if(six !=1){

                              six = six - 1;
                            }

                          });
                          loadLeap();
                        }
                      }

                    },
                    child: ListView.builder(
                      controller: leapController,
                      itemCount: leap.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
                          child: 
                          leap==null?Center(child: CircularProgressIndicator(),):
                          ListTile(
                            onTap: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return LeapChart(symbol: leap[index]['stockcode'], name: leap[index]['name'],AccessToken: widget.AccessToken,);
                              }));
                            },
                            title: Text(
                        
                              leap[index]["name"],
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.bold, color: amber, fontSize: 18),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "NetChange: ${leap[index]["netchange"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "%Change: ${leap[index]["percentchange"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Volume: ${leap[index]["volume"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                                Text(
                                  "Open: ${leap[index]["open"]}",
                                  style: textStyle.copyWith(fontSize: 12, color: white),
                                ),
                              ],
                            ),
                          ),
                        );
                        // return NewsFeedTile(name:article["name"], shortName: article["short_name"],stock_id: article["stock_id"],);
                      },
                    ),
                  ),
                  Stack(
                    children: [
                      WebView(
                        initialUrl: "https://www.bursamarketplace.com/mkt/themarket",
                        onWebViewCreated: (WebViewController webViewController){
                          // _controller.complete(webViewController);
                        },
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: media.width,
                              color: Colors.black,
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: Image(image: AssetImage('assets/images/Logo.png'),
                                      fit: BoxFit.cover,),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: vis,
                  child: Container(
                    width: media.width * 0.8,
                    height: media.height * 0.6,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                icon: Icon(Icons.close,
                                  color: white,),
                                onPressed: (){
                                  setState(() {
                                    vis = false;
                                  });
                                })
                          ],
                        ),
                //         SizedBox(
                //           width: 400,
                //           height: 300,
                //           child: Image.network('$imgUrl/resources/banners/$images',
                //             fit: BoxFit.cover,),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // CarouselSlider(
                //   options: CarouselOptions(height: 50.0),
                //   items: banner.map((i) {
                //     return Builder(
                //       builder: (BuildContext context) {
                //         List img = i.values.toList();
                //         return GestureDetector(
                //           onTap: (){

                //             setState(() {
                //               images = img[3];
                //             });
                //             vis = true;
                //           },
                //           child: Container(
                //             color: Colors.black,
                //             width: MediaQuery.of(context).size.width,
                //             margin: EdgeInsets.symmetric(horizontal: 5.0),
                //             child: Image.network('$imgUrl/resources/banners/${img[2]}',
                //               fit: BoxFit.cover,),
                //           ),
                //         );
                //       },
                //     );
                //   }).toList(),
                // )
              ],
            )
                ))]),
            ] ),
      ),
    );
  }
}




