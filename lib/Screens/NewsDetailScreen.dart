import 'package:bursa_app/Constant.dart';
import 'package:flutter/material.dart';

class NewsDetailScreen extends StatefulWidget {
  final String name;
  final String content;
  final String imageURL;
  final String author;

  NewsDetailScreen({this.name, this.content, this.imageURL, this.author});

  static const id ='NewsDetailScreen';
  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
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
        title: Text('${widget.name}',
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
              Text('Setptember 2020 | 17:35',
              style: textStyle.copyWith(
                fontSize: 14,
                color: Colors.grey
              ),),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Image.network(widget.imageURL),
              ),
              SizedBox(
                height: 10,
              ),
              Text('by '+widget.author,
              style: textStyle.copyWith(
                fontSize: 18,
                color: white
              ),),
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
