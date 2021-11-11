import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:bursa_app/Constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../VideoPlayerScreen.dart';

class UploadVideo extends StatefulWidget {

  final token;

  UploadVideo({this.token});
  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {


  @override
  void initState() {
    setState(() {
      getData();
    });
    super.initState();
  }


  static JsonDecoder _decoder = JsonDecoder();
  //String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();
  List<dynamic> postVideo;


  Future<List<String>> getData() {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.token}'
    };

    String u = "$url"+"/videotutorials/";
    return http.get(u,headers: header).then((response){
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {
        postVideo = _decoder.convert(response.body);
        print(postVideo);
      });

      return [];
    });
  }

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  File _video;
  String _videoPath = '';

  Future getImage1() async {

    var video = await ImagePicker.pickVideo(source: ImageSource.gallery);

    setState(() {
      _videoPath = video.path;
      _video = video;
    });
  }

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: black,
        centerTitle: true,
        title: Text('Upload Video',
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
              Text('Upload Video:',
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
                  height: media.height * 0.4,
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
                              hintText: 'Description',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Expanded(
                            //   child: Container(
                            //     height: 40,
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(5),
                            //       border: Border.all(color: amber,
                            //           width: 2)
                            //     ),
                            //     child: Center(
                            //       child: Text('$_videoPath',
                            //       overflow: TextOverflow.fade,
                            //       style: textStyle.copyWith(
                            //         fontSize: 12,
                            //       ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            RaisedButton(onPressed: (){
                              getImage1();
                            },
                              color: amber,
                              child: Icon(Icons.video_call))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: RaisedButton(
                            onPressed: ()async{

                            String fileName1 = _video.path.split('/').last;
//                              String fileName2 = _image2.path.split('/').last;
//                              String fileName3= _image3.path.split('/').last;
//                              String fileName4 = _image4.path.split('/').last;
                            FormData formData = FormData.fromMap({
                              "file": await MultipartFile.fromFile(_video.path, filename:fileName1),
                              "Title": title.text,
                              "Description": description.text,
//                                [await MultipartFile.fromFile(_image1.path, filename:fileName1),
//                                  await MultipartFile.fromFile(_image2.path, filename:fileName2),
//                                  await MultipartFile.fromFile(_image3.path, filename:fileName3),
//                                  await MultipartFile.fromFile(_image4.path, filename:fileName4)],
                            });
                            await dio.post("$url/videotutorials",data: formData).then((value) {
                              int code = value.statusCode;
                              print(code);

                              getData();
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text('Video Uploaded')));
                            });
                          },
                            color: amber,
                            child: Text('Submit Tutorial',
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
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: postVideo == null ? 0 : postVideo.length,
                  itemBuilder: (BuildContext context, int index){
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
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return VideoPlayerScreen(name: postVideo[index]["title"],video: postVideo[index]["fileName"],);
                          },));
                        },
                        // isThreeLine: true,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(postVideo[index]["title"],
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: amber,
                                  fontSize: 18
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(postVideo[index]["description"],
                          overflow: TextOverflow.fade,
                          style: textStyle.copyWith(
                              fontSize: 12,
                              color: white
                          ),),
                        trailing: IconButton(
                            icon: Icon(Icons.delete_outline,
                              color: amber,),
                            onPressed: (){

                              Map<String,String> header ={
                                'Content-type':'application/json',
                                'Accept':'application/json',
                                // 'Authorization':'$Token'
                              };

                              int id = postVideo[index]["id"];
                              print(id);
                              String u = "$url"+"/videotutorials/"+"$id";
                              http.delete(u,headers: header).then((value) => {
                                print(value.statusCode)
                              });
                            }),
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