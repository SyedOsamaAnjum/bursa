import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

launchURL({String url}) async {
  var ul = url;
  if (await canLaunch(ul)) {
    await launch(ul);
  } else {
    throw 'Could not launch $url';
  }
}