import 'dart:async';
import 'dart:convert';

import 'package:bursa_app/Screens/FutureReportScreen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../Constant.dart';

class Entitlement extends StatefulWidget {

  static const id = 'Entitlement';
  @override
  _EntitlementState createState() => _EntitlementState();
}

class _EntitlementState extends State<Entitlement> with SingleTickerProviderStateMixin{

  List<dynamic> sharesResponse;
  List<dynamic> upcomingResponse;
  List<dynamic> recentResponse;


  Future<void> loadShares({int i}) {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      // 'Authorization':'${Token}'
    };


    String u = "$url"+"/stocks/GetDivident";
    return http
        .get(u,headers: header)
        .then((response) {
      print(response.statusCode);
      List data = jsonDecode(response.body);

      print(data);
      sharesResponse = data.where((element) {
        return element['dividentType'] == 'Recent Dividends';
      }).toList();
      print(sharesResponse);
      upcomingResponse = data.where((element){
        return element['dividentType'] == 'Upcoming Dividends';
      }).toList();

      setState(() {
//        isLoading = false;
      });
    }).catchError((e) {
      print(e);
    });
  }



  Future<void> recentShares({int i}) {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      // 'Authorization':'${Token}'
    };


    String u = "$url"+"/stocks/GetShareIssue";
    return http
        .get(u,headers: header)
        .then((response) {
      print(response.statusCode);
      recentResponse = jsonDecode(response.body);
      //List x = data.values.toList();



      setState(() {
//        isLoading = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    loadShares();
    recentShares();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: black,
          centerTitle: true,
          title: Text('Entitlement',
            style: textStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: white
            ),),
          bottom: TabBar(
            isScrollable: true,
              labelColor: amber,
              indicatorColor: Colors.transparent,
              labelStyle: TextStyle(
                  fontSize: 15,
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
            child: Text('Recent Dividend'),
          ),
                Container(
                  height: 20,
                  child: Text('Upcomming Dividend'),
                ),
            Container(
              height: 20,
              child: Text('Recent Shares Issue'),
            ),
            ]),
        ),
        body: TabBarView(
            children: [
              ListView.builder(
                itemCount: sharesResponse.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
                    child: ListTile(
                      onTap: () {

                        Navigator.push(context, MaterialPageRoute(builder: (con){
                          return FutureReportScreen(
                            name: sharesResponse[index]["name"],
                            webUrl: sharesResponse[index]["urlLink"],
                          );
                        }));

                      },
                      title: Text(
                        sharesResponse[index]["name"],
                        style: textStyle.copyWith(
                            fontWeight: FontWeight.bold, color: amber, fontSize: 18),
                      ),
                      trailing: Text(
                        "Price: ${sharesResponse[index]["amount"]}",
                        style: textStyle.copyWith(fontSize: 12, color: white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sharesResponse[index]["subject"],
                            style: textStyle.copyWith(fontSize: 12, color: white),
                          ),
                          Text(
                            sharesResponse[index]["type"],
                            style: textStyle.copyWith(fontSize: 12, color: white),
                          ),
                        ],
                      ),
                    ),
                  );
                  // return NewsFeedTile(name:article["name"], shortName: article["short_name"],stock_id: article["stock_id"],);
                },
              ),
              ListView.builder(
                itemCount: upcomingResponse.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
                    child: ListTile(
                      onTap: () {

                        Navigator.push(context, MaterialPageRoute(builder: (con){
                          return FutureReportScreen(
                            name: upcomingResponse[index]["name"],
                            webUrl: upcomingResponse[index]["urlLink"],
                          );
                        }));

                      },
                      title: Text(
                        upcomingResponse[index]["name"],
                        style: textStyle.copyWith(
                            fontWeight: FontWeight.bold, color: amber, fontSize: 18),
                      ),
                      trailing: Text("Amount: ${upcomingResponse[index]["amount"]}",
                        style: textStyle.copyWith(fontSize: 12, color: white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            upcomingResponse[index]["subject"],
                            style: textStyle.copyWith(fontSize: 12, color: white),
                          ),
                          Text(
                            upcomingResponse[index]["type"],
                            style: textStyle.copyWith(fontSize: 12, color: white),
                          ),
                        ],
                      ),
                    ),
                  );
                  // return NewsFeedTile(name:article["name"], shortName: article["short_name"],stock_id: article["stock_id"],);
                },
              ),
              ListView.builder(
                itemCount: recentResponse.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
                    child: ListTile(
                      onTap: () {

                        Navigator.push(context, MaterialPageRoute(builder: (con){
                          return FutureReportScreen(
                            name: recentResponse[index]["name"],
                            webUrl: recentResponse[index]["urlLink"],
                          );
                        }));

                      },
                      title: Text(
                        recentResponse[index]["name"],
                        style: textStyle.copyWith(
                            fontWeight: FontWeight.bold, color: amber, fontSize: 18),
                      ),
                      trailing: Text(
                        "OfferPrice:${recentResponse[index]["offerPrice"]}",
                        style: textStyle.copyWith(fontSize: 12, color: white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ratio:${recentResponse[index]["ratio"]}",
                            style: textStyle.copyWith(fontSize: 12, color: white),
                          ),
                          Text(
                            "Ratio:${recentResponse[index]["exDate"]}",
                            style: textStyle.copyWith(fontSize: 12, color: white),
                          ),
                          Text(
                            "Type:${recentResponse[index]["type"]}",
                            style: textStyle.copyWith(fontSize: 12, color: white),
                          ),
                        ],
                      ),
                    ),
                  );
                  // return NewsFeedTile(name:article["name"], shortName: article["short_name"],stock_id: article["stock_id"],);
                },
              ),
            ]),
      ),
    );
  }
}

class DashTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: grey.withOpacity(0.1)
            )
          ]
      ),
      child: ListTile(
        onTap: (){
//          Navigator.pushNamed(context, StockDetailScreen.id);
        },
        title: Text('CMMT',
          style: textStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: white
          ),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(text: TextSpan(
                text: 'Subject:',
                style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: white
                ),
                children: [
                  TextSpan(
                      text: '  First Interim Dividend',
                      style: textStyle.copyWith(
                          fontSize: 12,
                          color: grey
                      )
                  )
                ]
            ),),
            RichText(text: TextSpan(
                text: 'Ex Date:',
                style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: white
                ),
                children: [
                  TextSpan(
                      text: '  4/01/2020',
                      style: textStyle.copyWith(
                          fontSize: 12,
                          color: grey
                      )
                  )
                ]
            ),),
            RichText(text: TextSpan(
                text: 'Amount:',
                style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: white
                ),
                children: [
                  TextSpan(
                      text: '  0.012',
                      style: textStyle.copyWith(
                          fontSize: 12,
                          color: grey
                      )
                  )
                ]
            ),),
            RichText(text: TextSpan(
                text: 'Type:',
                style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: white
                ),
                children: [
                  TextSpan(
                      text: '  Currency',
                      style: textStyle.copyWith(
                          fontSize: 12,
                          color: grey
                      )
                  )
                ]
            ),),
          ],
        ),
        trailing: RaisedButton(onPressed: (){

        },
          color: amber,
          child: Text('View',
          style: textStyle.copyWith(
            fontSize: 15,
            color: white,
          ),),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),)
      ),
    );
  }
}
