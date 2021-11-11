import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';
import 'package:http/http.dart' as http;
import '../../Constant.dart';

class UpdatePoster extends StatefulWidget {

  static const id = 'UpdatePoster';

  final token;
  final currentId;
  final name;
  final description;
  final imageURL;
  final videoURL;
  final userId;
  final arId;

  UpdatePoster({this.name, this.description, this.imageURL, this.videoURL, this.token, this.currentId, this.arId, this.userId});

  @override
  _UpdatePosterState createState() => _UpdatePosterState();
}

class _UpdatePosterState extends State<UpdatePoster> {
  HubConnection connection;
  TextEditingController messageController = TextEditingController();



  Future<void> createSignalRConnection() async {


    connection =
        HubConnectionBuilder().withUrl("https://bursa.8mindsolutions.com/chatHub?userId=${widget.currentId}").build();
    await connection.start().then((value) {
      print("started");
    });
//    connection.invoke("BroadCastMessage");
    connection.on("broadcastMessage", ([message, senderId]){
      print(message);
      print(senderId);
      // getData();
    });
  }
  // static String url = 'https://bursa.8mindsolutions.com/api';
  // String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();
  List<dynamic> chatMessage;



  TextEditingController eventName = TextEditingController();
  TextEditingController ticketPrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController eventStartDate = TextEditingController();

  String startDate = 'Event Start Date & Time';
  String endDate = 'Event End Date & Time';

  @override
  void initState() {
    // TODO: implement initState
    setState(() {

      eventName.text = widget.name;
      description.text = widget.description;

      print(widget.description);
    });
    createSignalRConnection();
    super.initState();
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

  File _img;
  String _imgPath = '';

  Future getImage() async {

    var video = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      print(video.path);
      _imgPath = video.path;
      _img = video;
    });
  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: black,
        centerTitle: true,
        title: Text('Update Post',
          style: textStyle.copyWith(
            fontSize: 18,
            color: amber,
          ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
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
            Card(
              child: Container(
                width: media.width,
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
                          controller: eventName,
                          decoration: InputDecoration(
                            hintText: 'Event Name',
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
                            hintText: 'Description',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Center(
                            child: RaisedButton(onPressed: (){

                              getImage();
                            },
                              color: amber,
                              child: Icon(Icons.add_a_photo_outlined),),
                          ),
                          Center(
                            child: RaisedButton(onPressed: (){

                              getImage1();
                            },
                              color: amber,
                              child: Icon(Icons.video_call)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Builder(builder: (BuildContext context) {
                          return RaisedButton(onPressed: (){

                            print(widget.arId);

                            String u = "$url"+"/articles/";


                            Map<String,String> header ={
                              'Content-type':'application/json',
                              'Accept':'application/json',
                              'Authorization':'${widget.token}'
                            };

                            Map data = {
                              "Id": widget.arId,
                              "Name": eventName.text,
                              "Text": description.text,
                              "UserId": widget.currentId,
                              "FileName": widget.imageURL,
                              "VideoUrl": widget.videoURL
                            };

                            var sb=jsonEncode(data);

                            http.put(u,headers: header, body: sb).then((value)async{
                              print(value.statusCode);


                              Map valu =  jsonDecode(value.body);
                              List val = valu.values.toList();

                              print(val[0]);


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

                              if(_img != null){

                                var headers = {
                                  'Authorization': 'Bearer ${widget.token}'
                                };
                                var request = http.MultipartRequest('POST', Uri.parse('$url/articles/UploadPicture/${val[0]}'));
                                request.files.add(await http.MultipartFile.fromPath('file', '${_img.path}'));
                                request.headers.addAll(headers);

                                http.StreamedResponse response = await request.send();

                                print("image${response.statusCode}");
                                if (response.statusCode == 200) {

                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text('Updated')));
                                }
                                else {
                                  print(response.reasonPhrase);
                                }

                              }
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text('Updated')));
                              await connection.invoke("SendNotification",args: [eventName.text,widget.currentId, false, widget.arId]);
                            });
                          },
                            color: amber,
                            child: Text('Update Poster',
                              style: textStyle.copyWith(
                                  fontSize: 18,
                                  color: black
                              ),),);
                        },

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
