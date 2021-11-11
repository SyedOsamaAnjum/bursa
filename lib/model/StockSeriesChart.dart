import 'package:flutter/material.dart';
import 'StockSeries.dart';
import 'package:charts_flutter/flutter.dart' as charts;


// class StockSeriesChart extends StatelessWidget {
//
//   final List<StockSeries> data;
//
//   StockSeriesChart({this.data});
//
//   List<StockSeries> list = [
//     StockSeries(open: 2,close: 5),
//     StockSeries(open: 5,close: 1),
//     StockSeries(open: 6,close: 8),
//     StockSeries(open: 3,close: 5),
//     StockSeries(open: 2,close: 4),
//     StockSeries(open: 3,close: 5),
//     StockSeries(open: 7,close: 4),
//     StockSeries(open: 9,close: 5),
//   ];
//   @override
//   Widget build(BuildContext context) {
//
//     List<charts.Series<StockSeries, double>> series = [
//       charts.Series(
//         id: "Stock",
//         data: list,
//         domainFn: (StockSeries stock, _) => stock.open,
//         measureFn: (StockSeries stock, _) =>stock.close,
//       )
//     ];
//     return Container(
//       height: 300,
//       padding: EdgeInsets.all(20),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Center(
//                 child: charts.LineChart(series,
//                     animate: true,
//                     customSeriesRenderers: [
//                       new charts.LineRendererConfig(
//                         // ID used to link series to this renderer.
//                           customRendererId: 'Stock',
//                           includeArea: true,
//                           stacked: false),
//                     ]),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
