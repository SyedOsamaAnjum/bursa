import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Constant.dart';

class FutureReportScreen extends StatefulWidget {

  static const id = 'FutureReportScreen';

  final name;
  final webUrl;

  FutureReportScreen({this.name, this.webUrl});
  @override
  _FutureReportScreenState createState() => _FutureReportScreenState();
}

class _FutureReportScreenState extends State<FutureReportScreen> {
  @override
  Widget build(BuildContext context) {

    String url = widget.webUrl;
    String s = url.substring(4,);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: black,
        title: Text(
          '${widget.name}',
          style: textStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: white),
        ),
      ),
      body: WebView(
        initialUrl: "https://www.klsescreener.com/v2/$s",
        onWebViewCreated: (WebViewController webViewController){
          // _controller.complete(webViewController);
        },
      ),
    );
  }
}
