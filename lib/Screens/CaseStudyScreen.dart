import 'package:bursa_app/Services/URLlauncher.dart';
import 'package:flutter/material.dart';

import '../Constant.dart';

class CaseStudyScreen extends StatefulWidget {

  static const id = 'CaseStudyScreen';

  final name;
  final content;
  final imageUrl;

  CaseStudyScreen({this.content, this.name, this.imageUrl,});


  @override
  _CaseStudyScreenState createState() => _CaseStudyScreenState();
}

class _CaseStudyScreenState extends State<CaseStudyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: black,
        leading: IconButton(
            icon: Icon(Icons.arrow_back,
              color: white,),
            onPressed: (){
              Navigator.pop(context);
            }),
        title: Text(widget.name,
          style: textStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: white
          ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(widget.name,
                  style: textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: white
                  ),),
              ),
              SizedBox(
                height: 10,
              ),
              widget.imageUrl == null ? Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                color: Colors.black,
              ):Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Image.network("$imgUrl/resources/CaseStudy/${widget.imageUrl}"),
              ),
              SizedBox(
                height: 10,
              ),
              // Text('by '+widget.author,
              //   style: textStyle.copyWith(
              //       fontSize: 18,
              //       color: white
              //   ),),
              SizedBox(
                height: 20,
              ),
              Container(
                child: GestureDetector(
                  onTap: (){
                    launchURL(url: "https://${widget.content}");
                  },
                  child: Text('Link : ${widget.content}',
                    style: textStyle.copyWith(
                        fontSize: 14,
                        color: white
                    ),),
                ),
              ),
              SizedBox(
                height: 20,
              )


            ],
          ),
        ),
      ),
    );
  }
}

