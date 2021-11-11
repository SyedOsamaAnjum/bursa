import 'package:flutter/material.dart';

import '../Constant.dart';

class PostDetailScreen extends StatefulWidget {

  static const id = 'PostDetailScreen';

  final name;
  final content;
  final imageURL;
  final videoURL;

  PostDetailScreen({this.name, this.content, this.imageURL, this.videoURL});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
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
              widget.imageURL == null ? Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                color: Colors.black,
              ):Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Image.network("$imgUrl/resources/images/${widget.imageURL}"),
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
                child: Text(widget.content,
                  style: textStyle.copyWith(
                      fontSize: 14,
                      color: white
                  ),),
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

