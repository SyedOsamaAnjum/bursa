import 'dart:async';
import 'dart:convert';

import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/BottomNavigation/MarketPlace.dart';
import 'package:bursa_app/Screens/BottomNavigation/ScreenerStockList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class Screener extends StatefulWidget {

  static const id = 'Screener';


  final AccessToken;
  Screener({this.AccessToken});
  @override
  _ScreenerState createState() => _ScreenerState();
}

class _ScreenerState extends State<Screener> {



//   bool loading  = false;
//
  @override
  void initState() {

    super.initState();
  }

 bool op1 = false;
  List data;


  TextEditingController minAvg = TextEditingController();
  TextEditingController maxAvg = TextEditingController();
  TextEditingController minMKTCap = TextEditingController();
  TextEditingController maxMKTCap = TextEditingController();
  TextEditingController minPev = TextEditingController();
  TextEditingController maxPev = TextEditingController();
  TextEditingController minPbv = TextEditingController();
  TextEditingController maxPbv = TextEditingController();
  TextEditingController minEstPeg = TextEditingController();
  TextEditingController maxEstPeg = TextEditingController();
  TextEditingController minDiv = TextEditingController();
  TextEditingController maxDiv = TextEditingController();
  TextEditingController minPr = TextEditingController();
  TextEditingController maxPr = TextEditingController();
  TextEditingController minNet = TextEditingController();
  TextEditingController maxNet = TextEditingController();
  TextEditingController minPChange = TextEditingController();
  TextEditingController maxPChange = TextEditingController();



