import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bursa_app/model/StockData.dart';
import 'package:bursa_app/model/StockSeries.dart';
import 'package:bursa_app/model/StockSeriesChart.dart';
import 'package:intl/intl.dart';
import 'package:bursa_app/Constant.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../AnnouncementMalaysia.dart';
import '../Entitlement.dart';
import '../NewsFeedScreen.dart';
import '../ResearchScreen.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

class WarrantChart extends StatefulWidget {

  static const id = 'WarrantChart';

  final String name;
  final String symbol;
  // ignore: non_constant_identifier_names
  final String AccessToken;
  final List<StockSeries> list;

  WarrantChart({this.name, this.symbol, this.AccessToken, this.list});

  @override
  _WarrantChartState createState() => _WarrantChartState();
}

class _WarrantChartState extends State<WarrantChart> {
  List<dynamic> openingAndClosingList;
  Color color = grey;
  Map datag;
  List data = [];
  //static String url = 'https://bursa.8mindsolutions.com/api';
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  static JsonDecoder _decoder = JsonDecoder();
  List<dynamic> list;
  loadStocks(){

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      //'Authorization':'${Token}'
    };

    print(widget.symbol);

    String ur = "$url"+'/stocks/GetWarrantsHistory/'+widget.symbol;
    http.get(ur,)
        .then((response) async{
      print(response.statusCode);
      setState(() {
        list = jsonDecode(response.body);
        Provider.of<StockData>(context, listen: false).data.clear();
        print(list);
        for(int i = 0; i< list.length; i++){
          var price = double.parse(list[i]['last']);
          // if(price == )
          String change = (list[i]['dateTime']).toString();

          List c = change.split('T');

          var cg = double.parse(c[1].substring(0,2));
          print(c[1]);
          print(cg);
          var cm = 24 - cg;
          // print("sdsdsdssd$cg");
          //
          //
          // print(price);
          // print(change);
          Provider.of<StockData>(context, listen: false).data.add(
              StockSeries(open: price,time: cg)
          );
        }
      });
      // print("dsdsdds${list[index]['price']}");
      // print(list);

    }).catchError((e) {
      print(e);
    });
  }

  List<dynamic> watchList;

  Future<List<String>> getData() {
    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.AccessToken}'
    };
    String u = "$url"+"/watchlist/";
    return http.get(u,headers: header).then((response){
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {
        List<dynamic> user= _decoder.convert(response.body);
//        print(user);

        watchList = user.where((element) => element['stockExchangeIdentifier'] == widget.symbol).toList();
        print(watchList);
        if(watchList.length == 0){
          color = grey;
        }else {
          color = amber;
        }
      });
      return [];
    });
  }

  List banner;

  loadbanner(){

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.AccessToken}'
    };
    String u = "$url"+"/articles/GetBanners";
    return http.get(u,headers: header).then((response){
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {

        List data = _decoder.convert(response.body);

        banner = data.where((element) => element['link'] != null).toList();
        print(banner);
      });
      return [];
    });
  }

  String images;
  bool vis = false;

  Timer time;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    loadStocks();
    loadbanner();
    time = Timer.periodic(Duration(minutes: 2), (Timer timer) {
      print("done");

      loadStocks();
    });
  }


  String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

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
        color: amber.withOpacity(0.5),
        borderColor: amber,
        borderWidth: 2,
        name: '${widget.name}',
        xValueMapper: (StockSeries sales, _) => sales.time,
        yValueMapper: (StockSeries sales, _) => sales.open,
      ),
      // SplineAreaSeries<_SplineAreaData, double>(
      //   dataSource: chartData,
      //   borderColor: const Color.fromRGBO(192, 108, 132, 1),
      //   color: const Color.fromRGBO(192, 108, 132, 0.6),
      //   borderWidth: 2,
      //   name: 'China',
      //   xValueMapper: (_SplineAreaData sales, _) => sales.year,
      //   yValueMapper: (_SplineAreaData sales, _) => sales.y2,
      // )
    ];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    time?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: black,
          title: Text(
            widget.name,
            style: textStyle.copyWith(
                fontWeight: FontWeight.bold, fontSize: 18, color: white),
          ),
          actions: [
            IconButton(icon: Icon(Icons.add,
              color: color,),
                onPressed: (){

                  Map<String,String> header ={
                    'Content-type':'application/json',
                    'Accept':'application/json',
                    'Authorization':'${widget.AccessToken}'
                  };
                  // print("Sdsdadssa AccessToken${widget.AccessToken}");

                  datag = {
                    "StockExchangeIdentifier": widget.symbol,
                    "StockName": widget.name
                  };

                  var sb = convert.jsonEncode(datag);

                  String ul = "$url" + "/watchlist";

                  if(color == grey){
                    http.post(ul, body: sb,headers: header).then((value) {
                      var statusCode = value.statusCode;
                      if(statusCode == 200){
                        setState(() {
                          color = amber;
                        });
//                      Map otp = _decoder.convert(value.data);
                        print(statusCode);
                      }
                    });
                  }
                  else if(color == amber){
                    String ul = "$url" + "/watchlist/deletebysid/"+widget.symbol;
                    http.delete(ul,headers: header).then((value) {
                      print(value.statusCode);
                      if(value.statusCode == 200){
                        setState(() {
                          color = grey;
                        });
                      }

                    });
                  }

                })
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      children: [
                        _getSplineAreaChart(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Latest Price',
                      //textAlign: TextAlign.start,
                      style: textStyle.copyWith(
                          fontSize: 18,
                          color: amber,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                  Container(
                    width: media.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (ctx, index) {
                        String date = list[index]['dateTime'];
                        var dt = date.split('T');
                        String x = dt[1];
                        var xy = x.split('.');
                        String time = xy[0];
                        //DateTime dateTime = dateFormat.parse(time[0]);
                        //String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                        //print(formattedDate);
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
                          child: ListTile(
                            onTap: () {




                            },
                            title: Text(
                              xy[0],
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.bold, color: amber, fontSize: 18),
                            ),
                            subtitle: Text(
                              'Price: ${list[index]["price"]}',
                              style: textStyle.copyWith(fontSize: 12, color: white),
                            ),
                          ),
                        );
                        // return NewsFeedTile(name:article["name"], shortName: article["short_name"],stock_id: article["stock_id"],);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Visibility(
            //       visible: vis,
            //       child: Container(
            //         width: 400,
            //         height: 300,
            //         child: Column(
            //           children: [
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.end,
            //               children: [
            //                 IconButton(
            //                     icon: Icon(Icons.close,
            //                       color: white,),
            //                     onPressed: (){
            //                       setState(() {
            //                         vis = false;
            //                       });
            //                     })
            //               ],
            //             ),
            //             SizedBox(
            //               width: 400,
            //               height: 300,
            //               child: Image.network('https://bursa.8mindsolutions.com/resources/banners/$images',
            //                 fit: BoxFit.cover,),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     CarouselSlider(
            //       options: CarouselOptions(height: 80.0),
            //       items: banner.map((i) {
            //         return Builder(
            //           builder: (BuildContext context) {
            //             List img = i.values.toList();
            //             return GestureDetector(
            //               onTap: (){
            //
            //                 setState(() {
            //                   images = img[2];
            //                 });
            //                 vis = true;
            //               },
            //               child: Container(
            //                 color: Colors.black,
            //                 width: MediaQuery.of(context).size.width,
            //                 margin: EdgeInsets.symmetric(horizontal: 5.0),
            //                 child: Image.network('https://bursa.8mindsolutions.com/resources/banners/${img[2]}',
            //                   fit: BoxFit.cover,),
            //               ),
            //             );
            //           },
            //         );
            //       }).toList(),
            //     )
            //   ],
            // )
          ],
        ));
  }
}
