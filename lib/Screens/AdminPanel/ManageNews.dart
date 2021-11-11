import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:bursa_app/Constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';

import 'UpdatePoster.dart';

class ManageNews extends StatefulWidget {

  final token;
  final currentId;

  ManageNews({this.token, this.currentId});
  @override
  _ManageNewsState createState() => _ManageNewsState();
}

class _ManageNewsState extends State<ManageNews> {

  File _pic;
  String _picPath = '';


  // String serverUrl = "https://bursa.8mindsolutions.com";
// Creates the connection by using the HubConnectionBuilder.
//   final hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();

//   connection.close()
  List<String> chats;
  HubConnection connection;
  TextEditingController messageController = TextEditingController();
  @override
  void initState(){
    // TODO: implement initState
    chats = new List();
    createSignalRConnection();

    setState(() {
      getData();
    });
    super.initState();

  }

  Future<void> createSignalRConnection() async {


    connection =
        HubConnectionBuilder().withUrl("$imgUrl/chatHub?userId=${widget.currentId}").build();
    await connection.start().then((value) {
      print("started");
    });
//    connection.invoke("BroadCastMessage");;
  }

  // static String url = 'https://bursa.8mindsolutions.com/api';
  static JsonDecoder _decoder = JsonDecoder();
  // String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();
  List<dynamic> chatMessage;

