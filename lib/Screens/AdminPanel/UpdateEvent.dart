import 'dart:convert';
import 'dart:io';

import 'package:bursa_app/Screens/VideoPlayerScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../Constant.dart';
import '../EventVideoPlayer.dart';

class UpdateEvent extends StatefulWidget {
  static const id = 'UpdateEvent';

  final eventName;
  final startDate;
  final endTime;
  final video;
  final img;
  final price;
  final description;
  final currentId;
  final token;
  final eventId;

  UpdateEvent(
      {this.eventName,
      this.startDate,
      this.endTime,
      this.price,
      this.description,
      this.video,
      this.img,
      this.currentId,
      this.token,
      this.eventId});
  @override
  _UpdateEventState createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {
  HubConnection connection;
  TextEditingController messageController = TextEditingController();

  Future<void> createSignalRConnection() async {
    connection = HubConnectionBuilder()
        .withUrl(
            "$imgUrl/chatHub?userId=${widget.currentId}")
        .build();
    await connection.start().then((value) {
      print("started");
    });
//    connection.invoke("BroadCastMessage");
    connection.on("broadcastMessage", ([message, senderId]) {
      print(message);
      print(senderId);
      // getData();
    });
  }

  // static String url = 'https://bursa.8mindsolutions.com/api';
  // String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();
  List<dynamic> chatMessage;
  List gtList;

  TextEditingController eventName = TextEditingController();
  TextEditingController ticketPrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController eventStartDate = TextEditingController();

  String startDate = 'Event Start Date & Time';
  String endDate = 'Event End Date & Time';

  Future<List<String>> getUsers() async{

    var headers = {
      'Authorization': '${widget.token}'
    };
    http.get('$url/event/GetUserOfEvents/${widget.eventId}', headers: headers).then((value) {

      print(value.statusCode);

      if (value.statusCode == 200) {
        setState(() {
          gtList = jsonDecode(value.body);
        });
      }
      else {
        print(value.reasonPhrase);
      }

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      eventName.text = widget.eventName;
      description.text = widget.description;
      ticketPrice.text = widget.price.toString();
      startDate = widget.startDate;
      endDate = widget.endTime;
    });
    createSignalRConnection();
    getUsers();

    setState(() {
      widget.video == null ? vis = false : vis = true;
    });
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
      _imgPath = video.path;
      _img = video;
    });
  }

  bool vis = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: black,
          centerTitle: true,
          title: Text(
            'Manage\'s Event',
            style: textStyle.copyWith(
              fontSize: 18,
              color: amber,
            ),
          ),
          bottom: TabBar(
              isScrollable: true,
              labelColor: amber,
              indicatorColor: Colors.transparent,
              labelStyle: TextStyle(fontSize: 12, color: amber),
              unselectedLabelColor: grey,
              unselectedLabelStyle: TextStyle(fontSize: 12, color: grey),
              tabs: [
                Container(
                  height: 20,
                  child: Text('Event Info'),
                ),
                Container(
                  height: 20,
                  child: Text('Guest List'),
                ),
              ]),
        ),
        body: TabBarView(
          children: [
        SingleChildScrollView(
        child: Column(
        children: [
          SizedBox(
          height: 20,
        ),
        Card(
          child: Container(
            width: media.width,
            height: 150,
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
                  widget.img == null? Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Text('No Image'),
                  ):Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network('$imgUrl/resources/events/${widget.img}',
                      fit: BoxFit.cover,),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: vis,
                    child: RaisedButton(
                      color: amber,
                      onPressed: (){

                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return VideoPlayerScreen(name: widget.eventName,video: widget.video,);
                        },));
                      },
                      child: Text('View Video'),
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
                      controller: eventName,
                      decoration: InputDecoration(
                        hintText: 'Event Name',
                      ),
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                        primaryColor: amber
                    ),
                    child: TextField(
                      readOnly: true,
                      onTap: (){

                        DatePicker.showDateTimePicker(context, showTitleActions: true, onChanged: (date) {
                          print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          setState(() {
                            startDate = date.toString();
                          });
                        }, currentTime: DateTime.now());

                      },
                      decoration: InputDecoration(
                        hintText: '$startDate',
                      ),
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                        primaryColor: amber
                    ),
                    child: TextField(
                      readOnly: true,
                      onTap: (){

                        DatePicker.showDateTimePicker(context, showTitleActions: true, onChanged: (date) {
                          print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          setState(() {
                            endDate = date.toString();
                          });
                        }, currentTime: DateTime.now());

                      },
                      decoration: InputDecoration(
                        hintText: '$endDate',
                      ),
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                        primaryColor: amber
                    ),
                    child: TextField(
                      controller: ticketPrice,
                      decoration: InputDecoration(
                        hintText: 'Ticket Price',
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
                        hintText: 'Event Description',
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

                        },
                          color: amber,
                          child: Icon(Icons.video_call_outlined),),
                      ),
                      Center(
                        child: RaisedButton(onPressed: (){

                        },
                          color: amber,
                          child: Icon(Icons.add_a_photo_outlined),),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: RaisedButton(onPressed: (){

                      String u = "$url"+"/event/";

                      Map<String,String> header ={
                        'Content-type':'application/json',
                        'Accept':'application/json',
                        'Authorization':'${widget.token}'
                      };

                      Map data = {
                        "Id": widget.eventId,
                        "Name": eventName.text,
                        "StartDate":endDate,
                        "EndDate":startDate,
                        "Price": ticketPrice.text,
                        "Description": description.text,
                        "imageURL": widget.img,
                        "videoURL": widget.video
                      };

                      var sb=convert.json.encode(data);

                      http.put(u,headers:header, body: sb).then((value) async{
                        print(value.statusCode);

                        if(value.statusCode >= 200 && value.statusCode <300){

                          Map data = jsonDecode(value.body);
                          List val = data.values.toList();

                          if(_video != null){
                            String fileName1 = _video.path.split('/').last;

                            FormData formData = FormData.fromMap({
                              "file": await MultipartFile.fromFile(_video.path, filename:fileName1),
                            });
                            await dio.post("$url/event/UploadEventVideo/${val[0]}",data: formData).then((value) {
                              int code = value.statusCode;
                              print(code);
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text('Video Uploaded')));
                            });
                          }
                          if(_img != null){
                            String fileName1 = _img.path.split('/').last;

                            FormData formData = FormData.fromMap({
                              "file": await MultipartFile.fromFile(_img.path, filename:fileName1),
                            });
                            await dio.post("$url/event/UploadEventImage/${val[0]}",data: formData).then((value) {
                              int code = value.statusCode;
                              print(code);

                            });
                          }
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Updated ')));
                          await connection.invoke("SendNotification",args: [eventName.text,widget.currentId,true, widget.eventId]);
                        }
                      });

                    },
                      color: amber,
                      child: Text('Update Event',
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
        ],
      ),
    ),
    ListView.builder(
      itemCount: gtList.length == null? 0: gtList.length,
      itemBuilder: (BuildContext context, int index) {

        Map data = gtList[index]['user'];
        List userList = data.values.toList();

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
            title: Text(userList[index]["username"],
              style: textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: amber,
                  fontSize: 18
              ),
            ),
            subtitle: Text("Email : ${userList[index]["email"]}",
              style: textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: amber,
                  fontSize: 12
              ),
            ),
          ),
        );
      },)
          ],
        ),
      ),
    );
  }
}
