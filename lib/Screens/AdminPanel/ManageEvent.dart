import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/AdminPanel/UpdateEvent.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:signalr_client/hub_connection.dart';
import 'dart:convert' as convert;

import 'package:signalr_client/hub_connection_builder.dart';

class ManageEvent extends StatefulWidget {

  final token;
  final currentUser;

  ManageEvent({this.token, this.currentUser});
  @override
  _ManageEventState createState() => _ManageEventState();
}

class _ManageEventState extends State<ManageEvent> {


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
      // getData();
    });
    super.initState();

  }

  // static String url = 'https://bursa.8mindsolutions.com/api';
  static JsonDecoder _decoder = JsonDecoder();
  // String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();
  List<dynamic> chatMessage;

  static JsonDecoder decoder = JsonDecoder();

  TextEditingController eventName = TextEditingController();
  TextEditingController ticketPrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController eventStartDate = TextEditingController();

  Future<void> createSignalRConnection() async {


    connection =
        HubConnectionBuilder().withUrl("$imgUrl/chatHub?userId=${widget.currentUser}").build();
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

    var img = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imgPath = img.path;
      _img = img;
    });
  }

  String startDate = 'Event Start Date & Time';
  String endDate = 'Event End Date & Time';

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: black,
        centerTitle: true,
        title: Text('Manage\'s Event',
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
              Text('Create Event:',
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
                          height: 10,
                        ),
                        Text('Please upload images of size of 400x300 and video of size 5 mb',
                          style: textStyle.copyWith(
                              fontSize: 12,
                              color: amber
                          ),),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
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
                                child: Icon(Icons.video_call),),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: RaisedButton(onPressed: () async{

                            if(eventName.text.isNotEmpty && ticketPrice.text.isNotEmpty && description.text.isNotEmpty ){

                              String u = "$url"+"/event/";

                              Map<String,String> header ={
                                'Content-type':'application/json',
                                'Accept':'application/json',
                                'Authorization':'${widget.token}'
                              };

                              Map data = {
                                "Name": eventName.text,
                                "StartDate":startDate,
                                "EndDate":endDate,
                                "Price":ticketPrice.text,
                                "Description":description.text
                              };

                              var sb=convert.json.encode(data);

                              http.post(u,headers:header, body: sb).then((value) async{
                                print(value.statusCode);

                                if(value.statusCode >= 200 && value.statusCode <300){

                                  Map data = decoder.convert(value.body);
                                  List val = data.values.toList();

                                  if(_video != null){
                                    String fileName1 = _video.path.split('/').last;

                                    FormData formData = FormData.fromMap({
                                      "file": await MultipartFile.fromFile(_video.path, filename:fileName1),
                                    });
                                    print("XXXXX");
                                    await dio.post("$url/event/UploadEventVideo/${val[0]}",data: formData).then((value) {
                                      int code = value.statusCode;
                                      print("asdsadsadsad$code");
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(content: Text('Video Uploaded')));
                                    });
                                    print(_img);
                                  }

                                  if(_img != null){
                                    print("ssss");
                                    String fileName1 = _img.path.split('/').last;

                                    FormData formData = FormData.fromMap({
                                      "file": await MultipartFile.fromFile(_img.path, filename:fileName1),
                                    });
                                    await dio.post("$url/event/UploadEventImage/${val[0]}",data: formData).then((value) {
                                      int code = value.statusCode;
                                      print("sdsdss$code");
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(content: Text('Image Uploaded ')));
                                    });


                                  }

                                      Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text('Event Created')));


                                  print(eventName.text);
                                  print(widget.currentUser);
                                  print(val[0]);
                                  await connection.invoke("SendNotification",args: [eventName.text,widget.currentUser,true, val[0]]);
                                }
                              });
                            }
                          },
                            color: amber,
                            child: Text('Create Event',
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
              // Text('Event\'s List:',
              //   style: textStyle.copyWith(
              //       fontSize: 18,
              //       color: amber
              //   ),),
              // Container(
              //   width: media.width,
              //   child: ListView(
              //     shrinkWrap: true,
              //     physics: NeverScrollableScrollPhysics(),
              //     children: [
              //       Container(
              //         margin: EdgeInsets.symmetric(
              //             vertical: 5
              //         ),
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             boxShadow: [
              //               BoxShadow(
              //                   color: grey.withOpacity(0.2)
              //               )
              //             ]
              //         ),
              //         child: ListTile(
              //           trailing: Container(
              //             width: 70,
              //             child: Row(
              //               children: [
              //                 GestureDetector(
              //                   child: Icon(Icons.edit_outlined,
              //                     color: amber,),
              //                   onTap: (){
              //
              //                     Navigator.push(context,
              //                         MaterialPageRoute(builder: (BuildContext context) {
              //                       return UpdateEvent();
              //                     }));
              //                   },
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 GestureDetector(
              //                   child: Icon(Icons.delete_outline,
              //                     color: amber,),
              //                   onTap: (){
              //
              //                   },
              //                 ),
              //               ],
              //             ),
              //           ),
              //           leading: Text('Event Name',
              //             style: textStyle.copyWith(
              //                 fontSize: 18,
              //                 color: amber
              //             ),),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
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
