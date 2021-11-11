import 'dart:convert';
import 'dart:typed_data';

import 'package:bursa_app/Screens/BottomNavigation/stripePayment.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
import '../Constant.dart';
import 'package:http/http.dart' as http;
import 'EventVideoPlayer.dart';
import 'VideoPlayerScreen.dart';

class EventDetailScreen extends StatefulWidget {

  static const id = 'EventDetailScreen';

  final name;
  final content;
  final imageURL;
  final author;
  final videoURL;
  final token;
  final eventId;
  final email;
  final startDate;
  final endDate;


  EventDetailScreen({this.name, this.content, this.imageURL, this.author, this.videoURL, this.token, this.eventId, this.email, this.startDate, this.endDate});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {



  bool vis = false;
  bool visible = true;
  Uint8List bytes = Uint8List(12);
  bool status;

  Future<void> loadStatus() {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.token}'
    };

    print(widget.eventId);

    String u = "$url"+"/event/CheckUserEventExists/${widget.eventId}";
    return http
        .get(u,headers: header)
        .then((response) async{
      print("Status: ${response.statusCode}");

      if(response.statusCode >=200 && response.statusCode < 300){

        setState(() {
          status = jsonDecode(response.body);

          print(status);


        });
        if(status == true){
          setState(() {
            vix = true;
            x = widget.eventId.toString();
          });
          visible = false;
        }


      }
    }).catchError((e) {
      print(e);
    });
  }
  @override
  void initState() {
    //
    // Stripe.init(_stripePublishableKey, returnUrlForSca: _returnUrl);
    loadStatus();
    setState(() {
      widget.videoURL == null? vis = false: vis = true;
    });
    // TODO: implement initState
    super.initState();
  }

  String x;
  bool vix = false;

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
      floatingActionButton: Visibility(
        visible: visible,
        child: FloatingActionButton(
          foregroundColor: amber,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return Payment(token: widget.token,price: widget.author, email: widget.email, eventId: widget.eventId,);
            })).then((value) async{

                  visible = value;
                  if(visible == false) {
                    setState(() {
                      vix = true;
                      x = widget.eventId.toString();
                    });
                  }});
            },
        child: Icon(Icons.credit_card,
        color: black,
        ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.name,
                style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: white
                ),),
              SizedBox(
                height: 10,
              ),
              widget.imageURL == null? Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Text('No Image'),
              ):Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Image.network('https://bursa.8mindsolutions.com/resources/events/${widget.imageURL}'),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Price '+widget.author,
                    style: textStyle.copyWith(
                        fontSize: 18,
                        color: amber
                    ),),
                  Visibility(
                    visible: vis,
                    child: RaisedButton(
                      color: amber,
                        onPressed: (){

                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return EventVideoPlayer(name: widget.name,video: widget.videoURL,);
                          },));
                        },
                    child: Text('View Video'),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text('Start Date: ${widget.startDate}',
              style: textStyle.copyWith(
                fontSize: 12,
                  color: white
              ),),
              Text('End Date: ${widget.endDate}',
                style: textStyle.copyWith(
                  fontSize: 12,
                  color: white
                ),),
              Container(
                child: Text("Description: ${widget.content}",
                  style: textStyle.copyWith(
                      fontSize: 14,
                      color: white
                  ),),
              ),
              SizedBox(
                height: 20,
              ),
              Visibility(
                visible: vix,
                child: QrImage(
                  foregroundColor: white,
                  data: x,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
