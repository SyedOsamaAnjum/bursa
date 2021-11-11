import 'package:bursa_app/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class StockDetailScreen extends StatefulWidget {

  static const id = 'StockDetailScreen';
  @override
  _StockDetailScreenState createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        leading: IconButton(icon:
        Icon(Icons.arrow_back,
        color: white,),
            onPressed: (){
          Navigator.pop(context);
            }),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('COMPANYNAME',
            style: textStyle.copyWith(
              fontSize: 18,
              color: white,
            ),),
            Container(
              child: Row(
                children: [
                  Container(
                    width:20,
                    height:20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: grey
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('United Kingdom',
                  style: textStyle.copyWith(
                    fontSize: 10,
                    color: white
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
      body: DefaultTabController(
        length: 4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: Image.asset('assets/images/download.png',
                color: amber,),
                title: RichText(text: TextSpan(
                  text: '2650.0 ',
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: white,
                    fontSize: 20
                  ),
                  children: [
                    TextSpan(
                      text: '-10.10% (-0.51%)',
                      style: textStyle.copyWith(
                        fontSize: 13,
                        color: amber
                      )
                    )
                  ]
                )),
                subtitle: Row(
              children: [
              Icon(Icons.access_time,
                color: grey,),
              SizedBox(
                width: 5,
              ),
              Text('20.39.00 | London',
                style: textStyle.copyWith(
                    fontSize: 14,
                    color: grey
                ),),
            ],
          ),
              ),
              SizedBox(
                height: 10,
              ),
              TabBar(
                labelColor: amber,
                indicatorColor: Colors.transparent,
                  labelStyle: TextStyle(
                    fontSize: 13,
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
                      child: Text('OverView'),
                    ),
                    Container(
                      height: 20,
                      child: Text('Financial'),
                    ),
                    Container(
                      height: 20,
                      child: Text('News'),
                    ),
                    Container(
                      height: 20,
                      child: Text('Research'),
                    ),
                  ]),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                    children: [
                      Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: media.width,
                                height: media.height * 0.4,
                                child: AreaAndLineChart.withSampleData(),
                              ),
                              Container(
                                width: media.width,
                                height: media.height * 0.1,
                                child: GroupedFillColorBarChart.withSampleData(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  width: media.width,
                                  height: 30,
                                  color: amber,
                                  child: FlatButton(
                                      onPressed: (){

                                      },
                                      child: Text('TRADE IT',
                                      style: textStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: white
                                      ),)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
//                        child: LineLineAnnotationChart.withSampleData(),
                      ),
                      Container(),
                      Container()
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class AreaAndLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  AreaAndLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory AreaAndLineChart.withSampleData() {
    return new AreaAndLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        animate: animate,
        customSeriesRenderers: [
          new charts.LineRendererConfig(
            // ID used to link series to this renderer.
              customRendererId: 'customArea',
              includeArea: true,
              stacked: false),
        ]);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final myFakeDesktopData = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(4, 75),
      new LinearSales(5, 5),
      new LinearSales(6, 25),
      new LinearSales(7, 100),
      new LinearSales(8, 75),
      new LinearSales(9, 5),
      new LinearSales(10, 25),
      new LinearSales(11, 100),
      new LinearSales(12, 75),
      new LinearSales(13, 5),
      new LinearSales(14, 25),
      new LinearSales(15, 100),
      new LinearSales(16, 75),
    ];

    var myFakeTabletData = [
      new LinearSales(0, 10),
      new LinearSales(1, 50),
      new LinearSales(2, 200),
      new LinearSales(3, 150),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: myFakeDesktopData,
      )
      // Configure our custom bar target renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customArea'),
//      new charts.Series<LinearSales, int>(
//        id: 'Tablet',
//        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
//        domainFn: (LinearSales sales, _) => sales.year,
//        measureFn: (LinearSales sales, _) => sales.sales,
//        data: myFakeTabletData,
//      ),
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}


class GroupedFillColorBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedFillColorBarChart(this.seriesList, {this.animate});

  factory GroupedFillColorBarChart.withSampleData() {
    return new GroupedFillColorBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      // Configure a stroke width to enable borders on the bars.
      defaultRenderer: new charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped, strokeWidthPx: 2.0),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    final tableSalesData = [
      new OrdinalSales('2014', 25),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 10),
      new OrdinalSales('2017', 20),
    ];

    final mobileSalesData = [
      new OrdinalSales('2014', 10),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 50),
      new OrdinalSales('2017', 45),
    ];

    return [
      // Blue bars with a lighter center color.
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) =>
        charts.MaterialPalette.blue.shadeDefault.lighter,
      ),
      // Solid red bars. Fill color will default to the series color if no
      // fillColorFn is configured.
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet',
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesData,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
      ),
      // Hollow green bars.
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.transparent,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}