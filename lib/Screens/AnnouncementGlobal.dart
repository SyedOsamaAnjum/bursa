import 'dart:async';

import 'package:bursa_app/Constant.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'NewsDetailScreen.dart';

class AnnouncementGlobal extends StatefulWidget {

  static const id = 'AnnouncementGlobal';
  @override
  _AnnouncementGlobalState createState() => _AnnouncementGlobalState();
}

class _AnnouncementGlobalState extends State<AnnouncementGlobal> {
  bool loading  = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });

  }
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        centerTitle: true,
        title: Text('Announcements Global',
          style: textStyle.copyWith(
              color: white,
              fontWeight: FontWeight.bold
          ),),
      ),
      body: ModalProgressHUD(
        color: amber,
        opacity: 1,
        inAsyncCall: loading,
        child: WebView(
          initialUrl: "https://www.investing.com/news/",
          onWebViewCreated: (WebViewController webViewController){
            setState(() {
              loading = false;
            });
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}

class NewsFeedTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 5
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.4)
            )
          ]
      ),
      child: ListTile(
        onTap: (){
          Navigator.pushNamed(context, NewsDetailScreen.id);
        },
        isThreeLine: true,
        leading: Container(
          width: 100,
          height: MediaQuery.of(context).size.height,
          color: Colors.red,
        ),
        title: Column(
          children: [
            Text('News Heading',
              style: textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: black
              ),),
            Text('by Malaysia - 20 Minutes',
            style: textStyle.copyWith(
              fontSize: 10,
              color: grey
            ),)
          ],
        ),
        subtitle: Text('dsdsdsdsdsdsdsdscxcdhfsafouehfowhcohcewhcohowckclkzcldsdsdsdscxcckxkkkkkjzlclzcleocklxcldcldk',
          style: textStyle.copyWith(
              fontSize: 12,
              color: grey
          ),),
      ),
    );
  }
}