  Future getImage() async {

    var video = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _picPath = video.path;
      _pic = video;
    });
  }

  File _video;
  String _videoPath = '';

  Future getImage1() async {

    var video = await ImagePicker.pickVideo(source: ImageSource.gallery);

    setState(() {
      _videoPath = video.path;
      _video = video;
    });
  }


  List<dynamic> postNews;

  Future<List<String>> getData() {

     Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
       'Authorization':'${widget.token}'
    };

    String u = "$url"+"/articles/";
    return http.get(u,headers: header).then((response){
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {
        postNews= _decoder.convert(response.body);
        print(postNews);
      });

      return [];
    });

  }

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();



  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: black,
        centerTitle: true,
        title: Text('Manage\'s Posts',
          style: textStyle.copyWith(
            fontSize: 18,
            color: amber,
          ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Post:',
                style: textStyle.copyWith(
                    fontSize: 18,
                    color: amber
                ),),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Container(
                  width: media.width,
                  height: media.height * 0.42,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: white
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Theme(
                          data: ThemeData(
                              primaryColor: amber
                          ),
                          child: TextField(
                            controller: title,
                            decoration: InputDecoration(
                              hintText: 'Title',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Theme(
                          data: ThemeData(
                              primaryColor: amber
                          ),
                          child: TextField(
                            controller: description,
                            minLines: 3,
                            maxLines: 4,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              hintText: 'Post Description',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Please upload images of size of 400x300 and video of size 5 mb',
                        style: textStyle.copyWith(
                            fontSize: 12,
                            color: amber
                        ),),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RaisedButton(onPressed: (){
                              getImage();
                            },
                              color: amber,
                              child: Icon(Icons.add_a_photo_outlined),),
                            RaisedButton(onPressed: (){
                              getImage1();
                            },
                              color: amber,
                              child: Icon(Icons.video_call),),
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Center(
                          child: RaisedButton(onPressed: (){

                            String u = "$url"+"/articles/";


                            Map<String,String> header ={
                              'Content-type':'application/json',
                              'Accept':'application/json',
                              'Authorization':'${widget.token}'
                            };

                            Map data = {
                              'Name': title.text,
                              'Text': description.text
                            };

                            var sb=convert.json.encode(data);

                            http.post(u,headers: header, body: sb).then((value)async{
                              print(value.statusCode);


                              Map valu = _decoder.convert(value.body);
                              List val = valu.values.toList();

                              print(val);


                              if(_video != null){

                                var headers = {
                                  'Authorization': 'Bearer ${widget.token}'
                                };
                                var request = http.MultipartRequest('POST', Uri.parse('$url/articles/UploadArticleVideo/${val[0]}'));
                                request.files.add(await http.MultipartFile.fromPath('file', '${_video.path}'));
                                request.headers.addAll(headers);

                                http.StreamedResponse response = await request.send();

                                if (response.statusCode == 200) {

                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text('Video Uploaded')));
                                  print(await response.stream.bytesToString());
                                }
                                else {
                                  print(response.reasonPhrase);
                                }

                              }

                              if(_pic != null){

                                var headers = {
                                  'Authorization': 'Bearer ${widget.token}'
                                };
                                var request = http.MultipartRequest('POST', Uri.parse('$url/articles/UploadPicture/${val[0]}'));
                                request.files.add(await http.MultipartFile.fromPath('file', '${_pic.path}'));
                                request.headers.addAll(headers);

                                http.StreamedResponse response = await request.send();

                                print("image${response.statusCode}");
                                if (response.statusCode == 200) {
                                  print(await response.stream.bytesToString());
                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text('Image Uploaded')));
                                }
                                else {
                                  print(response.reasonPhrase);
                                }

                              }

                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text('Post Created')));
                              print(widget.currentId);

                              getData();
                              print(title.text);
                              print(widget.currentId);
                              print(val[0]);
                              await connection.invoke("SendNotification",args: [title.text,widget.currentId,false, val[0]]);
                            });
                          },
                            color: amber,
                            child: Text('Create Post',
                              style: textStyle.copyWith(
                                  fontSize: 18,
                                  color: black
                              ),),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Recent Post:',
                style: textStyle.copyWith(
                    fontSize: 18,
                    color: amber
                ),),
              Container(
                width: media.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: postNews == null ? 0 : postNews.length,
                  itemBuilder: (BuildContext context, int index){

                    print(postNews);
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 5
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: grey.withOpacity(0.2)
                            )
                          ]
                      ),
                      child: ListTile(
                        onTap: (){
                          // Navigator.pushNamed(context, NewsDetailScreen.id);
                        },
                        // isThreeLine: true,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(postNews[index]["name"],
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: amber,
                                  fontSize: 18
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(postNews[index]["text"],
                          overflow: TextOverflow.fade,
                          style: textStyle.copyWith(
                              fontSize: 12,
                              color: white
                          ),),
                        trailing: Container(
                          width: 70,
                          child: Row(
                            children: [

                          GestureDetector(
                          child: Icon(Icons.edit_outlined,
                                color: amber,),
                                onTap: (){

                                Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) {
                                return UpdatePoster(
                                name: postNews[index]['name'],
                                imageURL: postNews[index]['fileName'],
                                description: postNews[index]['text'],
                                  token: widget.token,
                                  arId: postNews[index]['id'],
                                  currentId: widget.currentId,
                                  videoURL: postNews[index]['videoUrl'],
                                );
                                })).then((value) => getData());
                                },
                                ),
                              GestureDetector(
                                onTap: (){

                                    Map<String,String> header ={
                                    'Content-type':'application/json',
                                    'Accept':'application/json',
                                    'Authorization':'${widget.token}'
                                    };

                                    int id = postNews[index]["id"];
                                    print(id);
                                    String u = "$url"+"/articles/"+"$id";
                                    http.delete(u,headers: header).then((value) => {
                                    print(value.statusCode),
                                      getData()
                                    });
                                  },
                                  child: Icon(Icons.delete_outline,
                                    color: amber,),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),


            ],
          ),
        ),
      ),
    );
  }
}


// ignore: must_be_immutable
class NewsFeedTile extends StatelessWidget {

  final String name;
  final String description;

  NewsFeedTile({this.name,this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 5
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: grey.withOpacity(0.2)
            )
          ]
      ),
      child: ListTile(
        onTap: (){
          // Navigator.pushNamed(context, NewsDetailScreen.id);
        },
        // isThreeLine: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
              style: textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: amber,
                  fontSize: 18
              ),
            ),
          ],
        ),
        subtitle: Text(description,
          overflow: TextOverflow.fade,
          style: textStyle.copyWith(
              fontSize: 12,
              color: white
          ),),
        trailing: IconButton(
            icon: Icon(Icons.delete_outline,
              color: amber,),
            onPressed: (){

            }),
      ),
    );
  }
}
