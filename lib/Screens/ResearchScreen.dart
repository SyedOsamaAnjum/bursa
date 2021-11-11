import 'dart:async';

import 'package:bursa_app/Constant.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class ResearchScreen extends StatefulWidget {

  static const id = 'ResearchScreen';

  @override
  _ResearchScreenState createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        centerTitle: true,
        title: Text('Research',
        style: textStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: white,
          fontSize: 18
        ),),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: "https://klse.i3investor.com/jsp/pt.jsp",
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
                ),
              ],
            ),
          ),

        ],
      )
    );
  }
}

class DashTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
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
        title: RichText(text: TextSpan(
          text: 'Vodafone Group',
            style: textStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: white
            ),
          children: [
            TextSpan(
              text: '   +1.50 (29.18%)',
              style: textStyle.copyWith(
                fontSize: 10,
                color: amber
              )
            )
          ]
        ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(text: TextSpan(
                text: 'Date:',
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
                text: 'Last Price:',
                style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: white
                ),
                children: [
                  TextSpan(
                      text: '  5.14',
                      style: textStyle.copyWith(
                          fontSize: 12,
                          color: grey
                      )
                  )
                ]
            ),),
            RichText(text: TextSpan(
                text: 'Price Target:',
                style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: white
                ),
                children: [
                  TextSpan(
                      text: '  6.64',
                      style: textStyle.copyWith(
                          fontSize: 12,
                          color: grey
                      )
                  )
                ]
            ),),
          ],
        ),
        trailing: Column(
          children: [
            RichText(text: TextSpan(
                text: 'Price Call:',
                style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: white
                ),
                children: [
                  TextSpan(
                      text: '  BUY',
                      style: textStyle.copyWith(
                          fontSize: 12,
                          color: amber
                      )
                  ),
                ]
            ),),
            RichText(text: TextSpan(
                text: 'Source:',
                style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: white
                ),
                children: [
                  TextSpan(
                      text: '  AmInvest',
                      style: textStyle.copyWith(
                          fontSize: 12,
                          color: amber
                      )
                  )
                ]
            ),),
          ],
        ),
      ),
    );
  }
}
