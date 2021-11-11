import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/NewsDetailScreen.dart';
import 'package:bursa_app/model/NewsResponse.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsFeedScreen extends StatefulWidget {
  static const id = 'NewsFeedScreen';
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  bool isLoading;
  List<dynamic> articles;



  loadNewsFeed() {

    var backDate =DateTime.now().subtract(Duration(days: 30));
    String previousDate = DateFormat('yyyy-MM-dd').format(backDate);

    http.get(
            "http://newsapi.org/v2/everything?q=bitcoin&from=$previousDate&sortBy=publishedAt&apiKey=602a08ea414b4b02956be62abd5583d7").then((response) {
      print(response.statusCode);
      Map data = jsonDecode(response.body);

//      Map article = articles[0];
//      Map source = article["source"];
//      print(source['name']);
//      print(article['title']);
      setState(() {
        articles = data["articles"];
        print(articles);
//        isLoading = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
//     isLoading = true;
      loadNewsFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: black,
        centerTitle: true,
        title: Text(
          'Live News Feeds',
          style: textStyle.copyWith(
              fontSize: 18, fontWeight: FontWeight.bold, color: white),
        ),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int indx) {
          print(articles.length);
          Map article = articles[indx];
          Map source = article["source"];
          print(source['name']);

          return NewsFeedTile(
            name: article['title'],
            author: article['author'],
            imageUrl: article['urlToImage'],
            description: article['description'],
            content: article['content'],
          );
        },
      ),
    );
  }
}

//ListView(
//children: [
//NewsFeedTile(),
//NewsFeedTile(),
//NewsFeedTile(),
//NewsFeedTile(),
//NewsFeedTile(),
//NewsFeedTile(),
//NewsFeedTile(),
//],
//),
class NewsFeedTile extends StatelessWidget {
  final String name;
  final String description;
  final String author;
  final String imageUrl;
  final String content;
  NewsFeedTile(
      {@required this.name, @required this.description, @required this.author , @required this.imageUrl , @required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
      child: ListTile(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsDetailScreen(name: this.name, author: this.author,imageURL: this.imageUrl,content: this.description,)));
        },
        isThreeLine: true,
        leading: Container(
          width: 100,
          height: MediaQuery.of(context).size.height,
         child: this.imageUrl == null?Icon(Icons.camera_alt,size: 40,color: Colors.white,):Image.network(imageUrl),
        ),
        title: Text(
          this.name,
          overflow: TextOverflow.fade,
          style: textStyle.copyWith(fontWeight: FontWeight.bold, color: black),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(this.author,
                style: textStyle.copyWith(fontSize: 12)),
            Text(
              this.description,
              style: textStyle.copyWith(fontSize: 12, color: grey),
           overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
