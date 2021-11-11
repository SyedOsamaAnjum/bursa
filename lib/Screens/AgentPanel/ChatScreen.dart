import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:signalr_client/signalr_client.dart';
//import 'package:signalr_core/signalr_core.dart';
import 'package:logging/logging.dart';
import 'package:signalr_client/http_connection_options.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';
import 'package:http/http.dart' as http;
import '../../Constant.dart';

class ChatScreen extends StatefulWidget {

  static const id = 'ChatScreen';

  final currentUser;
  final agentId;
  final AccessToken;

  ChatScreen({this.currentUser,this.agentId,this.AccessToken});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  // String serverUrl = "https://bursa.8mindsolutions.com";
// Creates the connection by using the HubConnectionBuilder.
//   final hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();

//   connection.close()
  List<String> chats;

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

  // static String url = 'https://bursa.8mindsolutions.com/api';
  static JsonDecoder _decoder = JsonDecoder();
 // String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();
  List<dynamic> chatMessage;

  Future<List<String>> getData() {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.AccessToken}'
    };

    String u = "$url"+"/chat/${widget.agentId}/${widget.currentUser}";

    return http.get(u,headers: header).then((response){
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {

        chatMessage= _decoder.convert(response.body);
//        print(user);

        // chatMessage = user.where((element) => element['recieverId'] == widget.currentUser).toList();
       print(chatMessage);

      });

      return [];
    });

  }

  HubConnection connection;

  Future<void> createSignalRConnection() async {

  print("userId ${widget.currentUser}");
  print("agent Id ${widget.agentId}");
    connection =
        HubConnectionBuilder().withUrl("$imgUrl/chatHub?userId=${widget.currentUser}").build();
    await connection.start().then((value) {
      print("started");
    });
//    connection.invoke("BroadCastMessage");
    connection.on("broadcastMessage", ([message, senderId]){
    print(message);
    print(senderId);
    getData();
    });
  }

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('Client Name',
          style: textStyle.copyWith(
            fontSize: 18,
            color: amber,
          ),),
      ),
      body: chatMessage == null? Column(
        children: [
        Text('No Agent Assigned',
        style: textStyle.copyWith(
          fontSize: 18,
          color: amber
        ),)
        ],
      ):Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 80),
                  height: media.height * 0.9,
                  child: ListView.builder(
                    reverse: false,
                    itemCount: chatMessage.length,
                    itemBuilder: (BuildContext context, int index) {
                      return (widget.agentId == chatMessage[index]['senderId'])?
                      Padding(
                        padding: EdgeInsets.only(right: 100),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),bottomRight: Radius.circular(30)),),
                          elevation: 5.0,
                          color:  white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Text(chatMessage[index]['messageText'],
                              textAlign: TextAlign.start,
                              style: textStyle.copyWith(
                                  color: black
                              ),),
                          ),
                        ),
                      ):
                      Padding(
                        padding: EdgeInsets.only(left: 100),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),bottomLeft: Radius.circular(30)),),
                          elevation: 5.0,
                          color: grey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Text(chatMessage[index]['messageText'],
                              textAlign: TextAlign.end,
                              style: textStyle.copyWith(
                                  color: black
                              ),),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              width: media.width,
             // height: media.height * 0.0959,
              color: black,
              padding: EdgeInsets.all(8.0),
              child: Theme(
                data: ThemeData(
                    primaryColor: amber
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: messageController,
                    style: textStyle.copyWith(
                        fontSize: 16,
                        color: amber
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: amber
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                              color: amber
                          )
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.send,
                            color: amber,
                          ),
                          onPressed: ()async{
                            {
                              var user = '';
                              String message = messageController.text;
                              print(message);
                              await connection.invoke("Send",args: [message,widget.currentUser,widget.agentId]);
                              messageController.clear();
                              getData();

                            }
                          }),
                      hintText: 'Send Message',
                      hintStyle: textStyle.copyWith(
                          fontSize: 16,
                          color: amber
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