 @override
 Widget build(BuildContext context) {

   var media = MediaQuery.of(context).size;

   return DefaultTabController(
     length: 2,
     child: Scaffold(

       appBar: AppBar(
         centerTitle: true,
         backgroundColor: black,
         title: Text('Stocks Screener',
         style: textStyle.copyWith(
           fontSize: 18,
           fontWeight: FontWeight.bold,
           color: white
         ),),
         bottom: TabBar(
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
                 child: Text('Stock'),
               ),
               Container(
                 height: 20,
                 child: Text('Warrant'),
               ),
             ]),
       ),
       body: TabBarView(
           children: [
             Card(
               child: ListView(
                 padding: EdgeInsets.symmetric(horizontal: 20),
                 children: [
                   SizedBox(
                     height: 20,
                   ),
                   Row(
                     children: [
                       Expanded(child: Text('Avg. Rating',
                       style: textStyle.copyWith(
                         fontSize: 15,
                         color: amber
                       ),)),
                       Expanded(
                         child: Container(
                           child: Theme(
                             data: ThemeData(
                                 primaryColor: amber
                             ),
                             child: TextField(
                               controller: minAvg,
                               keyboardType: TextInputType.number,
                               textAlign: TextAlign.center,
                               decoration: InputDecoration(
                                 hintText: 'Min',
                               ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                       Expanded(
                         child: Theme(
                           data: ThemeData(
                               primaryColor: amber
                           ),
                           child: TextField(
                             controller: maxAvg,
                             keyboardType: TextInputType.number,
                             textAlign: TextAlign.center,
                             decoration: InputDecoration(
                               hintText: 'Max',
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                     ],
                   ),
                   SizedBox(
                     height: 20,
                   ),
                   Row(
                     children: [
                       Expanded(child: Text('MKTCap',
                         style: textStyle.copyWith(
                             fontSize: 15,
                             color: amber
                         ),)),
                       Expanded(
                         child: Container(
                           child: Theme(
                             data: ThemeData(
                                 primaryColor: amber
                             ),
                             child: TextField(
                               controller: minMKTCap,
                               keyboardType: TextInputType.number,
                               textAlign: TextAlign.center,
                               decoration: InputDecoration(
                                 hintText: 'Min',
                               ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                       Expanded(
                         child: Theme(
                           data: ThemeData(
                               primaryColor: amber
                           ),
                           child: TextField(
                             controller: maxMKTCap,
                             keyboardType: TextInputType.number,
                             textAlign: TextAlign.center,
                             decoration: InputDecoration(
                               hintText: 'Max',
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                     ],
                   ),
                   SizedBox(
                     height: 20,
                   ),
                   Row(
                     children: [
                       Expanded(child: Text('PEV',
                         style: textStyle.copyWith(
                             fontSize: 15,
                             color: amber
                         ),)),
                       Expanded(
                         child: Container(
                           child: Theme(
                             data: ThemeData(
                                 primaryColor: amber
                             ),
                             child: TextField(
                               controller: minPev,
                               keyboardType: TextInputType.number,
                               textAlign: TextAlign.center,
                               decoration: InputDecoration(
                                 hintText: 'Min',
                               ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                       Expanded(
                         child: Theme(
                           data: ThemeData(
                               primaryColor: amber
                           ),
                           child: TextField(
                             controller: maxPev,
                             keyboardType: TextInputType.number,
                             textAlign: TextAlign.center,
                             decoration: InputDecoration(
                               hintText: 'Max',
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                     ],
                   ),
                   SizedBox(
                     height: 20,
                   ),
                   Row(
                     children: [
                       Expanded(child: Text('Price',
                         style: textStyle.copyWith(
                             fontSize: 15,
                             color: amber
                         ),)),
                       Expanded(
                         child: Container(
                           child: Theme(
                             data: ThemeData(
                                 primaryColor: amber
                             ),
                             child: TextField(
                               controller: minPbv,
                               keyboardType: TextInputType.number,
                               textAlign: TextAlign.center,
                               decoration: InputDecoration(
                                 hintText: 'Min',
                               ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                       Expanded(
                         child: Theme(
                           data: ThemeData(
                               primaryColor: amber
                           ),
                           child: TextField(
                             controller: maxPbv,
                             keyboardType: TextInputType.number,
                             textAlign: TextAlign.center,
                             decoration: InputDecoration(
                               hintText: 'Max',
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                     ],
                   ),
                   SizedBox(
                     height: 20,
                   ),
                   Row(
                     children: [
                       Expanded(child: Text('EstPeg',
                         style: textStyle.copyWith(
                             fontSize: 15,
                             color: amber
                         ),)),
                       Expanded(
                         child: Container(
                           child: Theme(
                             data: ThemeData(
                                 primaryColor: amber
                             ),
                             child: TextField(
                               controller: minEstPeg,
                               keyboardType: TextInputType.number,
                               textAlign: TextAlign.center,
                               decoration: InputDecoration(
                                 hintText: 'Min',
                               ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                       Expanded(
                         child: Theme(
                           data: ThemeData(
                               primaryColor: amber
                           ),
                           child: TextField(
                             controller: maxEstPeg,
                             keyboardType: TextInputType.number,
                             textAlign: TextAlign.center,
                             decoration: InputDecoration(
                               hintText: 'Max',
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                     ],
                   ),
                   SizedBox(
                     height: 20,
                   ),
                   Row(
                     children: [
                       Expanded(child: Text('Div.yld',
                         style: textStyle.copyWith(
                             fontSize: 15,
                             color: amber
                         ),)),
                       Expanded(
                         child: Container(
                           child: Theme(
                             data: ThemeData(
                                 primaryColor: amber
                             ),
                             child: TextField(
                               controller: minDiv,
                               keyboardType: TextInputType.number,
                               textAlign: TextAlign.center,
                               decoration: InputDecoration(
                                 hintText: 'Min',
                               ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                       Expanded(
                         child: Theme(
                           data: ThemeData(
                               primaryColor: amber
                           ),
                           child: TextField(
                             controller: maxDiv,
                             keyboardType: TextInputType.number,
                             textAlign: TextAlign.center,
                             decoration: InputDecoration(
                               hintText: 'Max',
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                     ],
                   ),
                   SizedBox(
                     height: 20,
                   ),
                   RaisedButton(onPressed: (){

                     Map<String,String> header ={
                       'Content-type':'application/json',
                       'Accept':'application/json',
                     };


                     Map data = {
                       "MinAvgrating": minAvg.text,
                       "MaxAvgrating": maxAvg.text,
                       "MinMktcap": minMKTCap.text,
                       "MaxMktcap": maxMKTCap.text,
                       "MinPev": minPev.text,
                       "MaxPev": maxPev.text,
                       "MinPbv": minPbv.text,
                       "MaxPbv": maxPbv.text,
                       "MinEstpeg": minEstPeg.text,
                       "MaxEstpeg": maxEstPeg.text,
                       "MinDivyld": minDiv.text,
                       "MaxDivyld": maxDiv.text
                     };

                     String sb = jsonEncode(data);
                     String u = "$url"+"/stocks/GetMinMaxStock";

                     http.post(u, headers: header,body: sb).then((value) {
                       print(value.statusCode);
                       if(value.statusCode >=200 && value.statusCode < 300){

                         List data = jsonDecode(value.body);
                         Navigator.push(context, MaterialPageRoute(builder: (context){
                           return ScreenerStockList(data: data);
                         }));

                       }
                     });
                   },
                     child: Text('Apply Filter',
                       style: textStyle.copyWith(
                           fontSize: 15,
                           color: amber
                       ),),
                   )
                 ],
               ),
             ),
             Card(
               child: ListView(
                 padding: EdgeInsets.symmetric(horizontal: 20),
                 children: [
                   SizedBox(
                     height: 20,
                   ),
                   Row(
                     children: [
                       Expanded(child: Text('Price',
                         style: textStyle.copyWith(
                             fontSize: 15,
                             color: amber
                         ),)),
                       Expanded(
                         child: Container(
                           child: Theme(
                             data: ThemeData(
                                 primaryColor: amber
                             ),
                             child: TextField(
                               controller: minPr,
                               keyboardType: TextInputType.number,
                               textAlign: TextAlign.center,
                               decoration: InputDecoration(
                                 hintText: 'Min',
                               ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                       Expanded(
                         child: Theme(
                           data: ThemeData(
                               primaryColor: amber
                           ),
                           child: TextField(
                             controller: maxPr,
                             keyboardType: TextInputType.number,
                             textAlign: TextAlign.center,
                             decoration: InputDecoration(
                               hintText: 'Max',
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                     ],
                   ),
                   SizedBox(
                     height: 20,
                   ),
                   Row(
                     children: [
                       Expanded(child: Text('Net Change',
                         style: textStyle.copyWith(
                             fontSize: 15,
                             color: amber
                         ),)),
                       Expanded(
                         child: Container(
                           child: Theme(
                             data: ThemeData(
                                 primaryColor: amber
                             ),
                             child: TextField(
                               controller: minNet,
                               keyboardType: TextInputType.number,
                               textAlign: TextAlign.center,
                               decoration: InputDecoration(
                                 hintText: 'Min',
                               ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                       Expanded(
                         child: Theme(
                           data: ThemeData(
                               primaryColor: amber
                           ),
                           child: TextField(
                             controller: maxNet,
                             keyboardType: TextInputType.number,
                             textAlign: TextAlign.center,
                             decoration: InputDecoration(
                               hintText: 'Max',
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                     ],
                   ),
                   SizedBox(
                     height: 20,
                   ),
                   Row(
                     children: [
                       Expanded(child: Text('% Change',
                         style: textStyle.copyWith(
                             fontSize: 15,
                             color: amber
                         ),)),
                       Expanded(
                         child: Container(
                           child: Theme(
                             data: ThemeData(
                                 primaryColor: amber
                             ),
                             child: TextField(
                               controller: minPChange,
                               keyboardType: TextInputType.number,
                               textAlign: TextAlign.center,
                               decoration: InputDecoration(
                                 hintText: 'Min',
                               ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                       Expanded(
                         child: Theme(
                           data: ThemeData(
                               primaryColor: amber
                           ),
                           child: TextField(
                             controller: maxPChange,
                             keyboardType: TextInputType.number,
                             textAlign: TextAlign.center,
                             decoration: InputDecoration(
                               hintText: 'Max',
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                     ],
                   ),
                   SizedBox(
                     height: 20,
                   ),
                   RaisedButton(onPressed: (){

                     Map<String,String> header ={
                       'Content-type':'application/json',
                       'Accept':'application/json',
                     };


                     Map data = {
                       "MinPrice": minPr.text,
                       "MaxPrice": maxPr.text,
                       "MinNetChange": minNet.text,
                       "MaxNetChange": maxNet.text,
                       "MinPChange": minPChange.text,
                       "MaxPChange": maxPChange.text
                     };

                     String sb = jsonEncode(data);
                     String u = "$url"+"/stocks/GetMinMaxWarrent";

                     http.post(u, headers: header,body: sb).then((value) {
                       print(value.statusCode);
                       if(value.statusCode >=200 && value.statusCode < 300){

                         List data = jsonDecode(value.body);
                         Navigator.push(context, MaterialPageRoute(builder: (context){
                           return ScreenerStockList(data: data, type: 'Warrant',);
                         }));

                       }
                     });
                   },
                     child: Text('Apply Filter',
                       style: textStyle.copyWith(
                           fontSize: 15,
                           color: amber
                       ),),
                   )
                 ],
               ),
             ),
           ]),
     ),
   );
 }
}
