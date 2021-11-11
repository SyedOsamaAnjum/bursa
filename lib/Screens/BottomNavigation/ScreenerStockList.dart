import 'package:bursa_app/Screens/BottomNavigation/WarrantChart.dart';
import 'package:flutter/material.dart';

import '../../Constant.dart';
import 'MarketPlace.dart';

class ScreenerStockList extends StatefulWidget {

  static const id = 'ScreenerStockList';

  final data;
  final AccessToken;
  final type;


  ScreenerStockList({this.data, this.AccessToken, this.type});

  @override
  _ScreenerStockListState createState() => _ScreenerStockListState();
}

class _ScreenerStockListState extends State<ScreenerStockList> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        centerTitle: true,
        title: Text('Filter List',
          style: textStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: white
          ),),
      ),
      body: widget.data.length == 0? Center(child: Text('Try Again Nothing Match Your Filter',
      style: textStyle.copyWith(
        color: amber
      ),),):ListView.builder(
          itemCount: widget.data.length,
        itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
          child: ListTile(
            onTap: () {

              widget.type == 'Warrant'? Navigator.push(context, MaterialPageRoute(builder: (context){
                return WarrantChart(symbol: widget.data[index]['stockcode'], name: widget.data[index]['name'],AccessToken: widget.AccessToken,);
              })):Navigator.push(context, MaterialPageRoute(builder: (context){
                return MarketPlace(symbol: widget.data[index]['stockcode'], name: widget.data[index]['name'],AccessToken: widget.AccessToken,);
              }));
            },
            title: Text(
              widget.data[index]["name"],
              style: textStyle.copyWith(
                  fontWeight: FontWeight.bold, color: amber, fontSize: 18),
            ),
            subtitle: Text(
              widget.data[index]["stockcode"],
              style: textStyle.copyWith(fontSize: 12, color: white),
            ),
          ),
        );
      },
      ),
    );
  }
}
